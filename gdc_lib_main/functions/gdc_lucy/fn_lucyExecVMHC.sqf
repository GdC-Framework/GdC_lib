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

nul = [_arg_script] spawn {
    if (LUCY_LOCAL_SPAWN_UNIT) then {
        private["_result"];
        _result = [] execVM (this select 0);
        waitUntil {scriptDone _result};
    };
};