/*
	Author: Mystery

	Description:
	Create an infinite random patrol for a group with defined points or in an area.

	Parameter(s):
		0 : GROUP - group
        1 : OBJECT - Area marker name or an array of markers (they will be selected randomly)
        2 (optional): ARRAY - Array of group move & combat parameters - Default : ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]

	Returns:
	Nothing
*/

params ["_group", "_mkr_param", ["_grp_params", ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]]];
private ["_random_pos", "_wp", "_wp_timeout"];

if (typename _mkr_param == "ARRAY") then {
    // Generate a random position from marker list
    _random_pos = getMarkerPos (_mkr_param call BIS_fnc_selectRandom);
} else {
    // Generate a random position in the marker
    _random_pos = _mkr_param call BIS_fnc_randomPosTrigger;
    _mkr_param = format["'%1'", _mkr_param];
};

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
        ["true", format["nul = [this] spawn {[group (_this select 0), %1, %2] call GDC_fnc_lucyGroupRandomPatrol;};", _mkr_param, _grp_params]]] call GDC_fnc_lucyAddWaypoint; 
