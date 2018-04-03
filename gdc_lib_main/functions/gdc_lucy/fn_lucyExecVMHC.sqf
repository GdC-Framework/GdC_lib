/*
	Author: Mystery

	Description:
	Execute a secure HC spawn of units

	Parameter(s):
		0 : STRING - script to execute

	Returns: 
    nothing
*/
params["_arg_script"];
private["_result"];


if (LUCY_LOCAL_SPAWN_UNIT) then {
    [] execVM _arg_script;
};
