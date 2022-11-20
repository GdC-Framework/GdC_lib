/*
	Author: Sparfell

	Description:
	Creates a list of ennemy targets known by the pluto side

	Parameter(s): 
		SIDE - side to analyze

	Returns:
	[_side,_groupList,_targetList]
*/
params ["_side"];
private ["_unit","_veh","_targets","_range"];

// Supprimer les markers de debug
if (gdc_plutoDebug) then {
	{
		deleteMarker _x;
	} forEach (allMapMarkers select {(_x find "mk_plutotarget") >= 0});
};

// Mettre à jour la liste des groupes sous le commandement de PLUTO
private _groupList = (allGroups select {(side _x == _side) && !(isPlayer (leader _x)) && ((count (units _x)) > 0) && ((_x getVariable ["PLUTO_ORDER","DEFAULT"]) != "IGNORE")});

// Vider la liste des cibles avant de la mettre à jour
private _targetList = [];

// Boucle sur tous les groupes sous le commandement de PLUTO
{
	_unit = leader _x;
	_veh = vehicle _unit;
	_range = switch true do {
		case (_veh isKindOf "Man"): {gdc_plutoRangeSensorMan};
		case (_veh isKindOf "Air"): {gdc_plutoRangeSensorAir};
		default {gdc_plutoRangeSensorLand}; //"LandVehicle"
	};
	_range = _x getVariable ["PLUTO_SENSORRANGE",_range]; // Eventuel range custom
	// Boucle sur toutes les cibles dans le range du groupe
	_targets = _unit nearTargets _range;
	{
		_x params ["_targetPos","","_targetSide","","_target","_targetPosAcc"];
		if ((count (crew _target)) > 0) then {_targetSide = side ((crew _target) #0);};
		// Vérifier que la cible n'est pas le HC, qu'elle n'est pas déjà dans la liste, qu'elle n'est pas amie et qu'elle est bien réelle
		if ((_target != HC_Slot) && !(_target in _targetList) && (_targetSide != _side) && ((_side getFriend _targetSide) < 0.6) && (_target iskindof "AllVehicles")) then {
			// Vérifier que la cible est vivante, que le groupe a suffisament d'infos sur la cible, que la cible n'est pas captive et que ce n'est pas un véhicule vide
			if ((alive _target) && ((_unit knowsAbout _target) >= 0.2) && (!captive _target) && ((count (crew _target)) > 0)) then {
				_targetList = _targetList + [_target]; // ajouter la cible dans la liste
				// DEBUG
				if (gdc_plutoDebug) then {
					_mk = createMarkerLocal [(format ["mk_plutotarget_%1",_target]),_targetPos];
					_mk setMarkerTypeLocal "mil_dot";
					_mk setMarkerColorLocal ("Color" + (str _targetSide));
				};
			};
		};
	} forEach _targets;
} forEach _groupList;

// DEBUG
if (gdc_plutoDebug) then {
	systemChat ((str _side) + " targets : " + (str (count _targetList)));
	//systemChat ("known targets : " + (str _targetList));
};

[_side,_groupList,_targetList];
