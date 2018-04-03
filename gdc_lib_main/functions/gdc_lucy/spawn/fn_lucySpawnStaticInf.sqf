/*
	Author: Mystery

	Description:
	Spawn a static infantery
    Use the following command to get ASL position and azimuth in the debug console. Then, paste to your script and change unit type and side.
    copyToClipboard format["static_unit_x = [SOLDAT, [%1, %2, %3], %4, UNIT_SIDE] call GDC_fnc_lucySpawnStaticInf;", (getPosASL  player select 0), getPosASL player select 1, getPosASL player select 2, getDir player];

	Parameter(s):
		0 : STRING - unit class name
        1 : ARRAY - unit position
        2 : NUMBER - unit azimuth
        3 : STRING - unit side (WEST, EAST, INDEPENDENT, CIVILIAN)
        4 (optional): STRING - Unit specific position - Values : DOWN, MIDDLE, UP, AUTO - Default is UP
        5 (optional): ARRAY - Unit disableAI utility, array of values: Values : TARGET, AUTOTARGET, MOVE, ANIM, FSM, AIMINGERROR, SUPPRESSION - Default is ["NOTHING"]
        6 (optional): NUMBER - Unit skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	the new unit created
*/

params ["_unit_type", "_unit_pos", "_unit_dir", "_unit_side", ["_unit_weak", "UP"], ["_unit_ai_disable", ["NOTHING"]], ["_unit_skill", -1]];
private["_unit_spawn", "_unit_group"];

// Check SPAWN/SCAN system
waitUntil{sleep 1.0;(not LUCY_SCAN_IN_PROGRESS) && (not LUCY_SPAWN_INF_IN_PROGRESS)};
LUCY_SPAWN_INF_IN_PROGRESS = True;

_unit_group = createGroup _unit_side;
_unit_spawn = _unit_group createUnit[_unit_type, getMarkerPos LUCY_IA_MARKER_SPAWN_STATIC_UNIT_NAME, [], 0, "NONE"];
_unit_spawn setVariable[LUCY_UNIT_TYPE, LUCY_UNIT_TYPE_STATIC, True];
_unit_spawn setFormDir _unit_dir;
_unit_spawn setPosASL _unit_pos;      
_unit_spawn setUnitPos _unit_weak;


[_unit_spawn, _unit_skill] call GDC_fnc_lucyAISetConfig;

{
    if (_x != "NOTHING") then {
        _unit_spawn disableAI _x;
    };
} forEach _unit_ai_disable;

sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT;
LUCY_SPAWN_INF_IN_PROGRESS = False;

_unit_spawn;