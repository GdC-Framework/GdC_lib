/*
	Author: Sparfell

	Description:
	Creates Waypoints for the QRF

	Parameter(s):
		0 : GROUP - QRF group
		1 : OBJECT - the target

	Returns:
	nothing
*/

params ["_group","_target"];
private ["_wp","_radius","_delay"];

_veh = vehicle (leader _group);
_pos = (getpos _target);

// En fonction du type d'unité : différents rayons de patrouille et différentes distance pour activer le WP d'apporche
_radius = switch true do {
	case (_veh isKindOf "Man"): {[200,500]};
	case (_veh isKindOf "LandVehicle"): {[250,1000]};
	case (_veh isKindOf "Air"): {[500,2000]};
	default {[200,500]};
};

// delai avant le lancement de la QRF
_delay = _group getVariable ["PLUTO_QRFDELAY",gdc_plutoQRFDelay]; // Eventuel délai custom
sleep (random _delay);

// Suppression des WP du groupe
while {(count (waypoints _group)) > 0} do
{
	deleteWaypoint ((waypoints _group) select 0);
};

// Mise en alerte
_group setBehaviour "AWARE";
_group setSpeedMode "NORMAL";

// WP d'approche si la cible est trop loin
if ((_veh distance2D _target) > (_radius select 1)) then {
	_wp = _group addWaypoint [_pos,0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius (_radius select 0);
};

// Ajout de 2 à 5 WP dans un rayon autour de la cible
for "_i" from 1 to (2 + (floor random 4)) do {
	_wp = _group addWaypoint [_pos,0];
	_wp setWaypointType "SAD";
	_wp setWaypointCompletionRadius 10;
	_wp setWaypointTimeout [0,15,30];
	_wp setWaypointPosition [_pos,(_radius select 0)];
};
// WP de boucle
_wp = _group addWaypoint [_pos, 0];
_wp setWaypointType "CYCLE";
_wp setWaypointPosition [_pos,(_radius select 0)];