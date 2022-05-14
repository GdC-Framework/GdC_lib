/**
 * @name posToGrid
 * Extend mapGridPosition command engine for X digits grid map.
 *
 * @param {object, group, location, array, string} [_object = player].
 * @param {number} [_number_digits = 3], Number of grid coordinates ("_number_digits" digits for each axis), 6 digits max.
 * @param {string} [_separator = ""], Symbol used to separate the x-grid and y-grid coordinates.
 *
 * @returns {string} grid coordinates.
 *
 * @author Migoyan, based on Karel Moricky's function BIS_fnc_gridToPos (For recovering offsets part).
 */
params[
	["_object", player, [objNull, grpNull, locationNull, [], ""], [2, 3]],
	["_number_digits", 3, [0]],
	["_separator", "", [""]]
];

if ( _number_digits <= 0 || _number_digits > 6) throw "fnc_posToGrid : param _number_digits must between 1 to 6 included";

private [
	"_posGrid","_cfgGrid","_offsetX","_offsetY", "_obj_pos", "_coeff", "_gridX", "_gridY", "_add_0X", "_add_0Y"
];
// Extract grid values from world config
_cfgGrid = configfile >> "CfgWorlds" >> worldname >> "Grid";
_offsetX = getnumber (_cfgGrid >> "offsetX");
_offsetY = getnumber (_cfgGrid >> "offsetY");

_obj_pos = _object call BIS_fnc_position;

// We assume that for 10 digits (_number_digits = 5), gird size is 1 meter
_coeff = 10^(_number_digits - 5);

// Computing grid coordinates
_gridX = str floor ((_obj_pos#0 - _offsetX) * _coeff);
_gridY = str floor ((_obj_pos#1 + _offsetY - worldSize) * _coeff);

// Computing missing front zeros and adding them
_add_0X = _number_digits - count _gridX;
_add_0Y = _number_digits - count _gridY;

for "_i" from 1 to _add_0X do {
	_gridX = "0" + _gridX;
};

for "_i" from 1 to _add_0Y do {
	_gridY = "0" + _gridY;
};

_gridX + _separator + _gridY
