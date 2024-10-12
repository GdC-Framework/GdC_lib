/**
 * @brief Spawn a specified number of units within a building. Exterior units
 * should face away from the building.
 *
 * Parameters :
 * @param {Array} _buildings List of buildings.
 * @param {Number} _unitNumber Number of spawned units.
 * @param {Side} _side, of unit spawned.
 * @param {Array} _unit_ai_disable, List of AI functionnalities to be disabled.
 *
 * @returns {Array} list of units
 *
 * @author Migoyan
 *
 */
params[
	'_buildings',
	'_unitNumber',
	['_side', east, [east]],
	['_classname', 'O_Soldier_F', ['', []]],
	['_unit_ai_disable', [], [[]]]
];

if (count _buildings isEqualTo 0 || _unitNumber isEqualTo 0) exitWith {
	[]
};

private [
	'_building', '_buildingsAndpositions', '_group', '_position', '_positions',
	'_selectedBuildAndPos', '_unit', '_units'
];

_buildingsAndpositions = [];
{
	_building = _x;
	_positions = (_building buildingPos -1);

	_buildingsAndpositions append (_positions apply {[_x, _building]})
} forEach _buildings;

_units = [];
_selectedBuildAndPos = [
	_buildingsAndpositions, _unitNumber
] call CBA_fnc_selectRandomArray;
_group = createGroup [east, LUCY_IA_REMOVE_EMPTY_GROUPS];
_group setFormDir random 360;
{
	_building = _x#1;
	_position = _x#0;
	_classname createUnit [_position, _group, "lucyUnitSpRdBdP = this"];
	_units pushback lucyUnitSpRdBdP;
	lucyUnitSpRdBdP setPosATL _position;
	{
        lucyUnitSpRdBdP disableAI _x;
    } forEach _unit_ai_disable;
} forEach _selectedBuildAndPos;


// Empiric value to let insideBuilding command time to refresh its value.
sleep 1;

{
	_unit = _units#_forEachIndex;
	_building = _x#1;
	_position = _x#0;

	if (insideBuilding _unit < .9) then {
		_unit doWatch (
			_position getPos [100, (_building getDirVisual _position)]
		);
	};
	_unit addEventHandler [
		"Suppressed",
		{
			(_this#0) doWatch objNull;
			(_this#0) removeEventHandler [_thisEvent, _thisEventHandler];
		}
	];
} forEach _selectedBuildAndPos;

_units
