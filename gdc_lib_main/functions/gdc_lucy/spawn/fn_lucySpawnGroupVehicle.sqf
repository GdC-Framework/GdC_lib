/*
	Author: Mystery

	Description:
	Spawn a reinforcement group with a vehicle to drop them

	Parameter(s):
		0 : ARRAY - Spawn position
        1 : STRING - Group Side (WEST, EAST, INDEPENDENT, CIVILIAN)
        2 : ARRAY - Array of type of vehicles (Vehicles will spawn empty)
        3 : ARRAY - Array of infantry drivers (they will be forced to go to driver positions)
        4 (optional): ARRAY - Array of arrays of infantry gunners (they will be forced to go to gunners positions) - Format [["SOLDIER"], ["SOLDIER", SOLDIER"], []]
        5 (optional): ARRAY - Array of arrays of infantry soldiers (in case of multiple vehicles, you can set multiple arrays like gunners)
        6 (optional): BOOLEAN - Force soldiers to go in cargo of vehicles (true : go in cargo, false : nothing - Extra soldiers will spawn next to the vehicle) - Default is True
        7 (optional): NUMBER - Vehicles direction (Azimuth 0 - 360) - Default is 0
        8 (optional): NUMBER - Space between each vehicle spawned - Default is 20 meters.
        9 (optional): ARRAY - Array flying parameters [Special(NONE, FLY, FORM), Altitude(m) , Speed (m/s)] - Default is ["NONE", 0, 0] - Use them only for aerial vehicles
        10 (optional): NUMBER - Units skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	An array which contains: [New group created, list of all group vehicles]
*/

// Parameters
params["_unit_pos", "_group_side", "_vehicles_array", "_inf_drivers", ["_inf_gunners", objNull], ["_inf_troops", objNull], ["_force_cargo", True], 
    ["_unit_dir", 0], ["_unit_spawn_space", 20.0], ["_fly_params", ["NONE", 0, 0]], ["_group_skill", -1]];
// Function local variables
private["_unit_spawn", "_vehicle_spawn", "_vehicles_spawn", "_final_group", "_current_vehicle"];


// Check SPAWN/SCAN system
waitUntil{sleep 1.0;(not LUCY_SCAN_IN_PROGRESS) && (not LUCY_SPAWN_VEH_IN_PROGRESS) && (not LUCY_SPAWN_INF_IN_PROGRESS)};
LUCY_SPAWN_VEH_IN_PROGRESS = True;

// Spawn vehicles, drivers and assign them
_vehicles_spawn = [];
_final_group = createGroup _group_side;
{
    // Create the vehicle
    _vehicle_spawn = createVehicle[_x, [(_unit_pos select 0) + (_unit_spawn_space * _forEachIndex * (sin (_unit_dir + 180))), (_unit_pos select 1) + (_unit_spawn_space * _forEachIndex * (cos (_unit_dir + 180))), (_unit_pos select 2) + (_fly_params select 1)], [], 0, (_fly_params select 0)];
    _vehicle_spawn setDir _unit_dir;
    if ((_fly_params select 2) > 0) then {
        _vehicle_spawn setVelocity [(_fly_params select 2) * (sin _unit_dir), (_fly_params select 2) * (cos _unit_dir), 0];
    };
    
    if (LUCY_IA_INFINITE_FUEL) then {
        infinite_fuel = [_vehicle_spawn] spawn {
            while {alive (_this select 0)} do {
                // Refuel every 5 minutes
                sleep 300.0;
                (_this select 0) setFuel 1;
            };
        };
    };
    if (LUCY_IA_REMOVE_VEHICLES_INVENTORY) then {
        [_vehicle_spawn] call GDC_fnc_lucyVehicleRemoveItems;
    };
    if (LUCY_IA_CLEAN_DEAD_VEHICLES) then {
        _vehicle_spawn addEventHandler ['killed',{[_this, LUCY_IA_CLEAN_DEAD_VEHICLES_TIMER] spawn GDC_fnc_lucyAICleaner}];
    };
    _final_group addVehicle _vehicle_spawn;
    _vehicles_spawn = _vehicles_spawn + [_vehicle_spawn];
    
    // Add the driver
    _unit_spawn = _final_group createUnit[(_inf_drivers select _forEachIndex), _unit_pos, [], 0, "NONE"];
    [_unit_spawn] joinSilent _final_group;
    _unit_spawn moveInDriver (_vehicle_spawn);
    
    if (_forEachIndex == 0) then {
        _unit_spawn setRank LUCY_IA_RANK_LEADER;
        [_final_group, [(_unit_pos select 0) + (2 * (sin _unit_dir)), (_unit_pos select 1) + (2 * (cos _unit_dir)), (_unit_pos select 2) + (_fly_params select 1)], 0, "MOVE", "LIMITED", "CARELESS", "RED", "COLUMN", 0, [0, 0, 0]] call GDC_fnc_lucyAddWaypoint;
    };

    [_unit_spawn, _group_skill] call GDC_fnc_lucyAISetConfig;
} forEach _vehicles_array;

// Spawn and assign gunners
{
    _current_vehicle = _vehicles_spawn select _forEachIndex;
    {
        if (count _x != 0) then {
            _unit_spawn = _final_group createUnit[_x, _unit_pos, [], 0, "NONE"];
    
            [_unit_spawn, _group_skill] call GDC_fnc_lucyAISetConfig;
            [_unit_spawn] joinSilent _final_group;
            
            _unit_spawn moveInTurret [_current_vehicle, [_forEachIndex]];
        };
    } forEach _x;
} forEach _inf_gunners;

// Spawn infantry and set them into cargo if needed
{
    _current_vehicle = _vehicles_spawn select _forEachIndex;
    {
        if (count _x != 0) then {
            _unit_spawn = _final_group createUnit[_x, _unit_pos, [], 0, "NONE"];
            
            [_unit_spawn, _group_skill] call GDC_fnc_lucyAISetConfig;
            [_unit_spawn] joinSilent _final_group;
            
            if (_force_cargo) then {
                _unit_spawn moveInCargo [_current_vehicle, _forEachIndex];
            };
        };
    } forEach _x;
} forEach _inf_troops;

LUCY_SPAWN_VEH_IN_PROGRESS = False;

[_final_group, _vehicles_spawn];
