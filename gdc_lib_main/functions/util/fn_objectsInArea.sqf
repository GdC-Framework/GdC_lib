/**
 * @brief Return all specified type names objects within area. Throw error for
 * "ICON" markers
 *
 * @param {String, Location} - marker or location name.
 * @param {Array} - object type names.
 *
 * @returns {Array} - Buildings within marker area.
 * @author Migoyan
 */
params[
	["_area", locationNull, ["", locationNull]],
	["_typenames", [], [[]]]
];
private[
	"_buildings", "_center", "_diagonal", "_grandAxis",
	"_sizes", "_rectangular", "_retrieveObjects"
];

if (_area isEqualType locationNull) then {
	_center = locationPosition _area;
	_sizes = size _area;
	_rectangular = rectangular _area;
} else {
	if (markerShape _area isEqualTo "ICON")
	throw "invalid marker shape: ICON";

	_center = markerPos _area;
	_sizes = markerSize _area;
	_rectangular = markerShape _area isEqualTo "RECTANGLE";
};

_retrieveObjects = {
	_objects = [];
	{
		_objects append (_this#0 nearObjects [_x, _this#1])
	} forEach _typenames;
	_objects
};

_buildings = [];
if (_rectangular) then {
	_diagonal = sqrt((_sizes#0)^2 + (_sizes#1)^2);
	_buildings append ([_center, _diagonal] call _retrieveObjects);
} else {
	_grandAxis = selectMax _sizes;
	_buildings append ([_center, _grandAxis] call _retrieveObjects);
};
_buildings inAreaArray _area
