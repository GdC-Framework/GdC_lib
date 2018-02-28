/*
	Author: Sparfell, Reyhard

	Description:
	Function for gdc_halo, effects on player from airport to DZ

	Parameter(s):
		none

	Returns:
	nothing
*/

if !(player inArea gdc_halo_area) exitWith {};

if (gdc_halo_lalo) then {
// Saut LALO
	// Fondu au noir
	titleText ["","BLACK OUT",3];
	3 fadeSound 0;
	sleep 3.0;

	// Attendre que le joueur soit dans l'avion
	waitUntil {(vehicle player) iskindof gdc_halo_vtype};
	player allowdamage false;

	// Fondu d'ouverture
	sleep 3.0;
	3 fadeSound 1;
	titleFadeOut 3;

	if (!gdc_halo_autojump) then {
	// Valide uniquement si ce n'est pas du autojump, sinon l'ajout du parachute est géré dans le script d'autojump (fn_haloServer.sqf)
		// Attendre que le joueur soit hors de l'avion
		waitUntil {(vehicle player) == player};

		sleep 1.0;
		// Création et attribution du parachute
		private _para = "NonSteerable_Parachute_F";
		if (isClass (configFile >> 'CfgPatches' >> 'rhs_main')) then {
			_para = "rhs_d6_Parachute";
		};
		_para = _para createVehicle [0,0,0];
		_para setPosASL (getPosASLVisual player);
		_para setVectorDirAndUp [vectorDirVisual player,vectorUpVisual player];
		player moveInDriver _para;
		player assignAsDriver _para;
		[player] allowGetIn true;
		[player] orderGetIn true;
	};

	// Pas de dégâts à l'arrivée au sol.
	waitUntil {(getposATL player select 2) < 20};
	waitUntil {(vehicle player) == player};
	sleep 2.0;
	player allowdamage true;
} else {
// Saut HALO
	private ["_b","_bi","_i"];

	// Fondu au noir
	titleText ["","BLACK OUT",3];
	3 fadeSound 0;
	sleep 3.0;

	// Sauvegarde inventaire
	_b = backpack player;
	_bi = backpackItems player;
	_i = assignedItems player;

	// Ajout parachute + GPS
	removeBackpack player;
	player addbackpack "B_Parachute";
	if (gdc_halo_gps) then {
		player linkitem "ItemGPS";
	};

	// Attendre que le joueur soit dans l'avion
	waitUntil {(vehicle player) iskindof gdc_halo_vtype};
	player allowdamage false;

	// Fondu d'ouverture
	sleep 3.0;
	3 fadeSound 1;
	titleFadeOut 3;

	// Attendre que le joueur atterisse pour lui redonner son sac
	waitUntil {(getposATL player select 2) < 20};
	player allowdamage true;
	waitUntil {(vehicle player) == player};
	sleep 2.0;
	removeBackpack player;
	player addbackpack _b;
	{
		player additemtobackpack _x;
	} foreach _bi;
	if (gdc_halo_gps) then {
		if (!("ItemGPS" in _i)) then {player unlinkItem "ItemGPS";};
	};
};