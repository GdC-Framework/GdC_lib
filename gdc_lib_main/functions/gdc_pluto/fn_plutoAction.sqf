/*
	Author: Sparfell

	Description:
	Reveal the targets to the appropriate groups and execute actions if necesssary

	Parameter(s): 
		SIDE : side that will act
		ARRAY : groups list of the active side
		ARRAY : targets list of the active side

	Returns:
	nothing
*/
params ["_side","_groupList","_targetList"];
private ["_unit","_group","_count","_range","_targets"];

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
	// Parmi la liste de cibles disponibles ne sélectionner que celles qui sont dans le Range du groupe :
	_targets = _targetList select {(_unit distance _x) < _range};
	// Révéler les cibles ainsi sélectionnées :
	{
		_group reveal [_x,1.5];
	} forEach _targets;
	// Si des cibles ont été révélées, générer des actions en fonction des ordres des unités
	_targets = _targets select {(_unit knowsAbout _x) >= 1}; // Ne lancer des actions spéciales que si la cible est suffisament connue
	_count = count _targets;
	if (_count > 0) then {
		// DEBUG
		//if (gdc_plutoDebug) then {systemChat ((str _count) + " units revealed to " + (str _group));};
		// Actions en fonction de la variable
		switch (_group getVariable ["PLUTO_ORDER","DEFAULT"]) do {
			case "QRF": {[_group,_targets] call gdc_fnc_plutoDoQRF;};
			case "ARTY": {[_group,_targets] call gdc_fnc_plutoDoArty;};
			case "IGNORE";
			case "DEFAULT";
			default {};
		};
	};
} forEach _groupList;
