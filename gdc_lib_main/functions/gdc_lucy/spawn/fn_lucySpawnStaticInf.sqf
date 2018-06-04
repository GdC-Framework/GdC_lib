/*
	Author: Mystery

	Description:
	Spawn a static infantery
    Use the following command to get ASL position and azimuth in the debug console. Then, paste to your script and change unit type and side.
    _PosDirArray = [];
    { 
    _veh = _x; 
    _pos_dir = [(getPosASL  _veh select 0), (getPosASL _veh select 1), getPosASL _veh select 2, getDir _veh]; 
    _PosDirArray = [_pos_dir] + _PosDirArray;
    } foreach (get3DENSelected "object"); 
    copyToClipboard str _PosDirArray;
    
    # Old version...
    copyToClipboard format["static_unit_x = [SOLDAT, [[%1, %2, %3]], [%4], UNIT_SIDE] call GDC_fnc_lucySpawnStaticInf;", (getPosASL  player select 0), getPosASL player select 1, getPosASL player select 2, getDir player];

	Parameter(s):
		0 : STRING - unit class name
        1 : ARRAY - Array of units positions + azimuths
        2 : STRING - unit side (WEST, EAST, INDEPENDENT, CIVILIAN)
        3 (optional): STRING - Unit specific position - Values : DOWN, MIDDLE, UP, AUTO - Default is UP
        4 (optional): ARRAY - Unit disableAI utility, array of values: Values : TARGET, AUTOTARGET, MOVE, ANIM, FSM, AIMINGERROR, SUPPRESSION - Default is ["NOTHING"]
        5 (optional): NUMBER - Unit skill level between 0 and 1 - If not set, no level is set (use the default level)
        6 (optional): STRING - Script to execute on the unit's INIT, use "this" in the script to call the current unit

	Returns:
	    nothing
*/

params ["_unit_type", "_unit_pos_dir", "_unit_side", ["_unit_weak", "UP"], ["_unit_ai_disable", ["NOTHING"]], ["_unit_skill", -1], ["_unit_init", ""]];
private["_unit_spawn", "_unit_group", "_i"];

// Check SPAWN/SCAN system
waitUntil{sleep 1.0;(not LUCY_SCAN_IN_PROGRESS) && (not LUCY_SPAWN_INF_IN_PROGRESS)};
LUCY_SPAWN_INF_IN_PROGRESS = True;

for [{_i=0}, {_i < count _unit_pos_dir}, {_i = _i + 1}] do {
    _unit_group = createGroup _unit_side;
    _unit_spawn = _unit_group createUnit[_unit_type, getMarkerPos LUCY_IA_MARKER_SPAWN_STATIC_UNIT_NAME, [], 0, "NONE", _unit_init];
    _unit_spawn setVariable[LUCY_UNIT_TYPE, LUCY_UNIT_TYPE_STATIC, True];
    _unit_spawn setFormDir ((_unit_pos_dir select _i) select 3);
    _unit_spawn setPosASL [(_unit_pos_dir select _i) select 0, (_unit_pos_dir select _i) select 1, (_unit_pos_dir select _i) select 2];      
    _unit_spawn setUnitPos _unit_weak;
    
    [_unit_spawn, _unit_skill] call GDC_fnc_lucyAISetConfig;

    {
        if (_x != "NOTHING") then {
            _unit_spawn disableAI _x;
        };
    } forEach _unit_ai_disable;
    
    sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT;
};

LUCY_SPAWN_INF_IN_PROGRESS = False;
