/*
	Author: Shinriel

	Description:
		Add an action for all user, that should be use only one time.
		That's mean, when a user use the action, it will be destroy for all of them.

		/!\ HAS TO BE CALLED FROM SERVER /!\

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
_addActionParams params["_title", ["_function", {}]];
private["_uid", "_newFunction"];

if (!isServer) exitWith {};

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
		_target removeaction (missionNamespace getVariable [_uid, nil]);
	}] remoteExec [""call"", 2];
";

// Update the new function
_addActionParams set [1, compile _newFunction];

_uid = _obj call GDC_fnc_getUniqueId;
_uid = _uid + _title;

[[_obj, _addActionParams, _uid], {
	params["_obj", "_addActionParams", "_uid"];

	_action = _obj addAction _addActionParams;
	missionNamespace setVariable [_uid, _action];
}] remoteExec ["call", 2];

