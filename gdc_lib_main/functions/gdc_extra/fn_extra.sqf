/*
	Author: Sparfell

	Description:
	Init function for gdc_extra, a script for AI piloted extractions
	Creates 2 ACE selfaction menu actions and required variables and markers

	Parameter(s):
		0 : STRING - ACRE radio classname (ACRE_PRC343,ACRE_PRC148,...)
		1 : NUMBER - radio channel number
		2 : SIDE - side of the extraction helicopter (blufor,opfor,independent,civilian)
		3 : STRING - classname of the helicopter
		4 (Optional):
			ARRAY - position for helicopter spawn (if = [0,0,0] the position is randomized) (default: [0,0,0])
			STRING - marker name (the marker should represent the main ennemy position, the helicopter will come from the opposite direction)
		5 (Optional): BOOL - the extraction will end the mission (default: true)
		6 (Optional): BOOL - the helicopter can be destroyed (default: true)

	Returns:
	nothing
*/

params ["_radio", "_chan", "_side", "_type", ["_spawnpos", [0, 0, 0], [[], ""], [3] ], ["_end", true, [true]], ["_damage", true, [true]]];
private ["_action"];

gdc_extra_dispo = true;
gdc_extra_left = false;
gdc_extra_helo = objNull;
gdc_extra_radio = _radio;
gdc_extra_chan = _chan;
gdc_extra_side = _side;
gdc_extra_type = _type;
gdc_extra_spawnpos = _spawnpos;
gdc_extra_spawnposR = gdc_extra_spawnpos;
gdc_extra_end = _end;
gdc_extra_damage = _damage;

// action d'appel
_action = [
	"gdc_extra_action1",
	"Appel extraction héliportée",
	"",
	{[] call GDC_fnc_extraCall},
	{(!gdc_extra_left) && (gdc_extra_dispo) && ([_player,gdc_extra_radio] call acre_api_fnc_hasKindOfRadio)}
] call ace_interact_menu_fnc_createAction;
[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

// action d'annulation
_action = [
	"gdc_extra_action2",
	"Annuler extraction héliportée",
	"",
	{[] call GDC_fnc_extraCancel},
	{(!gdc_extra_left) && (!gdc_extra_dispo) && ([_player,gdc_extra_radio] call acre_api_fnc_hasKindOfRadio)}
] call ace_interact_menu_fnc_createAction;
[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

// marker
createMarkerLocal ["gdc_extra_mk",[0,0,0]];
"gdc_extra_mk" setMarkerAlphaLocal 0;
"gdc_extra_mk" setMarkerTypeLocal "mil_Pickup";
"gdc_extra_mk" setMarkerColorLocal "ColorIndependent";

// Onglet briefing
player createDiarySubject ["gdc_extra","GDC Extra"];
player createDiaryRecord ["gdc_extra", ["Instructions","<font size='20'><font color='#FF0000'>Extraction héliportée</font></font>
<br/><br/>Les joueurs peuvent faire appel à une extraction héliportée à n'importe quel moment de la mission.
<br/><br/>Réglez votre <font color='#EF7619'>" + (getText (configFile >> "CfgWeapons" >> gdc_extra_radio >> "displayName")) + "</font> sur le <font color='#EF7619'>canal " + (str gdc_extra_chan) + "</font> pour pouvoir contacter l'hélicoptère.
<br/>Utilisez votre menu ACE d'interaction sur vous-même et selectionnez l'action ""Appel extraction héliportée"" pour désigner la LZ de l'hélicoptère à l'aide d'un simple clic gauche sur la carte.
<br/>Il est ensuite possible d'annuler l'extraction via le même menu.
<br/>Une fois que tout le monde est à bord, utilisez l'action molette ""Partir"" pour indiquer à l'hélicoptère qu'il peut décoller.
<br/><br/>Type de l'hélicoptère : <font color='#EF7619'>" + (getText (configFile >> "CfgVehicles" >> gdc_extra_type >> "displayName")) + "</font>"]];
