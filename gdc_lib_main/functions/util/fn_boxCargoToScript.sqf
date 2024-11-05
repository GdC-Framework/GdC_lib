/**
 * @brief Get all items inside given boxes, and return a script for execution
 *
 * Parameters :
 * @param {Array} _boxes Array of boxes.
 * @param {Bool} _init Use this instead of _this variable for init executions.
 * @param {Bool} _formatted, Add line returns to format code.
 *
 * @returns {Array} list of units
 *
 * @author Migoyan
 *
 */
params[
	"_boxes",
	["_init", false, [false]],
	["_formatted", false, [false]]
];

private [
	"_cargo", "_cargoCounts", "_inventory", "_inventoryCargo", "_separator",
	"_script", "_variable"
];

_variable = ["_this", "this"] select _init;
// [Carriage Return, new line]
_separator = ["", toString [0x0D, 0x0A]] select _formatted;

_script = [
	format["clearItemCargoGlobal %1;", _variable],
	format["clearMagazineCargoGlobal %1;", _variable],
	format["clearWeaponCargoGlobal %1;", _variable],
	format["clearBackpackCargoGlobal %1;", _variable]
];
{
	try {
		_inventory = [
			getItemCargo _x, getMagazineCargo _x, getWeaponCargo _x,
			getBackpackCargo _x
		];
	} catch {
		continue
	};

	if (_formatted) then {
		_script pushBack "";
	};

	// Items
	_inventoryCargo = _inventory#0;
	_cargo = _inventoryCargo#0; _cargoCounts = _inventoryCargo#1;
	for "_i" from 0 to (count _cargo - 1) do {
		_script pushBack format[
			"%1 addItemCargoGlobal [""%2"", %3];",
			_variable, _cargo#_i, _cargoCounts#_i
		];
	};

	// Magazines
	_inventoryCargo = _inventory#1;
	_cargo = _inventoryCargo#0; _cargoCounts = _inventoryCargo#1;
	for "_i" from 0 to (count _cargo - 1) do {
		_script pushBack format[
			"%1 addMagazineCargoGlobal [""%2"", %3];",
			_variable, _cargo#_i, _cargoCounts#_i
		];
	};

	// Weapons
	_inventoryCargo = _inventory#2;
	_cargo = _inventoryCargo#0; _cargoCounts = _inventoryCargo#1;
	for "_i" from 0 to (count _cargo - 1) do {
		_script pushBack format[
			"%1 addWeaponCargoGlobal [""%2"", %3];",
			_variable, _cargo#_i, _cargoCounts#_i
		];
	};

	// Backpacks
	_inventoryCargo = _inventory#3;
	_cargo = _inventoryCargo#0; _cargoCounts = _inventoryCargo#1;
	for "_i" from 0 to (count _cargo - 1) do {
		_script pushBack format[
			"%1 addBackpackCargoGlobal [""%2"", %3];",
			_variable, _cargo#_i, _cargoCounts#_i
		];
	};
} forEach _boxes;
if (_formatted) then {
	_script pushBack "";
};

_script joinString _separator
