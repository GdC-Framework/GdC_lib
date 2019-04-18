/*
	Author: Sparfell

	Description:
	Assign a reinforcement Path to a group with possibility to execute code and/or patrol upon reaching final destination

	Parameter(s):
		0 : GROUP - the affected group
		1 : ARRAY - Array of WP positions
		2 (optional): STRING - condition before the group starts its move - Default is "true"
		3 (optional): ARRAY - time before the group starts its move [min,mid,max] - Default is [0,0,0]
		4 (optional): ARRAY - Array for group travel waypoints behaviour [speed, behaviour, combat mode] - Default is ["NORMAL","AWARE","YELLOW"]
		6 (optional): STRING - travel group formation (NO CHANGE, RANDOM, COLUMN, STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, FILE, DIAMOND) - Default is "NO CHANGE"
		+ (optional): STRING - Type of the last WP - Default is "SAD"
		7 (optional): ARRAY - Array for group last waypoint behaviour [speed, behaviour, combat mode] - Default is ["FULL","COMBAT","RED"]
		8 (optional): STRING - last WP group formation (NO CHANGE, RANDOM, COLUMN, STAG COLUMN, WEDGE, ECH LEFT, ECH RIGHT, VEE, LINE, FILE, DIAMOND) - Default is "NO CHANGE"
		9 (optional): STRING - code executed when the group reaches its last waypoint - Default is ""
		10 (optional): NUMBER or STRING - Default is 0
				NUMBER : radius. If > 0 the group will patrol around its last waypoint in the given radius (predefined path)
				STRING : marker. The group will patrol randomly in the given marker

	Returns:
	Nothing
*/

params [
	"_group","_wps",
	["_condition","true"],["_timeout",[0,0,0]],["_wpBehavior",["NORMAL","AWARE","YELLOW"]],["_wpFormation","NO CHANGE"],
	["_wpTypeLast","SAD"],["_wpBehaviorLast",["FULL","COMBAT","RED"]],["_wpFormationLast","NO CHANGE"],["_lastWpStatement",""],["_patrolRadius",0]
];

private ["_wpLast","_nbr","_pos","_wp"];

_wpLast = _wps select ((count _wps) - 1);
_wps = _wps - [_wpLast];

_group setSpeedMode (_wpBehavior#0);
_group setBehaviour (_wpBehavior#1);
_group setCombatMode (_wpBehavior#2);

if (!(_condition == "true") OR !(_timeout in [[0,0,0]])) then {
	// Create waiting WP
	_pos = (getpos (leader _group));
	_wp = [_group,_pos,0,"MOVE",(_wpBehavior#0),(_wpBehavior#1),(_wpBehavior#2),_wpFormation,5,_timeout,[_condition,""]] call GDC_fnc_lucyAddWaypoint;
	_wp setWaypointPosition [_pos,0];
};

// Create full WP path
{
	[_group,_x,0,"MOVE",(_wpBehavior#0),(_wpBehavior#1),(_wpBehavior#2),_wpFormation,5] call GDC_fnc_lucyAddWaypoint;
} forEach _wps;

// Create last WP
[_group,_wpLast,0,_wpTypeLast,(_wpBehaviorLast#0),(_wpBehaviorLast#1),(_wpBehaviorLast#2),_wpFormationLast,5,[0,0,0],["true",_lastWpStatement]] call GDC_fnc_lucyAddWaypoint;


// Create patrol if requested
switch (TypeName _patrolRadius) do {
	case "SCALAR" : {
		if (_patrolRadius > 0) then {
		// Group will patrol in the given radius
			_nbr = (round (_patrolRadius/100)) max 4;
			_timeout = if (LUCY_RANDOM_PATROL_MAX_TIMEOUT < 1) then {1} else {LUCY_RANDOM_PATROL_MAX_TIMEOUT};
			for "_i" from 1 to _nbr do {
				//_pos = _wpLast getpos [(random [(_patrolRadius/3),_patrolRadius,_patrolRadius]),(random 360)];
				_pos = _wpLast getpos [(random [0,_patrolRadius,_patrolRadius]),(random 360)];
				[_group,_pos,0,_wpTypeLast,(_wpBehaviorLast#0),(_wpBehaviorLast#1),(_wpBehaviorLast#2),_wpFormationLast,5,[0,_timeout/2,_timeout]] call GDC_fnc_lucyAddWaypoint;
			};
			[_group,_wpLast,0,"CYCLE",(_wpBehaviorLast#0),(_wpBehaviorLast#1),(_wpBehaviorLast#2),_wpFormationLast,5] call GDC_fnc_lucyAddWaypoint;
		};
	};
	case "STRING" : {
		if (_patrolRadius in allMapMarkers) then {
			// Group will patrol in the given marker
			[_group,_patrolRadius,[_wpTypeLast,(_wpBehaviorLast#0),(_wpBehaviorLast#1),(_wpBehaviorLast#2),_wpFormationLast]] call GDC_fnc_lucyGroupRandomPatrol;
		};
	};
	default {};
};