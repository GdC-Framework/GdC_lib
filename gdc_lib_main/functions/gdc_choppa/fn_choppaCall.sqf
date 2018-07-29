/*
	Author: Sparfell

	Description:
	Movement function for gdc_choppa, a script for AI piloted helicopter transport
	Makes the helicopter move to requested loaction

	Parameter(s):
		NONE

	Returns:
	nothing
*/

private ["_text","_veh","_group","_wp","_effect","_dir"];

if (([player, gdc_choppa_radio, gdc_choppa_chan] call GDC_fnc_hasRadioOnRightChannel) OR ((vehicle player) == gdc_choppa_helo)) then {
	hint "Ouvrez votre map et cliquez à l'endroit désiré pour désigner la LZ";
	onMapSingleClick {
		hint "";
		onMapSingleClick "";
		// déplacement du marker et de l'hélipad
		"gdc_choppa_mk" setMarkerPosLocal _pos;
		"gdc_choppa_mk" setMarkerAlphaLocal 1;
		gdc_choppa_pad setpos _pos;
		// suppression des Waypoints précédement ajoutés
		{
			deleteWaypoint _x;
		} forEach (waypoints (group gdc_choppa_helo));
		// interruption d'un éventuel atterissage en cours
		gdc_choppa_helo land "NONE";
		// création des points de passage de l'hélico
		_wp = (group gdc_choppa_helo) addWaypoint [_pos,0];
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "CARELESS";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointStatements ["true","gdc_choppa_helo land 'LAND';"];
	};
} else {
	// si c'est le mauvais canal, afficher un texte.
	_text = getText (configFile >> "CfgWeapons" >> gdc_choppa_radio >> "displayName");
	_text = "Réglez votre " + _text + " sur le canal " + (str gdc_choppa_chan) + " pour pouvoir contacter l'hélicoptère.";
	hint _text;
};
