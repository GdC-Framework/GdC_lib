/*
	Author: Sparfell

	Description:
	Reveal the targets to the appropriate groups and execute actions if necesssary

	Parameter(s): None

	Returns:
	nothing
*/

private ["_unit","_group","_count","_targetList","_range"];

// Boucle sur tous les groupes sous le commandement de PLUTO
{
	_unit = leader _x;
	_group = _x;
	_veh = vehicle (leader _group);
	// Différents range de reveal en fonction du type d'unité.
	_range = switch true do {
		case (_veh isKindOf "Man"): {gdc_plutoRangeRevealMan};
		case (_veh isKindOf "Air"): {gdc_plutoRangeRevealAir};
		default {gdc_plutoRangeRevealLand}; //"LandVehicle"
	};
	_range = _x getVariable ["PLUTO_REVEALRANGE",_range]; // Eventuel range custom
	// Parmi la liste de cibles disponibles ne sélectionner que celles qui sont dans le Range et qui ne sont pas déjà connues par le groupe :
	_targetList = gdc_plutoTargetList select {((_unit distance (_x #0)) < _range) && ((_unit knowsAbout (_x #0)) < 1)};
	// Révéler les cibles ainsi sélectionnées :
	{
		_group reveal [(_x #0),(_x #1)];
	} forEach _targetList;
	// Si des cibles ont été révélées, générer des actions en fonction des ordres des unités
	_count = count _targetList;
	if (_count > 0) then {
		// DEBUG
		if (gdc_plutoDebug) then {systemChat ((str _count) + " units revealed to " + (str _group));};
		// Actions en fonction de la variable
		switch (_group getVariable ["PLUTO_ORDER","DEFAULT"]) do {
			case "QRF": {[_group,((flatten _targetList) select {(typeName _x) == "OBJECT"})] call gdc_fnc_plutoDoQRF;};
			case "ARTY": {[_group,((flatten _targetList) select {(typeName _x) == "OBJECT"})] call gdc_fnc_plutoDoArty;};
			case "IGNORE";
			case "DEFAULT";
			default {};
		};
	};
} forEach gdc_plutoGroupList;