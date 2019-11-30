/*
	Author: Sparfell

	Description:
	Load a group in a vehicle in order to be transported to an area

	Parameter(s):
		0 : OBJECT - transport vehicle
		1 : GROUP - infantry transported in cargo
		2 : ARRAY - Array of positions to go to unload position - Last position is unload position
		3 (optional): ARRAY - Array of positions to go out of the area - Default is []
		4 (optional): ARRAY - Array for vehicle waypoints behaviour [speed, behaviour, combat mode] - Default is ["NORMAL", "CARELESS", "GREEN"]
		5 (optional): STRING - condition before the vehicle starts its move - Default is "true"
		6 (optional): ARRAY - time before the vehicle starts its move [min,mid,max] - Default is [0,0,0]
		7 (optional): STRING - code executed when the vehicle reaches its unload waypoint - Default is ""
		8 (optional): BOOL - Enable/Disable delete of vehicle after action - it must be more than 3km of each player - Default is true

	Returns:
	Nothing
*/

params ["_veh","_cargo","_wpsIN",["_wpsOUT",[],[[]]],["_behavior",["NORMAL","CARELESS","GREEN"],[[]],[3]],["_condition","true",[""]],["_timeout",[0,0,0],[[]],[3]],["_statement","",[""]],["_delete",true,[true]]];

private ["_group","_unloadPos","_code","_wp","_pos"];

_group = group _veh;
_unloadPos = (_wpsIN select ((count _wpsIN) - 1));

// Move infantry in cargo
{
	_x assignascargo _veh;
	_x moveInCargo _veh;
} forEach (units _cargo);

// Vehicle group behavior
if((_behavior#0) != "UNCHANGED") then { _group setSpeedMode (_behavior#0); };
if((_behavior#1) != "UNCHANGED") then { _group setBehaviour (_behavior#1); };
if((_behavior#2) != "NO CHANGE") then { _group setCombatMode (_behavior#2); };

// Est-ce vraiment nécessaire ? Si non mieux vaut l'enlever pour éviter les emmerdes.
{
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
} forEach (units _group);

// Create invisible helipad to land the helicopter if needed
if (_veh iskindof "Helicopter") then {
	"Land_HelipadEmpty_F" createVehicle _unloadPos;
};

if (!(_condition == "true") OR !(_timeout in [[0,0,0]])) then {
	// waiting WP
	_pos = (getpos _veh);
	_wp = [_group,_pos,0,"MOVE",(_behavior#0),(_behavior#1),(_behavior#2),"NO CHANGE",5,_timeout,[_condition,""]] call GDC_fnc_lucyAddWaypoint;
	_wp setWaypointPosition [_pos,0];
};

// Create full path IN for vehicule
{
	[_group,_x,0,"MOVE",(_behavior#0),(_behavior#1),(_behavior#2),"COLUMN",5] call GDC_fnc_lucyAddWaypoint;
} forEach _wpsIN;

// Unload WP
_code = if ((count _wpsOUT) > 0) then {""} else {"{_x enableAI ""AUTOTARGET"";_x enableAI ""AUTOCOMBAT"";} forEach thisList;"}; // If no WPs OUT the vehicle should be able to fight
_timeout = if (_veh isKindOf "Helicopter") then {[5,5,5]} else {[10,13,16]}; // The vehicle will wait before going OUT (no rolled-over or thrown overboard passengers)
[_group,_unloadPos,0,"TR UNLOAD",(_behavior#0),(_behavior#1),(_behavior#2),"NO CHANGE",5,_timeout,["true",(_code + _statement)]] call GDC_fnc_lucyAddWaypoint;

// Create full path OUT for vehicule
_statement = ["true",""];
{
	if (_delete) then {
		if (_forEachIndex == (count _wpsOUT - 1)) then {
			_statement = ["true",format["private _veh = vehicle this; private _nearest = [getPos _veh] call GDC_fnc_lucyGetNearestPlayer; if ((_nearest select 1) > 3000) then {{_veh deleteVehicleCrew _x} forEach crew _veh; deleteVehicle _veh;};"]];
		};
	};
	[_group,_x,0,"MOVE",(_behavior#0),(_behavior#1),(_behavior#2),"NO CHANGE",5,[0,0,0],_statement] call GDC_fnc_lucyAddWaypoint;
} forEach _wpsOUT;