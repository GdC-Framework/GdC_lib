/*
	Author: Mystery

	Description:
	Spawn a reinforcement group with a vehicle to drop them

	Parameter(s):
		0 : ARRAY - Array of vehicle parameters [Vehicle type, Pilot, [Crew], [Fly parameters (optional - default is ["NONE", 0, 0] - Example : ["B_Heli_Transport_01_F", "B_helicrew_F", ["B_helicrew_F", "B_helicrew_F"], ["NONE", 0, 0]]
        1 : ARRAY - Array of infantry group landed
        2 : STRING - Group Side (WEST, EAST, INDEPENDENT, CIVILIAN)
        3 : NUMBER - Spawn vehicle azimuth
        4 : ARRAY - Spawn position
        5 : ARRAY - Array of positions to go to landing position - Last position is landing position
        6 : ARRAY - Array of position to go out of the area
        7 (optional): ARRAY - Array of waypoints positions of landed group - Default is nothing
        8 (optional): ARRAY - Array for vehicle waypoints behaviour [speed, behaviour, combat mode] - Default is ["FULL", "CARELESS", "GREEN"]
        9 (optional): ARRAY - Array for landed group behaviour [speed, behaviour, combat mode, formation, waypoint type] - Default is ["FULL", "AWARE", "RED", "RANDOM", "SAD"]
        10 (optional): BOOLEAN - Enable/Disable delete of vehicle after action - it must be more than 3km of each player - Default is True
        11 (optional): NUMBER - Units skill level between 0 and 1 - If not set, no level is set (use the default level)

	Returns:
	An array which contains: [Vehicle group, vehicle object, Infantry landed group]
*/

// Function parameters
params ["_vehicle_params", "_inf_group", "_side", "_vehicle_azimuth", "_spawn_pos", "_array_go_to_land_pos", "_array_go_out_area_pos", ["_array_inf_target_pos", []], 
    ["_array_vehicle_waypoints_params", ["FULL", "CARELESS", "GREEN"]], ["_array_inf_waypoint_params", ["FULL", "AWARE", "RED", "RANDOM", "SAD"]], 
    ["_delete_vehicle", True], ["_group_skill", -1]];
    
// Function local variables
private ["_group_vehicle", "_group_inf", "_obj_helipad", "_delete_statement", "_fly_params", "_land_pos"];

_land_pos = _array_go_to_land_pos deleteAt ((count _array_go_to_land_pos) - 1);
if (count _vehicle_params > 3) then {
    _fly_params = _vehicle_params select 3;
} else {
    _fly_params = ["NONE", 0, 0];
};

// Create vehicle group and disable stupid IA
_group_vehicle = [
    _spawn_pos, _side, 
    [_vehicle_params select 0], 
    [_vehicle_params select 1],
    [_vehicle_params select 2],
    [[]],
    true,
    _vehicle_azimuth,
    20.0,
    _fly_params,
    _group_skill
] call GDC_fnc_lucySpawnGroupVehicle;

leader (_group_vehicle select 0) disableAI "AUTOTARGET";

// Create infantry group and move it into helicopter
_group_inf = [_spawn_pos, _side, _inf_group, _group_skill] call GDC_fnc_lucySpawnGroupInf;
{
    _x moveInCargo [(_group_vehicle select 1) select 0, _forEachIndex];
} forEach units _group_inf;

{
    [_group_inf, _x, 5.0, _array_inf_waypoint_params select 4, 
    _array_inf_waypoint_params select 0, _array_inf_waypoint_params select 1, 
    _array_inf_waypoint_params select 2, _array_inf_waypoint_params select 3, 5.0, [0, 0, 0]] call GDC_fnc_lucyAddWaypoint;
} forEach _array_inf_target_pos;

// Create invisible helipad to land the helicopter if needed
if (typeOf ((_group_vehicle select 1) select 0) == "Helicopter") then {
    _helipad = "Land_HelipadEmpty_F" createVehicle _land_pos;
};

// Create full path for vehicule
{
    [_group_vehicle select 0, _x, 5.0, "MOVE", _array_vehicle_waypoints_params select 0, 
    _array_vehicle_waypoints_params select 1, _array_vehicle_waypoints_params select 2, "COLUMN", 5.0, [0, 0, 0]] call GDC_fnc_lucyAddWaypoint;
} forEach _array_go_to_land_pos;

[_group_vehicle select 0, _land_pos, 5.0, "TR UNLOAD",_array_vehicle_waypoints_params select 0, 
_array_vehicle_waypoints_params select 1, _array_vehicle_waypoints_params select 2, "COLUMN", 5.0, [0, 0, 0]] call GDC_fnc_lucyAddWaypoint;

_delete_statement = ["true", ""];
{
    if (_delete_vehicle) then {
        if (_forEachIndex == (count _array_go_out_area_pos - 1)) then {
            _delete_statement = ["true", format["_vehicle = vehicle this; _nearest = [getPos _vehicle] call GDC_fnc_lucyGetNearestPlayer; if ((_nearest select 1) > 5000) then {{_vehicle deleteVehicleCrew _x} forEach crew _vehicle; deleteVehicle _vehicle;};"]];
        };
    };
    [_group_vehicle select 0, _x, 5.0, "MOVE", _array_vehicle_waypoints_params select 0, 
    _array_vehicle_waypoints_params select 1, _array_vehicle_waypoints_params select 2, "COLUMN", 10.0, [0, 0, 0], _delete_statement] call GDC_fnc_lucyAddWaypoint;
} forEach _array_go_out_area_pos;

// Return groups
[_group_vehicle select 0, (_group_vehicle select 1) select 0, _group_inf];
