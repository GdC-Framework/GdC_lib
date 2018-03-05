/*
	Author: Sparfell

	Description:
	Init function for gdc_halo, a script for HALO/HAHO/LALO insertion

	Parameter(s):
		0 : OBJECT - name of the object players need to interact with in order to trigger an HALO insertion (typically a pole, a sign or a unit)
		1 (Optional):
			STRING - marker name, only players inside the marker area will be affected by the script (if "", the area will be located around the OBJECT defined in 0)(default: "")
			OBJECT - trigger name, only players inside the trigger area will be affected by the script
		2 (Optional): BOOL - players will have a GPS during the fall (no GPS in LALO mode)(default: true)
		3 (Optional): BOOL - players will be automatically ejected from the plane once above the DZ (if false the plane will fly over the DZ until no more players in passenger seats)(default: true)
		4 (Optional): BOOL - LALO jump, when the players jump out of the plane their parachute is automatically deployed and is unguided (default: false)
		5 (Optional): STRING - plane classname (default: "RHS_C130J")
		6 (Optional): NUMBER - plane flying altitude (if -1, ceiling altitude is selected)(default: -1)
		7 (Optional): ARRAY of STRINGs and/or OBJECTs - list of marker names or trigger names defining blacklisted areas (default: [])
		8 (Optional): ARRAY - DZ position (if [0,0,0], the players can choose the DZ)(default: [0,0,0])
		9 (Optional): ARRAY - plane spawn position (if [0,0,0], the position is randomized)(default: [0,0,0])

	Returns:
	nothing
*/

params ["_object",["_area",""],["_gps",true],["_autojump",true],["_lalo",false],["_vtype","RHS_C130J"],["_alt",-1],["_blist",[]],["_dzpos",[0,0,0]],["_spawnpos",[0,0,0]]];
private ["_action","_veh","_txt"];

gdc_halo_dispo = true;
gdc_halo_area = _area;
gdc_halo_gps = _gps;
gdc_halo_autojump = _autojump;
gdc_halo_lalo = _lalo;
gdc_halo_vtype = _vtype;
gdc_halo_alt = _alt;
gdc_halo_blist = _blist;
gdc_halo_dzpos = _dzpos;
gdc_halo_spawnpos = _spawnpos;
if (_area == "") then {
	gdc_halo_area = createMarkerLocal ["mkz_gdc_halo",_object];
	gdc_halo_area setMarkerShapeLocal "ELLIPSE";
	gdc_halo_area setMarkerSizeLocal [4,4];
	gdc_halo_area setMarkerAlphaLocal 0;
	_veh = "VR_Area_01_circle_4_yellow_F" createVehicle (getPos _object);
	_veh setpos (getPos _object);
};
if (_alt == -1) then {
	if (gdc_halo_lalo) then {
		gdc_halo_alt = 300;
	} else {
		gdc_halo_alt = switch (_vtype) do {
			case "B_T_VTOL_01_infantry_F": {6000};
			case "RHS_C130J": {8000};
			case "CUP_B_C130J_GB": {8000};
			case "CUP_B_C130J_USMC": {8000};
			case "CUP_O_C130J_TKA": {8000};
			case "CUP_I_C130J_AAF": {8000};
			case "CUP_I_C130J_RACS": {8000};
			case "CUP_B_C47_USA": {6000};
			case "CUP_O_C47_SLA": {6000};
			case "CUP_C_C47_CIV": {6000};
			case "CUP_C_DC3_CIV": {6000};
			case "CUP_C_DC3_TanoAir_CIV": {6000};
			case "CUP_B_MV22_USMC": {6000};
			case "RHS_AN2_B": {3000};
			case "RHS_AN2": {3000};
			case "CUP_O_AN2_TK": {4500};
			case "CUP_C_AN2_CIV": {4500};
			case "CUP_C_AN2_AEROSCHROT_TK_CIV": {4500};
			case "CUP_C_AN2_AIRTAK_TK_CIV": {4500};
			case "LIB_C47_Skytrain": {6000};
			case "LIB_C47_RAF_bob": {6000};
			case "LIB_C47_RAF_snafu": {6000};
			case "LIB_C47_RAF": {6000};
			case "LIB_Li2": {6000};
			default {6000};
		};
	};
};
if (gdc_halo_dzpos in [[0,0,0]]) then {
	if (gdc_halo_lalo) then {
	_txt = "Saut LALO (avec choix)";
	} else {
	_txt = "Saut HALO (avec choix)";
	};
} else {
	if (gdc_halo_lalo) then {
	_txt = "Saut LALO (sans choix)";
	} else {
	_txt = "Saut HALO (sans choix)";
	};
};

// action sur l'objet
_action = [
	"gdc_halo_action",
	_txt,
	"",
	{[] call GDC_fnc_haloPos},
	{gdc_halo_dispo}
] call ace_interact_menu_fnc_createAction;
[
	_object,
	0,
	["ACE_MainActions"],
	_action
] call ace_interact_menu_fnc_addActionToObject;

// Onglet briefing
player createDiarySubject ["gdc_halo",(if (gdc_halo_lalo) then {"Saut LALO"} else {"Saut HALO"})];
player createDiaryRecord ["gdc_halo", ["Instructions",((if (gdc_halo_lalo) then {"<font size='20'><font color='#FF0000'>Saut LALO</font></font>"} else {"<font size='20'><font color='#FF0000'>Saut HALO</font></font>"}) + 
"<br/><br/>Seuls les joueurs présents dans la zone sont affectés par le saut et seront donc déplacés dans l'avion au moyen d'une ellipse temporelle.
<br/><br/>" + (if (gdc_halo_autojump) then {"Lorsque l'avion passe au dessus de la DZ (Drop Zone), les joueurs sont automatiquement éjectés hors de l'avion. "} else {"Les joueurs doivent s'éjecter manuellement de l'avion (2xV ou action molette), l'avion passe continuellement au dessus de la DZ (Drop Zone) tant qu'il reste des joueurs dans l'avion."}) + 
(if (gdc_halo_lalo) then {"<br/>Lors de l'éjection, l'ouverture du parachute est immédiate et automatique. Le parachute est non manoeuvrable."} else {"<br/>Lors de l'éjection, le joueur est en chute libre et doit ouvrir manuellement son parachute au moment voulu. Le parachute est manoeuvrable."}) + 
"<br/><br/>Type de l'avion : " + (getText (configFile >> "CfgVehicles" >> gdc_halo_vtype >> "displayName")) + 
"<br/>Altitude de vol : " + (str gdc_halo_alt) + " mètres." + 
(if (gdc_halo_gps) then {"<br/><br/>Les joueurs disposent d'un GPS pendant toute la durée du saut."} else {""}) + 
(if (gdc_halo_spawnpos in [[0,0,0]]) then {"<br/><br/>Afin de définir l'axe d'approche de l'avion sur la DZ, il est possible (mais pas indispensable) de choisir la position de départ de l'avion en créant un marqueur nommé ""AVION"" sur la map dans le canal global."} else {""})
)]];