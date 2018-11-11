/*
	Author: Sparfell

	Description:
	this function will allow the players to choose their helicopter insertion position during the briefing by moving a marker on the map using leftmousebutton
	On mission launch, players will be moved inside an AI pilot helicopter transporting them to the designated LZ
	
	Parameter(s):
		0 : STRING - name of the marker that will be moved, the marker defines the landing zone
		1 : STRING - classname of the helicopter
		2 (Optional): SIDE - side of the insertion helicopter (blufor,opfor,independent,civilian) (default: civilian)
		3 (Optional): ARRAY - array fo unit objects that will be moved in the helicopter at mission start (default: []) if [] all playableunits will be moved
		4 (Optional): STRING - rank required in order to be able to move the marker (default: "SERGEANT")
		5 (Optional):
			ARRAY - position for helicopter spawn (if = [0,0,0] the position is randomized) (default: [0,0,0])
			STRING - marker name (the marker should represent the main ennemy position, the helicopter will come from the opposite direction)
		6 (Optional): ARRAY of STRINGs and/or OBJECTs - list of marker names or trigger names defining blacklisted areas (default: [])
		7 (Optional): NUMBER - 0: land only, 1: land and water, 2: water only (default: 1)

	Returns:
	nothing
*/

params ["_mk","_type",["_side",civilian],["_units",[]],["_rank","SERGEANT"],["_spawnpos",[0,0,0]],["_blist",[]],["_water",1]];

// Si le 2e paramètre n'est pas renseigné toutes les unités jouables sont déplacées
if ((count _units) == 0) then {
	if (isMultiplayer) then {
		_units = playableUnits;
	} else {
		_units = switchableUnits;
	};
};

// si le joueur a le rang requis il peut déplacer le marqeur avec un clic gauche sur la carte
if (rank player == _rank) then {
	[_mk,_blist,_water] onMapSingleClick {
		_valid = true;
		// on check si la position choisie n'est pas dans les zones blacklistées
		{
			if (_pos Inarea _x) then {
				_valid = false;
			};
		} forEach (_this select 1);
		// on check si la position choisie est sur l'eau ou pas en fonction du paramètre
		if ((_this select 2) != 1) then {
			switch (_this select 2) do {
				case 0: {if (surfaceIsWater _pos) then {_valid = false};};
				case 2: {if !(surfaceIsWater _pos) then {_valid = false};};
				default {_valid = false};
			};
		};
		// déplacement du marqueur
		if (_valid) then {
			(_this select 0) setmarkerPos _pos;
		};
	};
};

[_mk,_type,_side,_units,_spawnpos] spawn {
	private ["_pos","_veh","_group","_wp","_spawnpos"];
	// au début de la mission, désactivation de la possibilité de déplacer le marqeur
	waituntil {time > 0};
	onMapSingleClick "";
	_spawnpos = (_this select 4);

	// création de l'hélico et déplacement des unités dedans
	if (isServer) then {
		_pos = (MarkerPos (_this select 0));
		// déterminer la position de spawn
		switch true do {
			case (_spawnpos in [[0,0,0]]): {
				// position de spawn aléatoire
				_spawnpos = _pos getPos [4000,(random 360)];
			};
			case ((typeName _spawnpos) == "STRING"): {
				// position de spawn en fonction d'un marqueur
				_spawnpos = _pos getPos [4000,((markerPos _spawnpos) getdir _pos)];
			};
			default {_spawnpos = _spawnpos;};
		};
		// helipad
		_veh = "Land_HelipadEmpty_F" createVehicle _pos;
		if (surfaceIsWater _pos) then {_veh setposASL [(_pos select 0),(_pos select 1),2];};
		// spawn hélico
		_veh = [_spawnpos,(_spawnpos getdir _pos),(_this select 1),(_this select 2)] call BIS_fnc_spawnVehicle;
		_group = _veh select 2;
		_veh = _veh select 0;
		_veh disableAI "AUTOTARGET";
		_veh disableAI "AUTOCOMBAT";
		_veh disableAI "SUPPRESSION";
		_veh allowdamage false;
		{_x allowdamage false;} forEach (crew _veh);
		clearMagazineCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		// ajout du WP sur la LZ
		_wp = _group addWaypoint [_pos, 0];
		_wp setWaypointType "TR UNLOAD";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointStatements ["true", "{_x allowdamage true;} forEach (units group this); (vehicle this) allowdamage true;"];
		// ajout du WP de dépop
		_wp = _group addWaypoint [_spawnpos, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointStatements ["true", "{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach units group this;"];
		// déplacer les unités dans l'hélico
		{
			_x assignAsCargoIndex [_veh, (_forEachIndex + 1)];
			[_x,[_veh,(_forEachIndex + 1)]] remoteExecCall ["moveInCargo",_x];
			sleep 0.1;
		} forEach (_this select 3);
	};
};