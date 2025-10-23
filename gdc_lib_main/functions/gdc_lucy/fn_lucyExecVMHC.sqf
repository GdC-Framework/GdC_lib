/*
	Author: Mystery

	Description:
	Execute a secure HC spawn of units

	Parameter(s):
		0 : STRING - script to execute
		1 : ARRAY (optionnal) - arguments for the script

	Returns:
    nothing
*/
params[
	"_arg_script",
	["_arg_args",[],[[]]]
];
private["_result"];


if (LUCY_LOCAL_SPAWN_UNIT) then {
    _arg_args execVM _arg_script;
};
