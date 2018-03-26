/*
	Author: Mystery

	Description:
	Create an infinite random patrol for a group in an area.

	Parameter(s):
		0 : GROUP - the group
        1 : STRING - area marker name
        2 (optional): ARRAY - Array of group move & combat parameters - Default : ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]

	Returns:
	nothing
*/

params ["_group", "_marker", ["_grp_params", ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]]];
private ["_random_pos", "_wp", "_wp_timeout"];

// Generate a random position in the marker
switch(markerShape _marker) do {
    case ("RECTANGLE"): {
        _random_pos = _marker call GDC_fnc_lucyGetPosFromRectangle;
    };
    case ("ELLIPSE"): {
        _random_pos = _marker call GDC_fnc_lucyGetPosFromEllipse;
    };
    default {
        hint format["Unsupported format for fn_lucyGroupRandomPatrolInArea : %1", markerShape _marker];
        sleep 3.0;
    };
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
        ["true", format["nul = [this] spawn {[group (_this select 0), '%1', %2] call GDC_fnc_lucyGroupRandomPatrolInArea;};",
        _marker, _grp_params]]] call GDC_fnc_lucyAddWaypoint; 
