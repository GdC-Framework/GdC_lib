
/*
	Author: Sparfell

	Description:
	Create a crew for a given vehicle

	Parameter(s):
		0 : OBJECT - vehicle that need a crew
		1 : SIDE - (WEST, EAST, INDEPENDENT, CIVILIAN)
		2 : ARRAY of STRINGs - Vehicle crew classnames
		3 (optional): NUMBER - Units skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	the new group created
*/

params ["_veh","_side","_crew",["_skill",-1]];
private ["_group","_u"];

_group = createGroup _side;
if ((count _crew) == 0) exitwith {_group;};
{
	_x createUnit [[0,0,0],_group,""];
	_u = (units _group) select _foreachindex;
	[_u,_veh] remoteExecCall ["moveinAny",_veh];
} forEach _crew;
_group selectLeader (effectiveCommander _veh);
_group setFormDir (getdir _veh);

(leader _group) setRank LUCY_IA_RANK_LEADER;

// Apply skill
{
	[_x,_skill] call GDC_fnc_lucyAISetConfig;
} forEach (units _group);

_group;