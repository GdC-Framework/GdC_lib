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

	private ["_veh","_targets","_target","_mk","_range","_error"];

	_unit = (leader _group);
	_veh = vehicle _unit;
	_mag = (getArtilleryAmmo [_veh]) select 0;
	if (isNil _mag) then {
		_weap = (_veh weaponsTurret ((assignedVehicleRole _unit) select 1)) select 0;
		_mag = (getArray (configFile >> "CfgWeapons" >> _weap >> "magazines")) select 0;
	};
	// utiliser le range terrestre par défaut
	_range = _group getVariable ["PLUTO_ARTYRANGE",gdc_plutoRangeQRFLand]; // Eventuel range custom
	// Ne garder que les cibles qui sont dans le range du groupe et à portée de tir de l'artillerie
	if ((typeName _range) in ["STRING","OBJECT"]) then {
		_targets = _targetList select {(_x inArea _range) && ((getpos _x) inRangeOfArtillery [[_unit],_mag])}; // Cas d'une zone
	} else {
		_targets = _targetList select {((_veh distance _x) < _range) && ((getpos _x) inRangeOfArtillery [[_unit],_mag])}; // Cas d'une distance
	};
	// Si des cibles sont diponibles lancer la frappe
	if ((count _targets) > 0) then {
		_group setVariable ["PLUTO_LASTORDER",time]; // Le groupe recoit un nouvel ordre : mettre à jour son timing
		_target = selectrandom _targets; // Sélectionner une cible
		// Marge d'erreur pour la position de la cible
		_error = _group getVariable ["PLUTO_ARTYERROR",gdc_plutoArtyError];
		_pos = (getpos _target) getpos [(random _error),(random 360)];
		// Le tir effectif se fait avec un délai
		[_unit,_pos,_mag,_group] spawn {
			params ["_unit","_pos","_mag","_group"];
			private _delay = _group getVariable ["PLUTO_ARTYDELAY",gdc_plutoArtyDelay];
			sleep (random _delay);
			private _rounds = _group getVariable ["PLUTO_ARTYROUNDS",gdc_plutoArtyRounds];
			_unit commandArtilleryFire [_pos,_mag,(round (random _rounds))];
		};
		// marker de debug
		if (gdc_plutoDebug) then {
			if ((markerType (format ["mk_ARTY%1",_veh])) == "") then{
				_mk = createMarkerLocal [(format ["mk_ARTY%1",_veh]),_pos];
				_mk setMarkerTypeLocal "mil_end";
				_mk setMarkerColorLocal "ColorPink";
				_mk setMarkerTextLocal ((str _group) + (typeOf _veh));
			} else {
				(format ["mk_ARTY%1",_veh]) setMarkerPosLocal _pos;
			};
		};
	};
};