/*
	Author: Sparfell

	Description:
	Main function for gdc_extra, a script for AI piloted extractions
	Creates the helicopter and makes it move to appropriate locations

	Parameter(s):
		NONE

	Returns:
	nothing
*/

private ["_text","_veh","_group","_wp","_effect","_dir"];

if ((([] call acre_api_fnc_getCurrentRadioChannelNumber) == gdc_extra_chan) AND (([([] call acre_api_fnc_getCurrentRadio)] call acre_api_fnc_getBaseRadio) == gdc_extra_radio)) then {
	gdc_extra_dispo = false;
	publicVariable "gdc_extra_dispo";
	hint "Ouvrez votre map et cliquez à l'endroit désiré pour désigner la LZ";
	onMapSingleClick {
		onMapSingleClick "";
		hint "L'extraction est en route";
		// deplacement du marker et de creation de l'hélipad
		"gdc_extra_mk" setMarkerPosLocal _pos;
		"gdc_extra_mk" setMarkerAlphaLocal 1;
		_veh = "Land_HelipadEmpty_F" createVehicle _pos;
		if (isNull gdc_extra_helo) then {
		// création de l'hélico si il n'existe pas
			// déterminer la position de spawn
			switch true do {
				case (gdc_extra_spawnpos in [[0,0,0]]): {
					// position de spawn aléatoire
					gdc_extra_spawnposR = _pos getPos [3000,(random 360)];
				};
				case ((typeName gdc_extra_spawnpos) == "STRING"): {
					// position de spawn en fonction d'un marqueur
					gdc_extra_spawnposR = _pos getPos [3000,((markerPos gdc_extra_spawnpos) getdir _pos)];
				};
				default {gdc_extra_spawnposR = gdc_extra_spawnpos;};
			};
			publicVariable "gdc_extra_spawnposR";
			// spawn de l'hélico
			_veh = [gdc_extra_spawnposR,(gdc_extra_spawnposR getdir _pos),gdc_extra_type,gdc_extra_side] call BIS_fnc_spawnVehicle;
			gdc_extra_helo =  _veh select 0;
			publicVariable "gdc_extra_helo";
			_group = _veh select 2;
			gdc_extra_helo disableAI "AUTOTARGET";
			gdc_extra_helo disableAI "AUTOCOMBAT";
			gdc_extra_helo disableAI "SUPPRESSION";
			// ajout du WP sur la lz désignée
			_wp = _group addWaypoint [_pos, 0];
			_wp setWaypointType "TR UNLOAD";
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointCombatMode "BLUE";
			_wp setWaypointStatements ["true", "gdc_extra_helo land 'GET IN'"];
			// ajout de l'action "Partir" pour tous les clients
			_effect = {};
			if (gdc_extra_end) then {
				_effect = {
					gdc_extra_left = true;
					publicVariable "gdc_extra_left";
					[(_this select 0),(_this select 2)] remoteExec ["removeaction", 0];
					_wp = (group (_this select 0)) addWaypoint [gdc_extra_spawnposR, 0];
					_wp setWaypointType "MOVE";
					sleep 30;
					["end1",true,4] remoteExec ["BIS_fnc_endMission", 0];
				};
			} else {
				_effect = {
					gdc_extra_left = true;
					publicVariable "gdc_extra_left";
					[(_this select 0),(_this select 2)] remoteExec ["removeaction", 0];
					_wp = (group (_this select 0)) addWaypoint [gdc_extra_spawnposR, 0];
					_veh = "Land_HelipadEmpty_F" createVehicle gdc_extra_spawnposR;
					_wp setWaypointType "MOVE";
					_wp setWaypointStatements ["true", "gdc_extra_helo land 'LAND'"];
				};
			};
			[gdc_extra_helo,["<t color='#ff0000'>Partir</t>",_effect,0,1.5,false,true,"","(vehicle _this) == _target"]] remoteExec ["addaction", 0];
		} else {
		// retour de l'hélico si il est déjà spawn
			_group = creategroup gdc_extra_side;
			{
				[_x] joinSilent _group;
			} forEach (units group gdc_extra_helo);
			_wp = _group addWaypoint [_pos, 0];
			_wp setWaypointType "TR UNLOAD";
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointCombatMode "BLUE";
			_wp setWaypointStatements ["true", "gdc_extra_helo land 'GET IN'"];
		};
	};
} else {
	// si c'est le mauvais canal, afficher un texte.
	_text = getText (configFile >> "CfgWeapons" >> gdc_extra_radio >> "displayName");
	_text = "Selectionner votre " + _text + " et réglez-la sur le canal " + (str gdc_extra_chan) + " pour pouvoir contacter l'hélicoptère.";
	hint _text;
};
