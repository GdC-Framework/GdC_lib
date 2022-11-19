/*
	Author: Sparfell

	Description:
	Fonction principale pour le système de commandement IA PLUTO
	Cette fonction Défini les paramètres de PLUTO et lance la boucle de PLUTO qui tournera tout au long de la mission
	A chaque boucle, PLUTO analyse les groupes sous son commandement et crée une liste de toutes les cibles ennemies connues.
	Ensuite, il transmet les informations sur les cibles ennemies aux groupes qui n'ont pas encore l'information en fonction des paramètres de REVEALRANGE
	Enfin, il donne des ordres aux groupes qui ont des ordres spéciaux : QRF et ARTY
	Par défaut toutes les IA des camps définis sont prisent en compte par PLUTO mais il est possible de faire en sorte qu'un groupe soit ignoré.

	Parameter(s):
		0 : SIDE or ARRAY of SIDEs - PLUTO side(s)
		1 (optionnal): ARRAY - reveal range [man,land,air] (default=[1000,2000,6000])
		2 (optionnal): ARRAY - sensor range [man,land,air] (default=[1500,2000,3000])
		3 (optionnal): NUMBER - QRF timeout (min time between two QRF orders) (default=120)
		4 (optionnal): ARRAY - QRF range [man,land,air] (default=[1000,2000,6000])
		5 (optionnal): ARRAY - QRF delay [min,moy,max] (time between the QRF order and the effective move) (default=[20,30,60])
		6 (optionnal): NUMBER - Arty timeout (min time between two arty orders) (default=240)
		7 (optionnal): ARRAY - arty delay [min,moy,max] (time between the arty order and the effective strike) (default=[20,30,60])
		8 (optionnal): ARRAY - arty rounds [min,moy,max] (number of rounds fired by arty on each strike) (default=[1,2,4])
		9 (optionnal): ARRAY - arty error [min,moy,max] (possible error for arty target position in meters from the real target position) (default=[0,40,100])

	Returns:
	nothing

	Beaucoup de paramètres peuvent être définis individuellement pour chaque groupe :
		(group this) setVariable ["PLUTO_ORDER","QRF"];
		(group this) setVariable ["PLUTO_ORDER","ARTY"];
		(group this) setVariable ["PLUTO_ORDER","IGNORE"];
		(group this) setVariable ["PLUTO_REVEALRANGE",1000];
		(group this) setVariable ["PLUTO_SENSORRANGE",1500];
		(group this) setVariable ["PLUTO_QRFTIMEOUT",120];
		(group this) setVariable ["PLUTO_QRFRANGE",1000]; // Peut aussi être une zone (marker/trigger) dans ce cas l'action ne se déclenche que si la cible est dans la zone
		(group this) setVariable ["PLUTO_QRFDELAY",[20,30,60]];
		(group this) setVariable ["PLUTO_ARTYTIMEOUT",240];
		(group this) setVariable ["PLUTO_ARTYRANGE",2000]; // Peut aussi être une zone (marker/trigger) dans ce cas l'action ne se déclenche que si la cible est dans la zone
		(group this) setVariable ["PLUTO_ARTYDELAY",[20,30,60]];
		(group this) setVariable ["PLUTO_ARTYROUNDS",[1,2,4]];
		(group this) setVariable ["PLUTO_ARTYERROR",[0,40,100]];
*/

if (hasInterface && !isServer) exitWith {};

params [
	"_sides",
	["_rangeReveal",[1000,2000,6000]],
	["_rangeSensor",[1500,2000,3000]],
	["_timeoutQRF",120],
	["_rangeQRF",[1000,2000,6000]],
	["_QRFDelay",[20,30,60]],
	["_timeoutarty",240],
	["_artydelay",[20,30,60]],
	["_artyrounds",[1,2,4]],
	["_artyerror",[0,40,100]]
];

// Camp qui va être sous le commandement de PLUTO
gdc_plutoSide = _sides;
if (_side isEqualType west) then { // retro compat
	_sides = [_sides];
};

// Distance max entre un groupe et une cible pour que l'info sur cette cible lui soit communiquée (peut être réglé indépendament pour chaque groupe avec PLUTO_SENSORRANGE)
gdc_plutoRangeRevealMan = _rangeReveal select 0;
gdc_plutoRangeRevealLand = _rangeReveal select 1;
gdc_plutoRangeRevealAir = _rangeReveal select 2;

// Distance max entre une cible et un groupe pour que l'info sur cette cible soit transmise à PLUTO (peut être réglé indépendament pour chaque groupe avec PLUTO_REVEALRANGE)
gdc_plutoRangeSensorMan = _rangeSensor select 0;
gdc_plutoRangeSensorLand = _rangeSensor select 1;
gdc_plutoRangeSensorAir = _rangeSensor select 2;

// Temps minimum entre deux ordres de QRF pour un même groupe (peut être réglé indépendament pour chaque groupe avec PLUTO_QRFTIMEOUT)
gdc_plutoQRFTimeout = _timeoutQRF;
// Distance max entre un groupe et une cible pour que le groupe puisse agir dessus (peut être réglé indépendament pour chaque groupe avec PLUTO_QRFRANGE)
gdc_plutoRangeQRFMan = _rangeQRF select 0;
gdc_plutoRangeQRFLand = _rangeQRF select 1;
gdc_plutoRangeQRFAir = _rangeQRF select 2;
// Délai avant que les QRF ne partent vers leur cible (peut être réglé indépendament pour chaque groupe avec PLUTO_QRFDELAY)
gdc_plutoQRFDelay = _QRFDelay;

// Temps minimum entre deux ordres de frappe pour une même artillerie (peut être réglé indépendament pour chaque groupe avec PLUTO_ARTYTIMEOUT)
gdc_plutoArtyTimeout = _timeoutarty;
// Délai avant les premiers départ de coups du soutien artillerie lorsqu'il a trouvé une cible
gdc_plutoArtyDelay = _artydelay;
// Nombre de coups tirés par l'artillerie [min,moy,max] (peut être réglé indépendament pour chaque groupe avec PLUTO_ARTYROUNDS)
gdc_plutoArtyRounds = _artyrounds;
// Imprecision des tirs de l'artillerie en mètres [min,moy,max] (peut être réglé indépendament pour chaque groupe avec PLUTO_ARTYERROR)
gdc_plutoArtyError = _artyerror;

// Listes
gdc_plutoTargetList = []; //just here for retro compat
gdc_plutoGroupList = []; //just here for retro compat


// Debug
if (isnil "gdc_plutoDebug") then {
	gdc_plutoDebug = false;
};

// La boucle tourne
if (isnil "gdc_plutoRun") then {
	gdc_plutoRun = true;
};

{
	publicVariable _x;
} forEach [
	"gdc_plutoSide",
	"gdc_plutoRangeRevealMan",
	"gdc_plutoRangeRevealLand",
	"gdc_plutoRangeRevealAir",
	"gdc_plutoRangeSensorMan",
	"gdc_plutoRangeSensorLand",
	"gdc_plutoRangeSensorAir",
	"gdc_plutoQRFTimeout",
	"gdc_plutoRangeQRFMan",
	"gdc_plutoRangeQRFLand",
	"gdc_plutoRangeQRFAir",
	"gdc_plutoQRFDelay",
	"gdc_plutoArtyTimeout",
	"gdc_plutoArtyDelay",
	"gdc_plutoArtyRounds",
	"gdc_plutoArtyError",
	"gdc_plutoTargetList",
	"gdc_plutoGroupList",
	"gdc_plutoRun"
];

// Lancement de Pluto
[_sides] spawn {
	params ["_sides"];
	waitUntil {time > 5};
	if (gdc_plutoDebug) then {systemChat "Pluton se réveille";};
	private _boucle = 0;
	while {gdc_plutoRun} do {
		_boucle = _boucle + 1;
		if (gdc_plutoDebug) then {
			systemChat ("Start of loop " + (str _boucle));
		};
		{
			private _return = [_x] call gdc_fnc_plutoAnalize;
			_return call gdc_fnc_plutoAction;
		} forEach _sides;
		sleep 10;
	};
};
