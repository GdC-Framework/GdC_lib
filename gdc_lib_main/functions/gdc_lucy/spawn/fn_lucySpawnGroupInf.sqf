/*
	Author: Mystery

	Description:
	Spawn an infantery group

	Parameter(s):
		0 : ARRAY - position where to spawn the group
        1 : STRING - units side
        2 : ARRAY - Array of string classname of soldiers (First unit is group leader)
        3 (optional): NUMBER - Units skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	the new group created
*/

private["_unit_group"];
params ["_unit_pos", "_group_side", "_unit_type_array", ["_group_skill", -1,[0]]];

// Check SPAWN/SCAN system
waitUntil{sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT_REFRESH; (not LUCY_SCAN_IN_PROGRESS) && (not LUCY_SPAWN_INF_IN_PROGRESS)};
LUCY_SPAWN_INF_IN_PROGRESS = True;

_unit_group = createGroup [_group_side,LUCY_IA_REMOVE_EMPTY_GROUPS];
{
    _x createUnit [_unit_pos,_unit_group,"",0.5,(if (_forEachIndex == 0) then {LUCY_IA_RANK_LEADER} else {"PRIVATE"})];
} forEach _unit_type_array;

{
    [_x, _group_skill] call GDC_fnc_lucyAISetConfig;
} forEach (units _unit_group);

sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT;
LUCY_SPAWN_INF_IN_PROGRESS = False;
_unit_group;
