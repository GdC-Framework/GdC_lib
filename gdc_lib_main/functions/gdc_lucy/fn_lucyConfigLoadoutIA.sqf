/*
	Author: Mystery

	Description:
	Configure the script to load the IA loadouts.
    It could take one parameter which is the unit.

	Parameter(s):
		0 : STRING - script which execute

	Returns: 
    nothing
*/
params["_loadout_script"];

LUCY_SCRIPT_CONFIG_LOADOUT_IA_ENABLED = True;
LUCY_SCRIPT_CONFIG_LOADOUT_IA = compile preProcessFileLineNumbers(_loadout_script);
