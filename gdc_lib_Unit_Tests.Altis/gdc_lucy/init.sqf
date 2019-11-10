
'Lucy tests: Init' call ShowAndLog;


lucyGroup = createGroup west;
lucyUnit = "B_Soldier_GL_F" createUnit [getMarkerPos "mkr_lucy_spawn", lucyGroup];


[group_lucy_random_patrol, "mkr_lucy_patrol_random"] call GDC_fnc_lucyGroupRandomPatrol;
[group_lucy_random_patrol_fix_point, "mkr_lucy_patrol_random_fix_point", 5] call GDC_fnc_lucyGroupRandomPatrolFixPoints;

'Lucy tests: EndInit' call ShowAndLog;
