/*
	Author: Sparfell, Reyhard

	Description:
	Function for gdc_halo, effects on player from airport to DZ

	Parameter(s):
		none

	Returns:
	nothing
*/
private _unit = player;

if !(_unit inArea gdc_halo_area) exitWith {};

if (gdc_halo_lalo) then {
// Saut LALO
	// Fondu au noir
	titleText ["","BLACK OUT",3];
	3 fadeSound 0;
	sleep 3.0;

	// Attendre que le joueur soit dans l'avion
	waitUntil {(vehicle _unit) iskindof gdc_halo_vtype};
	_unit allowdamage false;

	// Fondu d'ouverture
	sleep 3.0;
	3 fadeSound 1;
	titleFadeOut 3;

	if (!gdc_halo_autojump) then {
	// Valide uniquement si ce n'est pas du autojump, sinon l'ajout du parachute est géré dans le script d'autojump (fn_haloServer.sqf)
		// Attendre que le joueur soit hors de l'avion
		waitUntil {(vehicle _unit) == _unit};

		sleep 1.0;
		// Création et attribution du parachute
		private _para = "NonSteerable_Parachute_F";
		if (isClass (configFile >> 'CfgPatches' >> 'CUP_AirVehciles_StaticLine')) then {
			_para = "CUP_T10_Parachute";
		};
		if (isClass (configFile >> 'CfgPatches' >> 'rhs_main')) then {
			_para = "rhs_d6_Parachute";
		};
		_para = _para createVehicle [0,0,0];
		_para setPosASL (getPosASLVisual _unit);
		_para setVectorDirAndUp [vectorDirVisual _unit,vectorUpVisual _unit];
		_unit moveInDriver _para;
		_unit assignAsDriver _para;
		[_unit] allowGetIn true;
		[_unit] orderGetIn true;
	};

	// Pas de dégâts à l'arrivée au sol.
	waitUntil {(getposATL _unit select 2) < 20};
	waitUntil {(vehicle _unit) == _unit};
	sleep 2.0;
	_unit allowdamage true;
} else {
// Saut HALO
	private ["_b","_bi","_i","_hasGPS"];

	// Fondu au noir
	titleText ["","BLACK OUT",3];
	3 fadeSound 0;
	sleep 3.0;

	// Sauvegarde inventaire
	_b = backpack _unit;
	_bi = backpackItems _unit;

	// Ajout parachute
	removeBackpack _unit;
	_unit addbackpack "B_Parachute";
	// Ajout GPS
	if (gdc_halo_gps) then {
		_i = assignedItems _unit;
		_hasGPS = false;
		{
			if (_x in _i) then {_hasGPS = true;};
		} forEach ["ItemGPS","I_UavTerminal","B_UavTerminal","O_UavTerminal","C_UavTerminal"];
		if (!_hasGPS) then {_unit linkitem "ItemGPS"};
	};

	// Attendre que le joueur soit dans l'avion
	waitUntil {(vehicle _unit) iskindof gdc_halo_vtype};
	_unit allowdamage false;

	// Fondu d'ouverture
	sleep 3.0;
	3 fadeSound 1;
	titleFadeOut 3;

	// Attendre que le joueur atterisse pour lui redonner son sac
	waitUntil {(getposATL _unit select 2) < 20};
	_unit allowdamage true;
	waitUntil {(vehicle _unit) == _unit};
	sleep 2.0;
	removeBackpack _unit;
	_unit addbackpack _b;
	{
		_unit additemtobackpack _x;
	} foreach _bi;
	// Enlever le GPS
	if (gdc_halo_gps) then {
		if (!_hasGPS) then {_unit unlinkItem "ItemGPS";};
	};
};
