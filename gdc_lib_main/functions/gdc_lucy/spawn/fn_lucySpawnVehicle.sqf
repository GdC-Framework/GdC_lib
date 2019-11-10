/*
	Author: Mystery, Sparfell

	Description:
	Spawn a vehicle manned by AI

	Parameter(s):
		0 : ARRAY - Spawn position
		1 : STRING - Group Side (WEST, EAST, INDEPENDENT, CIVILIAN)
		2 : STRING - type of vehicle (Vehicle will spawn empty)
		3 : ARRAY of STRINGs - Vehicle crew classnames
		4 (optional): NUMBER - Vehicles direction (Azimuth 0 - 360) - Default is 0
		5 (optional): ARRAY - Array flying parameters [Special(NONE, FLY, FORM), Altitude(m) , Speed (m/s)] - Default is ["NONE", 0, 0] - Use them only for aerial vehicles
		6 (optional): NUMBER - Units skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	An array which contains: [New group created, New vehicle created]
*/

params ["_pos","_side","_vehType","_crewType",["_dir",0,[0]],["_fly_params",["NONE",0,0],[[]],[3]],["_skill",-1,[0]]];
private ["_group","_veh","_posASL","_intersection","_normal"];

// Check SPAWN/SCAN system
waitUntil{sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT_REFRESH; (not LUCY_SCAN_IN_PROGRESS) && (not LUCY_SPAWN_VEH_IN_PROGRESS) && (not LUCY_SPAWN_INF_IN_PROGRESS)};
LUCY_SPAWN_VEH_IN_PROGRESS = True;

// Create the vehicle
_veh = createVehicle [_vehType,LUCY_IA_STATIC_UNIT_SPAWN_POS,[],0,(_fly_params #0)];
_veh setDir _dir;
// Align with terrain
if (!(surfaceIsWater _pos) && (_fly_params #1) == 0) then {
	_posASL = AGLToASL _pos;
	_intersection = (lineIntersectsSurfaces [_posASL,[(_posASL #0),(_posASL #1),0],_veh,objNull,true,1]) #0;
	_normal = (_intersection #1);
	if (_normal in [[-0,-0,-1]]) then {_normal = [0,0,1]};
	_veh setposASL (_intersection #0);
	_veh setVectorUp _normal;
} else {
	_veh setpos _pos;
};

// Apply Altitude
if ((_fly_params #1) > 0) then {
	_veh flyInHeightASL [(_fly_params #1),(_fly_params #1),(_fly_params #1)];
	_veh setpos [(_pos #0),(_pos #1),(_fly_params #1)];
	_veh setVectorUp [0,0,1];
};

// Apply Velocity
if ((_fly_params #2) > 0) then {
	_veh setVelocityModelSpace [0,(_fly_params #2),0];
};

// LUCY stuff
if (LUCY_IA_REMOVE_VEHICLES_INVENTORY) then {
	[_veh] call GDC_fnc_lucyVehicleRemoveItems;
};
if (LUCY_IA_CLEAN_DEAD_VEHICLES) then {
	_veh addEventHandler ['killed',{[_this, LUCY_IA_CLEAN_DEAD_VEHICLES_TIMER] spawn GDC_fnc_lucyAICleaner}];
};

// Create the crew
_group = [_veh,_side,_crewType,_skill] call GDC_fnc_lucySpawnVehicleCrew;

sleep LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT;
LUCY_SPAWN_VEH_IN_PROGRESS = False;

[_group,_veh];