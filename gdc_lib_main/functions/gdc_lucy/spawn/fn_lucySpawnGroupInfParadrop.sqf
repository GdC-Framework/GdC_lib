/*
	Author: Mystery
	Description:
	Spawn plane with a group of infantry for paradrop
	Parameter(s):
		0 : ARRAY - Position or array of positions, plane will spawn on first position
		1 : ARRAY - Position to start the paradrop
		2 : ARRAY - Position or array of positions after launch paradrop, vehicule will be send far far away from the last point to be destroyed
		3 : STRING - Side (WEST, EAST, INDEPENDENT, CIVILIAN)
		4 : ARRAY - Config for the plane ["plane class name", "pilot class name", "plane altitude (m)", "plane speed (m/s)" (optional)]
		5 : ARRAY - Array of infantry soldiers (the group which will be paradropped)
	Returns:
	[The group which will be paradropped, the plane group]
*/

params["_pos_spawn", "_pos_drop", "_pos_exit", "_side", "_plane_config", "_infantry_units"];
private["_cleaned_pos_spawn", "_next_waypoint_pos", "_plane_spawn", "_grp_inf", "_drop_statement", "_plane_speed", "_computed_angle", "_plane_group"];

// Extract the first position and get next waypoint to compute the angle
if (typename (_pos_spawn select 0) == "ARRAY") then {
	_cleaned_pos_spawn = _pos_spawn deleteAt 0;
	_next_waypoint_pos = _pos_spawn select 0;
} else {
	_cleaned_pos_spawn = _pos_spawn;
	_pos_spawn = [];
	_next_waypoint_pos = _pos_drop;
};

// Compute angle for plane spawn with the two first positions
_computed_angle = [_cleaned_pos_spawn, _next_waypoint_pos] call BIS_fnc_dirTo;

// Manage plane config
_plane_config params ["_plane_classname", "_plane_pilot", "_plane_altitude"];
if (count _plane_config == 4) then { _plane_speed = _plane_config select 3; } else { _plane_speed = 40.0; };

_plane_spawn = [
		_cleaned_pos_spawn, _side, 
		[_plane_classname], 
		[_plane_pilot],
		[[]],
		[[]],
		true,
		_computed_angle,
		15.0,
		["FLY", _plane_altitude, _plane_speed]
	] call GDC_fnc_lucySpawnGroupVehicle;
_plane_group = _plane_spawn select 0;

// Add waypoint for all next positions
{
	_next_waypoint_pos = [_x select 0, _x select 1, _plane_altitude];
	[_plane_group, _next_waypoint_pos, 0, "MOVE", "LIMITED", "STEALTH", "BLUE", "RANDOM", 50.0] call GDC_fnc_lucyAddWaypoint;
} forEach _pos_spawn;

// Jump position
_jump_pos = [_pos_drop select 0, _pos_drop select 1, _plane_altitude];
// Move to drop point (thanks to Sparfell !)
_drop_statement = "
	[this] spawn {
		_veh = vehicle (leader (_this select 0));
		if(not(local _veh))exitWith{};
		private _delay = (1/(((speed _veh) max 55)/110));
		private _cargo = (crew _veh) select {(_veh getCargoIndex _x) >= 0};
		{
			_x disableCollisionWith _veh;
			moveout _x;
			[_x] allowGetIn false;
			unassignVehicle _x;
			sleep _delay;
			private _para = 'NonSteerable_Parachute_F';
			if (isClass (configFile >> 'CfgPatches' >> 'rhs_main')) then {
				_para = 'rhs_d6_Parachute';
			};
			_para = _para createVehicle [0,0,0];
			_para setPosASL (getPosASLVisual _x);
			_para setVectorDirAndUp [vectorDirVisual _x,vectorUpVisual _x];
			if (! local _x) then {[_x,_para] remoteExecCall ['moveInDriver',_x]} else {_x moveInDriver _para;};
			_x assignAsDriver _para;
			[_x] allowGetIn true;
			[_x] orderGetIn true;
		} foreach _cargo;
		{
			(group _x) leaveVehicle _veh;
			_x enableCollisionWith _veh;
		} foreach _cargo;
	};
";
[_plane_group, _jump_pos, 0, "MOVE", "LIMITED", "STEALTH", "BLUE", "RANDOM", 30.0, [0, 0, 0], ["true", _drop_statement]] call GDC_fnc_lucyAddWaypoint;

// Spawn infantry group
_grp_inf = [[0, 0, 0], _side, _infantry_units] call GDC_fnc_lucySpawnGroupInf;
// Move the group to the plane
{
	_x assignAsCargoIndex [(_plane_spawn select 1) select 0, (_forEachIndex + 1)];
	[_x, [(_plane_spawn select 1) select 0, (_forEachIndex + 1)]] remoteExecCall ["moveInCargo", _x];
	sleep 0.1;
} forEach (units _grp_inf);

// Add exit points
if (typename (_pos_exit select 0) == "ARRAY") then {
	{
		_next_waypoint_pos = [_x select 0, _x select 1, _plane_altitude];
		[_plane_group, _next_waypoint_pos, 0, "MOVE", "LIMITED", "STEALTH", "BLUE", "RANDOM", 50.0] call GDC_fnc_lucyAddWaypoint;
	} forEach _pos_exit;
} else {
	_next_waypoint_pos = [_pos_exit select 0, _pos_exit select 1, _plane_altitude];
	[_plane_group, _next_waypoint_pos, 0, "MOVE", "LIMITED", "STEALTH", "BLUE", "RANDOM", 50.0] call GDC_fnc_lucyAddWaypoint;
};
// Add a death waypoint at 8km, aligned with the two last waypoints
_computed_angle = [
	waypointPosition [_plane_group, (count (waypoints (_plane_group))) - 2],
	waypointPosition [_plane_group, (count (waypoints (_plane_group))) - 1]
] call BIS_fnc_dirTo;
_next_waypoint_pos = (((waypointPosition [_plane_group, (count (waypoints (_plane_group))) - 1]) getPos [8000, _computed_angle]) select [0, 2]) + [_plane_altitude];
[_plane_group, _next_waypoint_pos, 0, "MOVE", "LIMITED", "STEALTH", "BLUE", "RANDOM", 50.0, [0, 0, 0], ["true", "{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach units group this;"]] call GDC_fnc_lucyAddWaypoint;

// Return the infantry group
[_grp_inf, _plane_group];
