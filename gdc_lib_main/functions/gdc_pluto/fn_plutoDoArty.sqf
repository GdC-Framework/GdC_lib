/*
	Author: Sparfell

	Description:
	Actions for the arty units

	Parameter(s):
		0 : GROUP - arty group
		1 : ARRAY - list of available targets

	Returns:
	nothing
*/

params ["_group","_targetList"];

// Ne lancer une frappe que si la dernière frappe date de plus de x minutes (x étant défini par plutoQRFTimeout)
if ((time - (_group getVariable ["PLUTO_LASTORDER",0])) > (_group getVariable ["PLUTO_ARTYTIMEOUT",gdc_plutoArtyTimeout])) then {

	private ["_veh","_targets","_range","_mag"];

	_unit = (leader _group);
	_veh = vehicle _unit;
	_mag = (getArtilleryAmmo [_veh]);
	if ((count _mag) == 0) exitwith { // pas de frappe si le vehicule n'est pas un véhicule d'artillerie (cas d'un groupe débarqué suite à destruction du véhicule)
		if (gdc_plutoDebug) then {
			systemChat format ["ERROR ARTY %1 ""%2"" : no arty ammo available",typeof _veh,_group];
		};
	};
	_mag = (getArtilleryAmmo [_veh]) select 0;
	if (isNil _mag) then {
		private _weap = (_veh weaponsTurret ((assignedVehicleRole _unit) select 1)) select 0;
		_mag = (getArray (configFile >> "CfgWeapons" >> _weap >> "magazines")) select 0;
	};
	// utiliser le range terrestre par défaut
	_range = _group getVariable ["PLUTO_ARTYRANGE",gdc_plutoRangeQRFLand]; // Eventuel range custom
	// Ne garder que les cibles qui sont dans le range du groupe, qui sont à portée de tir de l'artillerie, qui ne sont pas dans des véhicules aériens, qui ne sont pas sur l'eau et qui ne sont pas en déplacement rapide
	if ((typeName _range) in ["STRING","OBJECT"]) then {
		_targets = _targetList select {((getpos _x) inRangeOfArtillery [[_unit],_mag]) && !((vehicle _x) isKindOf "Air") && !(surfaceIsWater (getpos _x)) && ((speed _x) < 20) && (_x inArea _range)}; // Cas d'une zone
	} else {
		_targets = _targetList select {((getpos _x) inRangeOfArtillery [[_unit],_mag]) && !((vehicle _x) isKindOf "Air") && !(surfaceIsWater (getpos _x)) && ((speed _x) < 20) && ((_veh distance _x) < _range)}; // Cas d'une distance
	};
	// Si des cibles sont diponibles lancer la frappe
	if ((count _targets) > 0) then {
		_group setVariable ["PLUTO_LASTORDER",time]; // Le groupe recoit un nouvel ordre : mettre à jour son timing
		private _target = selectrandom _targets; // Sélectionner une cible
		// Marge d'erreur pour la position de la cible
		private _error = _group getVariable ["PLUTO_ARTYERROR",gdc_plutoArtyError];
		_pos = (getpos _target) getpos [(random _error),(random 360)];
		// Le tir effectif se fait avec un délai
		[_unit,_pos,_mag,_group] spawn {
			params ["_unit","_pos","_mag","_group"];
			private _delay = _group getVariable ["PLUTO_ARTYDELAY",gdc_plutoArtyDelay];
			sleep (random _delay);
			private _rounds = _group getVariable ["PLUTO_ARTYROUNDS",gdc_plutoArtyRounds];
			_unit commandArtilleryFire [_pos,_mag,(round (random _rounds))];
			_veh setVehicleAmmo 1;
		};
		// marker de debug
		if (gdc_plutoDebug) then {
			if ((markerType (format ["mk_ARTY%1",_veh])) == "") then{
				private _mk = createMarkerLocal [(format ["mk_ARTY%1",_veh]),_pos];
				_mk setMarkerTypeLocal "mil_end";
				_mk setMarkerColorLocal "ColorPink";
				_mk setMarkerTextLocal ((str _group) + (typeOf _veh));
			} else {
				(format ["mk_ARTY%1",_veh]) setMarkerPosLocal _pos;
			};
		};
	};
};
