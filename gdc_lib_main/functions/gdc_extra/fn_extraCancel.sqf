/*
	Author: Sparfell

	Description:
	Cancel function for gdc_extra, a script for AI piloted extractions
	The extraction request will be canceled and the helicopter will be removed

	Parameter(s):
		NONE

	Returns:
	nothing
*/

private ["_text","_group","_wp"];

if ((([] call acre_api_fnc_getCurrentRadioChannelNumber) == gdc_extra_chan) AND (([([] call acre_api_fnc_getCurrentRadio)] call acre_api_fnc_getBaseRadio) == gdc_extra_radio)) then {
	if ((isNull gdc_extra_helo) OR (!canMove gdc_extra_helo)) then {
	// annulation simple si l'hélico n'existe pas
		player onMapSingleClick "";
		hint "Extraction annulée";
		gdc_extra_dispo = true;
		publicVariable "gdc_extra_dispo";
	} else {
	// annulation avec retour et suppression de l'hélico si il existe
		hint "Extraction annulée";
		_group = group gdc_extra_helo;
		while {(count (waypoints _group)) > 0} do
		{
			deleteWaypoint ((waypoints _group) select 0);
		};
		_wp = _group addWaypoint [gdc_extra_spawnposR, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointCompletionRadius 100;
		_wp setWaypointStatements ["true", "{ deleteVehicle (vehicle _x); deleteVehicle _x; } forEach units group this;"];
		[gdc_extra_helo,0] call GDC_fnc_animVehicleDoor;
		gdc_extra_dispo = true;
		publicVariable "gdc_extra_dispo";
	};
} else {
	// si c'est le mauvais canal, afficher un texte.
	_text = getText (configFile >> "CfgWeapons" >> gdc_extra_radio >> "displayName");
	_text = "Selectionner votre " + _text + " et réglez-la sur le canal " + (str gdc_extra_chan) + " pour pouvoir contacter l'hélicoptère.";
	hint _text;
};