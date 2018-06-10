/*
	Author: Mystery

	Description:
	Execute a secure HC, when you don't have a context to call it (example from a client, an action from an objet or character, ...)

	Parameter(s):
		0 : STRING - script to execute

	Returns: 
    nothing
*/
params["_arg_script"];
private["_result"];

// Send to all client, GDC_fnc_lucyExecVMHC will only execute on HC
{[_arg_script] call GDC_fnc_lucyExecVMHC;} remoteExec ["call"];
