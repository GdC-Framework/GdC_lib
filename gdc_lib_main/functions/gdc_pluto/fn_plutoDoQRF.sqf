/*
	Author: Sparfell

	Description:
	Actions for the QRF group

	Parameter(s):
		0 : GROUP - QRF group
		1 : ARRAY - list of available targets

	Returns:
	nothing
*/

params ["_group","_targetList"];

// Ne lancer une QRF que si le groupe n'a pas reçu d'ordres depuis x minutes (x étant défini par plutoQRFTimeout)
if ((time - (_group getVariable ["PLUTO_LASTORDER",0])) > (_group getVariable ["PLUTO_QRFTIMEOUT",gdc_plutoQRFTimeout])) then {

	private ["_veh","_targets","_target","_mk","_range","_condition"];

	_veh = vehicle (leader _group);
	// Différents range de QRF en fonction du type d'unité.
	_range = switch true do {
		case (_veh isKindOf "Man"): {gdc_plutoRangeQRFMan};
		case (_veh isKindOf "Air"): {gdc_plutoRangeQRFAir};
		default {gdc_plutoRangeQRFLand}; //"LandVehicle"
	};
	_range = _group getVariable ["PLUTO_QRFRANGE",_range]; // Eventuel range custom
	// Ranger les cibles connues en fonction de la distance par rapport au groupe et ne garder que celles qui sont dans le range du groupe, qui ne sont pas dans des véhicules aériens ou maritimes et qui ne sont pas en déplacement rapide :
	if ((typeName _range) in ["STRING","OBJECT"]) then {
		_targets = [_targetList,[_veh],{_input0 distance _x},"ASCEND",{!((vehicle _x) isKindOf "Air") && !(surfaceIsWater (getpos _x)) && ((speed _x) < 30) && (_x inArea _range)}] call BIS_fnc_sortBy; // Cas d'une zone
	} else {
		_targets = [_targetList,[_veh],{_input0 distance _x},"ASCEND",{!((vehicle _x) isKindOf "Air") && !(surfaceIsWater (getpos _x)) && ((speed _x) < 30) && ((_input0 distance _x) < _range)}] call BIS_fnc_sortBy; // Cas d'une distance
	};
	// Si des cibles sont diponibles lancer la QRF
	if ((count _targets) > 0) then {
		_target = _targets select 0; // Sélectionner la cible la plus proche
		_group setVariable ["PLUTO_LASTORDER",time]; // Le groupe recoit un nouvel ordre : mettre à jour son timing
		// marker de debug
		if (gdc_plutoDebug) then {
			if ((markerType (format ["mk_QRF%1",_veh])) == "") then{
				_mk = createMarkerLocal [(format ["mk_QRF%1",_veh]),(getpos _target)];
				_mk setMarkerTypeLocal "mil_destroy";
				_mk setMarkerColorLocal "ColorRed";
				_mk setMarkerTextLocal ((str _group) + (typeOf _veh));
			} else {
				(format ["mk_QRF%1",_veh]) setMarkerPosLocal (getpos _target);
			};
		};

		[_group,_target] spawn gdc_fnc_plutoSAD;
	};
};
