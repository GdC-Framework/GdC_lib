/*
	Author: Mystery

	Description:
	Add a waypoint to a group.
    You can set "RANDOM" to formation parameter to get a random formation

	Parameter(s):
		0 : GROUP - group
        1 : ARRAY - Waypoint position (typically, a marker position)
        2 : NUMBER - Waypoint radius position
        3 : STRING - Waypoint type (MOVE, DESTROY, CYCLE, ...)
        4 (optional): STRING - Waypoint speed (UNCHANGED, LIMITED, NORMAL, FULL) - Default is UNCHANGED
        5 (optional): STRING - Waypoint behaviour (UNCHANGED, CARELESS, SAFE, AWARE, COMBAT, STEALTH) - Default is UNCHANGED
        6 (optional): STRING - Waypoint combat mode (NO CHANGE, BLUE, GREEN, WHITE, YELLOW, RED) - Default is NO CHANGE
        7 (optional): STRING - Waypoint formation (NO CHANGE, RANDOM, COLUMN, STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, FILE, DIAMOND) - Default is NO CHANGE
        8 (optional): NUMBER - Waypoint completion radius - Default is 30 meters
        9 (optional): ARRAY - Waypoint timeout [min, mid, max] - Default is [0,0,0]
        10 (optional): ARRAY - Array [Waypoint condition, Waypoint statement] - Default : ["true", ""]

	Returns:
	Return the waypoint
*/


params ["_group", "_wp_pos", "_wp_radius", "_wp_type",
        ["_wp_speed", "UNCHANGED", [""]], ["_wp_behaviour", "UNCHANGED", [""]], ["_wp_combat_mode", "NO CHANGE", [""]],
        ["_wp_formation", "NO CHANGE", [""]], ["_wp_completion_radius", 30, [0]], ["_wp_timeout", [0,0,0], [[]], [3]], ["_wp_condition_statement", ["true", ""], [[]]]];
private["_wp"];

if (_wp_formation == "RANDOM") then {
    _wp_formation = [] call GDC_fnc_lucyGetRandomFormation;
};

_wp = _group addWaypoint [_wp_pos, _wp_radius];
_wp setWaypointType _wp_type;
_wp setWaypointSpeed _wp_speed;
_wp setWaypointBehaviour _wp_behaviour;
_wp setWaypointCombatMode _wp_combat_mode;
_wp setWaypointFormation _wp_formation;
_wp setWaypointCompletionRadius _wp_completion_radius;
_wp setWaypointTimeout _wp_timeout;
_wp setWaypointStatements _wp_condition_statement;

// Return the waypoint
_wp;
