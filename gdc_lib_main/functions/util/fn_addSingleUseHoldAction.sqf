/*
	Author: Shinriel

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

private["_obj", "_title", "_uid", "_function", "_newFunction"];
_obj = _this select 0;
_title = _this select 1;
_function = _this select 8;

_newFunction = "
	params [""_target""];
	private[""_uid""];
";

if(typeName _function == "STRING") then {
	_newFunction = _newFunction + "
		_this execVM """ + _function + """;
	"; 
} else {
	_newFunction = _newFunction + "
		_this call (compile " + (str (_function call GDC_fnc_expressionToString)) + ");
	"; 
};

_newFunction = _newFunction + "
	_uid = _target call GDC_fnc_getUniqueId;
	_uid = _uid + """ + _title + """;
	[[_target, _uid], {
		params[""_target"", ""_uid""];
		[_target, parseNumber (missionNamespace getVariable [_uid, nil])] call BIS_fnc_holdActionRemove;
	}] remoteExec [""call"", 2];
";

// Update the new function
_this set [8, compile _newFunction];

_uid = _obj call GDC_fnc_getUniqueId;
_uid = _uid + _title;

[[_this, _uid], {
	params["_params", "_uid"];

	_action = _params call BIS_fnc_holdActionAdd;
	missionNamespace setVariable [_uid, str _action];
}] remoteExec ["call", 2];

