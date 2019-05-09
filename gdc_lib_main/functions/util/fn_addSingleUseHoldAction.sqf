/*
	Description:
		Add an action for all user, that should be use only one time.
		That's mean, when a user use the action, it will be destroy for all of them.

		/!\ HAS TO BE CALLED FROM SERVER /!\

	Parameter(s):
		See full parameters on https://community.bistudio.com/wiki/BIS_fnc_holdActionAdd
			Example params 
			[
				_myLaptop,											// Object the action is attached to
				"Hack Laptop",										// Title of the action
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
				"_this distance _target < 3",						// Condition for the action to be shown
				"_caller distance _target < 3",						// Condition for the action to progress
				{},													// Code executed when action starts
				{},													// Code executed on every progress tick
				{ _this call MY_fnc_hackingCompleted },				// Code executed on completion
				{},													// Code executed on interrupted
				[],													// Arguments passed to the scripts as _this select 3
				12,													// Action duration [s]
				0,													// Priority
				true,												// Remove on completion
				false												// Show in unconscious state 
			]

	Returns:
		string: Return the Action ID like holdActionAdd
*/

if (!isServer) exitWith {};

params["_obj", "", "", "", "", "", 
	["_codeStart", {}], ["_codeProgress", {}], ["_codeCompleted", {}], ["_codeInterrupted", {}],
	["_arguments", []]];

private["_newThis", "_title", "_uid", "_uniqueIndex", "_functionHeader", "_newFunction"];
_newThis = +_this;

_uniqueIndex = _obj getVariable ["GDC_SingleUseHoldAction_Index", 0];
// Increment for next action
_obj setVariable ["GDC_SingleUseHoldAction_Index", _uniqueIndex + 1, true];


_newFunction = "";
_functionHeader = "
	params [""_target"", ""_caller"", ""_actionId"", ""_arguments""];
	_arguments params [""_varName"", ""_internalArguments""];
";

if(typeName _codeCompleted == "STRING") then {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] execVM """ + _codeCompleted + """;
	"; 
} else {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] call (compile " + (str (_codeCompleted call GDC_fnc_expressionToString)) + ");
	"; 
};

_newFunction = _newFunction + "
	[[_target, _varName], {
		params[""_target"", ""_varName""];
		[_target, _target getVariable [_varName, -1]] call BIS_fnc_holdActionRemove;
	}] remoteExec [""call"", 0];
";

// Update the new function
_newThis set [8, compile _newFunction];

// Update codeStart
_newFunction = "";
if(typeName _codeStart == "STRING") then {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] execVM """ + _codeStart + """;
	"; 
} else {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] call (compile " + (str (_codeStart call GDC_fnc_expressionToString)) + ");
	"; 
};

_newThis set [6, compile _newFunction];

// Update _codeInterrupted
_newFunction = "";
if(typeName _codeInterrupted == "STRING") then {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] execVM """ + _codeInterrupted + """;
	"; 
} else {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments] call (compile " + (str (_codeInterrupted call GDC_fnc_expressionToString)) + ");
	"; 
};

_newThis set [9, compile _newFunction];


// Update codeProgress
_newFunction = "";
_functionHeader = "
	params [""_target"", ""_caller"", ""_actionId"", ""_arguments"", ""_progress"", ""_maxProgress""];
	_arguments params [""_varName"", ""_internalArguments""];
";

if(typeName _codeProgress == "STRING") then {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments, _progress, _maxProgress] execVM """ + _codeProgress + """;
	"; 
} else {
	_newFunction = _functionHeader + "
		[_target, _caller, _actionId, _internalArguments, _progress, _maxProgress] call (compile " + (str (_codeProgress call GDC_fnc_expressionToString)) + ");
	"; 
};

_newThis set [7, compile _newFunction];


// _uid = _obj call GDC_fnc_getUniqueId;
// _uid = _uid + _title;
_varName = "GDC" + "-singleUseHoldAction-" + (str _uniqueIndex);
_newThis set [10, [_varName, _arguments]];

[[_obj, _newThis, _varName], {
	params["_obj", "_params", "_varName"];

	_action = _params call BIS_fnc_holdActionAdd;
	_obj setVariable [_varName, _action];
}] remoteExec ["call", 0];

