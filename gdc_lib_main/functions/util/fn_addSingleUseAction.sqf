/*
	Description:
		Add an action for all user, that should be use only one time.
		That's mean, when a user use the action, it will be destroy for all of them.

		/!\ HAS TO BE CALLED FROM SERVER /!\
		[OBJECT, [" TITLE ", { Function }]] call GDC_fnc_addSingleUseAction;

	Parameter(s):
		0 : OBJECT - Object where we want to add the action
		1 : ARRAY - All params for AddAction => See full parameters on https://community.bistudio.com/wiki/addAction

			Default params 
			[
				"<title>", 
				{
					params ["_target", "_caller", "_actionId", "_arguments"];
				},
				[],
				1.5, 
				true, 
				true, 
				"",
				"true", // _target, _this, _originalTarget
				50,
				false,
				"",
				""
			]

	Returns:
		string: Return the Action ID like AddAction
*/

params["_obj", "_addActionParams"];
_addActionParams params[
	["_title", nil], 
	["_function", {}], 
	["_arguments", []]
];

private["_varName", "_newFunction"], "_uniqueIndex";

if (!isServer) exitWith {};

_uniqueIndex = _obj getVariable ["GDC_SingleUseAction_Index", 0];
// Increment for next action
_obj setVariable ["GDC_SingleUseAction_Index", _uniqueIndex + 1, true];

_newFunction = "
	params [""_target"", ""_caller"", ""_actionId"", ""_arguments""];
	_arguments params [""_varName"", ""_internalArguments""];
";

if(typeName _function == "STRING") then {
	_newFunction = _newFunction + "
		[_target, _caller, _actionId, _internalArguments] execVM """ + _function + """;
	"; 
} else {
	_newFunction = _newFunction + "
		[_target, _caller, _actionId, _internalArguments] call (compile " + (str (_function call GDC_fnc_expressionToString)) + ");
	"; 
};

_newFunction = _newFunction + "
	[[_target, _varName], {
		params[""_target"", ""_varName""];
		_target removeaction (_target getVariable [_varName, nil]);
	}] remoteExec [""call"", 2];
";

// Update the addActions arguments with the new function
if ((count _addActionParams) >= 2) then {
	_addActionParams set [1, compile _newFunction];
} else {
	_addActionParams pushBack (compile _newFunction);
};

// _uid = _obj call GDC_fnc_getUniqueId;
// _uid = "GDC" + "-" + _uid + "-" + (str _uniqueIndex);
_varName = "GDC" + "-singleUseAction-" + (str _uniqueIndex);

// Update the addActions arguments with the needed arguments
if ((count _addActionParams) >= 3) then {
	_addActionParams set [2, _varName];
} else {
	_addActionParams pushBack [_varName, _arguments];
};

[
	[
		_obj, 
		_addActionParams, 
		_uid
	], 
	{
		params["_obj", "_addActionParams", "_varName"];

		_action = _obj addAction _addActionParams;
		_obj setVariable [_varName, _action];
	}
] remoteExec ["call", 2];

