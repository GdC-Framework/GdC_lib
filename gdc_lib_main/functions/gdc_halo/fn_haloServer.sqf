/*
	Author: Sparfell, Reyhard

	Description:
	Function for gdc_halo executed serverside, spawn the plane make it move above DZ, teleport players inside and, finally delete the plane.

	Parameter(s):
		none

	Returns:
	nothing
*/

if (!isserver) exitWith {};

private["_jumpPos","_spawnPos","_dir","_veh","_crew","_crewCount","_group","_ArrayPlayers","_openRamp","_closeRamp"];

// création des positions
_jumpPos = MarkerPos "mk_gdc_halo";
if (gdc_halo_spawnpos in [[0,0,0]]) then {
	// spawn avion, position aléatoire.
	_spawnPos = (MarkerPos "mk_gdc_halo") getPos [6000,(random 360)];
	//Récupération du marqueur "AVION" si présent
	{
		_spawnPos = MarkerPos _x;
	} forEach (allMapMarkers select {markerText _x == "AVION"});
} else {
	// spawn avion, position définie.
	_spawnPos = gdc_halo_spawnpos;
};
// Si la position de spawn est trop proche, en trouver une autre dans le même axe.
if ((_spawnPos distance2D _jumpPos) < 5000) then {
	_spawnPos = (MarkerPos "mk_gdc_halo") getPos [6000,((MarkerPos "mk_gdc_halo") getdir _spawnPos)];
};

_dir = _spawnPos getDir (MarkerPos "mk_gdc_halo");
"mk_gdc_halo" setMarkerDir (_dir - 180);

// Création de l'avion sur le point d'insertion
_veh = [_spawnPos,_dir,gdc_halo_vtype,civilian] call bis_fnc_spawnvehicle;
_veh params ["_veh","_crew","_group"];

_veh allowDamage false;
_crewCount = count _crew;
if (gdc_halo_lalo) then {
	_veh flyInHeight gdc_halo_alt;
} else {
	_veh flyInHeightASL [gdc_halo_alt,gdc_halo_alt,gdc_halo_alt];
};
_veh setpos [(_spawnPos select 0),(_spawnPos select 1),gdc_halo_alt];
if (_veh isKindOf "Plane") then {_veh setVelocityModelSpace [0,100,0];};
{_x disableAI "AUTOTARGET";_x disableAI "AUTOCOMBAT"; _x disableAI "CHECKVISIBLE"; _x allowDamage false;} foreach _crew;
clearMagazineCargoGlobal _veh;
clearWeaponCargoGlobal _veh;
clearItemCargoGlobal _veh;
clearBackpackCargoGlobal _veh;

// Allumage des lampes intérieures si disponibles (véhicules RHS)
if ("cargolights_hide" in (animationNames _veh)) then {
	_veh animateSource ["cargolights_hide",0];
	(_veh turretUnit [0]) action ["searchlightOn",_veh];
};

// Création du WP de HALO
_jumpPos = [(_jumpPos select 0),(_jumpPos select 1),gdc_halo_alt];
_wp = _group addWaypoint [_jumpPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "STEALTH";
_wp setWaypointCombatMode "BLUE";
if (_veh isKindOf "Plane") then {_wp setWaypointSpeed "LIMITED";};

sleep 4;

// Déplacement des joueurs dans l'avion.
if (isMultiplayer) then {
	_ArrayPlayers = playableUnits;
} else {
	_ArrayPlayers = switchableUnits;
};
{
	_x assignAsCargoIndex [_veh, (_forEachIndex + 1)];
	[_x,[_veh,(_forEachIndex + 1)]] remoteExecCall ["moveInCargo",_x];
	sleep 0.1;
} forEach (_ArrayPlayers select {_x inArea gdc_halo_area});

// Feu vert pour un autre HALO
gdc_halo_dispo = true;
publicVariable "gdc_halo_dispo";

sleep 2;

if (gdc_halo_autojump) then {
// L'avion fait un seul passage et tous les joueurs sont éjectés un à un.
	// Ouverture de la rampe
	waitUntil {((getpos _veh) distance2D _jumpPos) < 2000};
	[_veh,1] call GDC_fnc_animVehicleDoor;
	// Green light
	waitUntil {((getpos _veh) distance2D _jumpPos) < 1000};
	if ("jumplights_hide" in (animationNames _veh)) then {
		_veh animateSource ["jumplight",1];
	};
	// saut auto
	_wp setWaypointStatements ["true","
		[this] spawn {
			_veh = vehicle (leader (_this select 0));
			if(not(local _veh))exitWith{};
			private _delay =  (1/(((speed _veh) max 55)/150));
			private _cargo = assignedCargo _veh;
			{
				_x disableCollisionWith _veh;
				moveout _x;
				unassignVehicle _x;
				[_x] allowGetIn false;
				sleep _delay;
				if (gdc_halo_lalo) then {
					private _para = 'NonSteerable_Parachute_F';
					if (isClass (configFile >> 'CfgPatches' >> 'rhs_main')) then {
						_para = 'rhs_d6_Parachute';
					};
					_para = _para createVehicle [0,0,0];
					_para setPosASL (getPosASLVisual _x);
					_para setVectorDirAndUp [vectorDirVisual _x,vectorUpVisual _x];
					if(! local _x)then{[_x,_para] remoteExecCall ['moveInDriver',_x]}else{_x moveInDriver _para;};
					_x assignAsDriver _para;
					[_x] allowGetIn true;
					[_x] orderGetIn true;
				};
			} foreach _cargo;
			{
				(group _x) leaveVehicle _veh;
				_x enableCollisionWith _veh;
			} foreach _cargo;
		};
	"];
	
	// WP d'éloignement
	_wp = _group addWaypoint [(_veh getRelPos [8000, 0]), 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointStatements ["true", "{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach units group this;"];
	// Fermeture de la rampe
	waitUntil {(count crew _veh) == _crewCount};
	_veh allowDamage true;
	sleep 3;
	[_veh,0] call GDC_fnc_animVehicleDoor;
} else {
// L'avion fait des boucle sur la DZ jusqu'à ce que tous les joueurs aient sauté
	while {(count crew _veh) > _crewCount} do {
		// Ouverture de la rampe
		waitUntil {((getpos _veh) distance2D _jumpPos) < 2000};
		[_veh,1] call GDC_fnc_animVehicleDoor;
		// Green light
		waitUntil {((getpos _veh) distance2D _jumpPos) < 1000};
		if ("jumplights_hide" in (animationNames _veh)) then {
			_veh animateSource ["jumplight",1];
		};
		
		// WP d'éloignement
		_wp = _group addWaypoint [(_veh getRelPos [6000, 0]), 0];
		_wp setWaypointType "MOVE";
		
		// Red light
		waitUntil {((getpos _veh) distance2D _jumpPos) > 1000};
		if ("jumplights_hide" in (animationNames _veh)) then {
			_veh animateSource ["jumplight",0];
		};
		// Fermeture de la rampe
		waitUntil {((getpos _veh) distance2D _jumpPos) > 2000};
		[_veh,0] call GDC_fnc_animVehicleDoor;
		
		// WP de retour sur DZ
		_wp = _group addWaypoint [_jumpPos, 0];
		_wp setWaypointType "MOVE";
	};
	_veh allowDamage true;

	// suppression de l'avion
	sleep 25;
	deleteVehicle _veh;
	{deleteVehicle _x;} forEach units _group;
};