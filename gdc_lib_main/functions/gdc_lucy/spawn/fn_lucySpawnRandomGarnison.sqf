/**
 * @brief Spawn a random garnison on given area
 *
 * @param {String|Location} [_area = locationNull], marker and location area
 * @param {Number} [_unitNumbers = 0], number of units
 * @param {Side} [_side = east], side of patrols
 * @param {String} [_classname = "O_Soldier_F"], Classname of units spawned
 * @param {Array} [_excludeBuildings = []], Building to exclude from spawning
 *
 * @returns {Array} - list of units spawned
 * @author Migoyan
 */
params[
	["_area", locationNull, ["", locationNull]],
	["_unitNumbers", 0, [0]],
	["_side", east, [east]],
	["_classname", "O_Soldier_F", [""]],
	["_excludeBuildings", [], [[]]]
];

private _buildings = [_area, ["Building"]] call GDC_fnc_objectsInArea;

_buildings = _buildings - _excludeBuildings;

[
	_buildings, _unitNumbers, _east, _classname
] call GDC_fnc_lucySpawnRandomBuildingPos
