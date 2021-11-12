/*
	Author: Mystery

	Description:
	Create an infinite random patrol for a group with defined points or in an area.

	Parameter(s):
		0 : GROUP - group
        1 : STRING/ARRAY - Area marker name or an array of positions (they will be selected randomly)
            STRING : Marker name
            ARRAY : List of position OR List of marker name
        2 (optional): ARRAY - Array of group move & combat parameters - Default : ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]
        3 (optional): ARRAY - Blacklist, only compatible if the 1) parameter is used as Marker name. This array must contain
            Object - trigger
            String - marker name or special tags names: "water" - exclude water, "ground" - exclude land
            Array - in format [center, radius] or [center, [a, b, angle, rect]]
            Location - location.

	Returns:
	Nothing
*/

params ["_group", "_mkr_param", ["_grp_params", ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"], [[]], [5]], ["_blacklist", nil, [[], ""]]];
private ["_random_pos", "_wp", "_wp_timeout"];

// If no blacklist sended, we generate the right one
if(isNil "_blacklist" ) then {
    _blacklist = [vehicle (leader _group)] call GDC_fnc_prepareBlacklistForRandomPos;
};

if (typename _mkr_param == "ARRAY" && { typename (_mkr_param #0) != "STRING"}) then {
    // Generate a random position from list of positions
    _random_pos = selectRandom _mkr_param;
} else {
    // Generate a random position in the marker(s)
    if(typename _mkr_param != "ARRAY") then {
        _mkr_param = [_mkr_param];
    };
    if(typename _blacklist != "ARRAY") then {
        _blacklist = [_blacklist];
    };
    _random_pos = [_mkr_param, _blacklist] call BIS_fnc_randomPos;
};

if (LUCY_RANDOM_PATROL_MAX_TIMEOUT < 1) then {
    _wp_timeout = 1;
} else {
    _wp_timeout = LUCY_RANDOM_PATROL_MAX_TIMEOUT;
};

// Statement will recall the function when waypoint is reached
_wp = [
    _group, 
    _random_pos, 
    5, 
    _grp_params #0,
    _grp_params #1,
    _grp_params #2,
    _grp_params #3,
    _grp_params #4,
    15, 
    [0, _wp_timeout/2, _wp_timeout], 
    ["true", format["if (local this && (count waypoints group this) < 3) then {nul = [this] spawn {[group (_this select 0), %1, [%2,""UNCHANGED"",""UNCHANGED"",""NO CHANGE"",""NO CHANGE""], %3] call GDC_fnc_lucyGroupRandomPatrol;};};", _mkr_param, str(_grp_params #0), _blacklist]]
] call GDC_fnc_lucyAddWaypoint;
