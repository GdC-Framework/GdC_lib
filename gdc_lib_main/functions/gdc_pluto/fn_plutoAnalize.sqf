/*
	Author: Sparfell

	Description:
	Creates a list of ennemy targets known by the pluto side

	Parameter(s): None

	Returns:
	nothing
*/

private ["_unit","_veh","_targetList","_targetPos","_targetSide","_target","_targetPosAcc","_range"];

// Supprimer les markers de debug
if (gdc_plutoDebug) then {
	{
		deleteMarker _x;
	} forEach gdc_plutoMkDebugList;
	gdc_plutoMkDebugList = [];
};

// Mettre à jour la liste des groupes sous le commandement de PLUTO
gdc_plutoGroupList = (allGroups select {(side _x == gdc_plutoSide) && ((count (units _x)) > 0) && ((_x getVariable ["PLUTO_ORDER","DEFAULT"]) != "IGNORE")});

// Vider la liste des cibles avant de la mettre à jour
gdc_plutoTargetList = [];

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
	_targetList = _unit nearTargets _range;
	{
		_x params ["_targetPos","","_targetSide","","_target","_targetPosAcc"];
		// Vérifier que la cible n'est pas le HC, qu'elle n'est pas déjà dans la liste, qu'elle n'est pas amie et qu'elle est bien réelle
		if ((_target != HC_Slot) && !(_target in gdc_plutoTargetList) && (_targetSide != gdc_plutoSide) && ((gdc_plutoSide getFriend _targetSide) < 0.6) && (_target iskindof "AllVehicles")) then {
			// Vérifier que la cible est vivante, que le groupe a suffisament d'infos sur la cible et que la cible n'est pas captive
			if ((alive _target) && ((_unit knowsAbout _target) >= 0.2) && (!captive _target)) then {
				gdc_plutoTargetList = gdc_plutoTargetList + [_target]; // ajouter la cible dans la liste
				// DEBUG
				if (gdc_plutoDebug) then {
					_mk = createMarkerLocal [(format ["mk_target%1",_target]),_targetPos];
					_mk setMarkerTypeLocal "mil_dot";
					_mk setMarkerColorLocal "ColorOrange";
					gdc_plutoMkDebugList = gdc_plutoMkDebugList + [_mk];
				};
			};
		};
	} forEach _targetList;
} forEach gdc_plutoGroupList;

// DEBUG
if (gdc_plutoDebug) then {
	systemChat ("known targets : " + (str (count gdc_plutoTargetList)));
	//systemChat ("known targets : " + (str gdc_plutoTargetList));
};