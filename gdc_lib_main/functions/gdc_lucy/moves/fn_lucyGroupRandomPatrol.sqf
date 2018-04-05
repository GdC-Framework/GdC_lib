/*
	Author: Mystery

	Description:
	Create an infinite random patrol for a group with defined points

	Parameter(s):
		0 : GROUP - group
        1 : ARRAY - Array of markers (they will be selected randomly)
        2 (optional): ARRAY - Array of group move & combat parameters - Default : ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]
            Parameters: 
            STRING - Waypoint type (MOVE, DESTROY, CYCLE, ...)
            STRING - Waypoint speed (UNCHANGED, LIMITED, NORMAL, FULL)
            STRING - Waypoint behaviour (UNCHANGED, CARELESS, SAFE, AWARE, COMBAT, STEALTH)
            STRING - Waypoint combat mode (NO CHANGE, BLUE, GREEN, WHITE, YELLOW, RED)
            STRING - Waypoint formation (NO CHANGE, COLUMN, STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, FILE, DIAMOND)

	Returns:
	Nothing
*/

params ["_group", "_mkr_array", ["_grp_params", ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]]];
private ["_random_pos", "_wp", "_wp_timeout"];


_random_mkr = _mkr_array call BIS_fnc_selectRandom;
_random_pos = getMarkerPos _random_mkr; 

if (LUCY_RANDOM_PATROL_MAX_TIMEOUT < 1) then {
    _wp_timeout = 1;
} else {
    _wp_timeout = LUCY_RANDOM_PATROL_MAX_TIMEOUT;
};

// Statement will recall the function when waypoint is reached
_wp = [_group, _random_pos, 5, 
        _grp_params select 0,
        _grp_params select 1, 
        _grp_params select 2, 
        _grp_params select 3,
        _grp_params select 4,
        15, 
        [0, _wp_timeout/2, _wp_timeout], 
        ["true", format["nul = [this] spawn {[group (_this select 0), %1, %2] call GDC_fnc_lucyGroupRandomPatrol;};", _mkr_array, _grp_params]]] call GDC_fnc_lucyAddWaypoint; 
