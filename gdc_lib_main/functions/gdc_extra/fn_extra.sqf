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

params ["_radio","_chan","_side","_type",["_spawnpos",[0,0,0]],["_end",true],["_damage",true]];
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
