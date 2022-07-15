/*
	Author: Mystery

	Description:
	Execute a secure HC, when you don't have a context to call it (example from a client, an action from an objet or character, ...)

	Parameter(s):
		0 : STRING - script to execute

	Returns:
	true if launched on the HC, false if not
*/
params["_arg_script"];

private ["_hc_netid", "_return"];

try {
	// Recovering HC
	_hc_netid = owner (entities "HeadlessClient_F" #0);
	_return = true;
} catch {
	// If the HC is not found, server is used instead
	diag_log format["WARNING-LUCY: HeadlessClient_F not found, server used instead - %1", _exception];
	_hc_netid = 2;
	_return = false;
};

[_arg_script] remoteExec ["execVM", _hc_netid];

_return
