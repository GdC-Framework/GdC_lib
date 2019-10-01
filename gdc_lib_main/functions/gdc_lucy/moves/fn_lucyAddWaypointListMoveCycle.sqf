/*
	Author: Mystery

	Description:
	Add a list of waypoints to a group. Waypoints are only Move waypoints which loop with the first

	Parameter(s):
		0 : GROUP - group
        1 : ARRAY - Array of positions
        2 (optional): STRING - Waypoint speed (UNCHANGED, LIMITED, NORMAL, FULL) - Default is LIMITED
        3 (optional): STRING - Waypoint behaviour (UNCHANGED, CARELESS, SAFE, AWARE, COMBAT, STEALTH) - Default is SAFE
        4 (optional): STRING - Waypoint combat mode (NO CHANGE, BLUE, GREEN, WHITE, YELLOW, RED) - Default is RED
        5 (optional): STRING - Waypoint formation (NO CHANGE, COLUMN, STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, FILE, DIAMOND) - Default is COLUMN
        6 (optional): STRING - Waypoint completion radius - Default is 30 meters
        7 (optional): STRING - Waypoints timer between waypoints - Default is [0,0,0] for each waypoint - Exemple with 3 waypoints [[10,20,30], [0,0,0], [60,120,180]]

	Returns:
	Nothing
*/

params["_group", "_wp_positions", ["_wp_speed", "LIMITED"], ["_wp_behaviour", "SAFE"], ["_wp_combat_mode", "RED"], ["_wp_formation", "COLUMN"], ["_wp_completion_radius", 30], ["_wp_timers", []]];
private["_wp", "_cycle_pos"];

// Set default time
if (count _wp_timers == 0) then {
    {
        _wp_timers pushBack [0, 0, 0];
    } forEach _wp_positions;
};

// Set speed, behavior, combat mode and formation
_group setSpeedMode _wp_speed;
_group setBehaviour _wp_behaviour;
_group setCombatMode _wp_combat_mode;
_group setFormation _wp_formation;

{
    _wp = [_group, _x, 10, "MOVE", "UNCHANGED", "UNCHANGED", "NO CHANGE", "NO CHANGE", _wp_completion_radius, (_wp_timers select _forEachIndex)] call GDC_fnc_lucyAddWaypoint; 
} forEach _wp_positions;

_cycle_pos = _wp_positions #0;
_wp = [_group, [(_cycle_pos #0) + 10, (_cycle_pos #1) + 10, _cycle_pos #2], 10, "CYCLE", "UNCHANGED", "UNCHANGED", "NO CHANGE", "NO CHANGE", _wp_completion_radius] call GDC_fnc_lucyAddWaypoint; 
