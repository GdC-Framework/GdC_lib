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

params ["_group", "_mkr_param", ["_grp_params", ["MOVE", "LIMITED", "SAFE", "RED", "COLUMN"]], ["_blacklist", nil]];
private ["_random_pos", "_wp", "_wp_timeout"];

// If no blacklist sended, we generate the right one
if(isNil "_blacklist" ) then {
    _blacklist = [vehicle (leader _group)] call GDC_fnc_prepareBlacklistForRandomPos;
};

if (typename _mkr_param == "ARRAY" && { count _mkr_param > 0 } && { count (_mkr_param select 0) == 3}) then {
    // Generate a random position from marker list
    _random_pos = selectRandom _mkr_param;
} else {
    // Generate a random position in the marker
    if(typename _mkr_param != "ARRAY") then {
        _mkr_param = [_mkr_param];
    };
    if(typename _blacklist != "ARRAY") then {
        _blacklist = [_blacklist];
    };

    _random_pos = [_mkr_param, _blacklist] call BIS_fnc_randomPos;
    // _mkr_param = format["'%1'", _mkr_param];
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
    _grp_params select 0,
    _grp_params select 1, 
    _grp_params select 2, 
    _grp_params select 3,
    _grp_params select 4,
    15, 
    [0, _wp_timeout/2, _wp_timeout], 
    ["true", format["nul = [this] spawn {[group (_this select 0), %1, %2, %3] call GDC_fnc_lucyGroupRandomPatrol;};", _mkr_param, _grp_params, _blacklist]]
] call GDC_fnc_lucyAddWaypoint; 
