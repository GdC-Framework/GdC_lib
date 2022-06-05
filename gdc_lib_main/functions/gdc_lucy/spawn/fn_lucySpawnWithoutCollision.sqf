/**
 * @brief Function spawning AI vehicules with Lucy functions without collisions.
 *
 * @param {Array} _positions, elements can be Arrays, Objects, Groups, Locations and Strings. (see BIS_fnc_position)
 * @param {Array} [_param_to_lucy] - list of the parameters of GDC_fnc_lucySpawnVehicle function (use the order of lucySpawnVehicle function).
 * @param {number} [_safe_zone = 10] -  radius of the safe zone around the spawn waypoint where the funciton check for other vehicle.
 *
 * @returns {Array} - #0 unit group, #1 vehicle.
 * @author Migoyan
 *
 * @note GDC_fnc_lucySpawnVehicle eat [position, side, "classname", crew, orientation], reduce the array to [side, "classname", crew, orientation] for this function to work
 * or give a dummy param.
 */
params[
	["_positions", [], [[]]],
	["_param_to_lucy", [], [[]]],
	["_safe_zone", 10, [0]]
];

_positions = _positions apply { _x call BIS_fnc_position; };
// Internal variables
private ["_veh", "_position", "_occupied"];

// Choose a marker and test if there is already a vehicule within 10m of range of the marker position.
_occupied = true;
while {_occupied}
do{
	_position = selectRandom _positions;
	if (nearestObjects [_position, ["AllVehicles"], _safe_zone] isEqualTo [])
	then{
		_occupied = false;
	};
};

if (_param_to_lucy#0 isEqualType west) then {
	_param_to_lucy = [_position] + _param_to_lucy;
} else {
	_param_to_lucy set [_position, 0];
};

_param_to_lucy call GDC_fnc_lucySpawnVehicle
