/**
 * @brief Spawn a random garnison on given area
 *
 * @param {String|Location} [_area = locationNull], marker and location area
 * @param {Number} [_unitNumbers = 0], number of units
 * @param {Side} [_side = east], side of patrols
 * @param {String} [_classname = "O_Soldier_F"], Classname of units spawned
 *
 * @returns {Array} - list of units spawned
 * @author Migoyan
 */
params[
	["_area", locationNull, ["", locationNull]],
	["_unitNumbers", 0, [0]],
	["_side", east, [east]],
	["_classname", "O_Soldier_F", [""]],
];

_buildings = [_area, ["Building"]] call GDC_fnc_objectsInArea;

[
	_buildings, _unitNumbers, _east, _classname
] call GDC_fnc_lucySpawnRandomGarnison
