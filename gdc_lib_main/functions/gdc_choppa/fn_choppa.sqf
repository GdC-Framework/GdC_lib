/*
	Author: Sparfell

	Description:
	Init function for gdc_choppa, a script for AI piloted helicopter transport
	Creates 1 ACE selfaction menu action, the chopper, an helipad and the required variables and markers

	Parameter(s):
		0 : STRING - ACRE radio classname (ACRE_PRC343,ACRE_PRC148,...)
		1 : NUMBER - radio channel number
		2 : SIDE - side of the extraction helicopter (blufor,opfor,independent,civilian)
		3 : STRING - classname of the helicopter
		4 : ARRAY - position (helicopter spawn position)
		5 (Optional): NUMBER - direction of helicopter at spawn position (default: 0)
		6 (Optional): BOOL - the helicopter can be destroyed (default: false)

	Returns:
	nothing
*/

params ["_radio","_chan","_side","_type","_spawnpos",["_dir",0],["_damage",false]];
private ["_action","_group"];

gdc_choppa_radio = _radio;
gdc_choppa_chan = _chan;

// action d'appel
_action = [
	"gdc_choppa_action",
	"Contacter l'hélicoptère",
	"",
	{[] call GDC_fnc_choppaCall},
	{([_player,gdc_choppa_radio] call acre_api_fnc_hasKindOfRadio) OR ((vehicle _player) == gdc_choppa_helo)}
] call ace_interact_menu_fnc_createAction;
[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

if (isServer) then {
	// création de l'hélico
	gdc_choppa_helo = createVehicle [_type,_spawnpos,[],0,"NONE"];
	publicVariable "gdc_choppa_helo";
	gdc_choppa_helo setpos _spawnpos;
	gdc_choppa_helo setdir _dir;
	createVehicleCrew gdc_choppa_helo;
	// désactivation des dommages
	if (_damage) then {
		gdc_choppa_helo allowdamage false;
		{_x allowdamage false;} forEach (crew gdc_choppa_helo);
	};
	// création du groupe et désactivation de l'IA
	_group = createGroup _side;
	[gdc_choppa_helo] joinSilent _group;
	gdc_choppa_helo disableAI "AUTOTARGET"; gdc_choppa_helo disableAI "AUTOCOMBAT"; gdc_choppa_helo disableAI "SUPPRESSION";
	{[_x] joinSilent _group; _x disableAI "AUTOTARGET"; _x disableAI "AUTOCOMBAT"; _x disableAI "SUPPRESSION";} foreach (crew gdc_choppa_helo);
	// création de l'hélipad
	gdc_choppa_pad = "Land_HelipadEmpty_F" createVehicle _spawnpos;
	publicvariable "gdc_choppa_pad";
	// création du marker
	createMarker ["gdc_choppa_mk",_spawnpos];
	"gdc_choppa_mk" setMarkerType "mil_Pickup";
	"gdc_choppa_mk" setMarkerColor "ColorIndependent";
	"gdc_choppa_mk" setMarkerAlpha 0;
};
