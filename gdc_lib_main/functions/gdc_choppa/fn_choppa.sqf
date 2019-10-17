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

params ["_radio","_chan","_side","_type","_spawnpos",["_dir",0, [0]],["_damage",false, [true]]];
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

// Onglet briefing
player createDiarySubject ["gdc_choppa","GDC Choppa"];
player createDiaryRecord ["gdc_choppa", ["Instructions","<font size='20'><font color='#FF0000'>Transport héliporté</font></font>
<br/><br/>Les joueurs peuvent utiliser un hélicoptère de transport piloté par l'IA qui est disponible pendant toute la mission et qui peut être commandé à distance.
<br/><br/>Réglez votre <font color='#EF7619'>" + (getText (configFile >> "CfgWeapons" >> gdc_choppa_radio >> "displayName")) + "</font> sur le <font color='#EF7619'>canal " + (str gdc_choppa_chan) + "</font> pour pouvoir contacter l'hélicoptère.
<br/>Les joueurs à bord de l'hélicoptère peuvent communiquer avec celui-ci sans avoir besoin d'une " + (getText (configFile >> "CfgWeapons" >> gdc_choppa_radio >> "displayName")) + ".
<br/>Utilisez votre menu ACE d'interaction sur vous-même et selectionnez l'action ""Contacter l'hélicoptère"" pour désigner une nouvelle LZ pour l'hélicoptère à l'aide d'un simple clic gauche sur la carte.
<br/>Il est ensuite possible donner une nouvelle LZ à tout moment, même lorsque l'hélicoptère est en vol.
<br/><br/>Type de l'hélicoptère : <font color='#EF7619'>" + (getText (configFile >> "CfgVehicles" >> _type >> "displayName")) + "</font>"]];

if (isServer) then {
	// création de l'hélico
	gdc_choppa_helo = createVehicle [_type,_spawnpos,[],0,"NONE"];
	publicVariable "gdc_choppa_helo";
	gdc_choppa_helo setdir _dir;
	gdc_choppa_helo setpos _spawnpos;
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
	// Allumage des lampes intérieures si disponibles (véhicules RHS)
	if ("cargolights_hide" in (animationNames gdc_choppa_helo)) then {
		gdc_choppa_helo animateSource ["cargolights_hide",0];
		(gdc_choppa_helo turretUnit [0]) action ["searchlightOn",gdc_choppa_helo];
	};
	// Ouverture des portes
	[gdc_choppa_helo,1] call GDC_fnc_animVehicleDoor;
	// création de l'hélipad
	gdc_choppa_pad = "Land_HelipadEmpty_F" createVehicle _spawnpos;
	publicvariable "gdc_choppa_pad";
	// création du marker
	createMarker ["gdc_choppa_mk",_spawnpos];
	"gdc_choppa_mk" setMarkerType "mil_Pickup";
	"gdc_choppa_mk" setMarkerColor "ColorIndependent";
	"gdc_choppa_mk" setMarkerAlpha 0;
};
