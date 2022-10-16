/*
	Author: Sparfell

	Description:
	init function for opfor Tracker.

	Parameter(s):
		ARRAY of OBJECTS : zeus modules of which units should report opfor contacts (default=[])
		STRING (optionnal) : classname of the item the player must have in order to get the reports (default="itemmap")
		ARRAY of OBJECTS (optionnal) : other units that should report contacts (default=[])
		NUMBER (optionnal) : delay between each scan (default=10)
		NUMBER (optionnal) : delay before marker reveal (default=10)
		NUMBER (optionnal) : delay before marker disapear (default=120)
		STRING (optionnal) : ennemy markers color (default="ColorOPFOR")

	Returns:
	nothing

	Example :
	[[my_zeus_hicom],"ACRE_PRC148"] call gdc_fnc_InitOpforTracker;

	Mission maker can define a custom Target Type displayed in the radio message by using the following line in the unit/vehicle init :
	this setVariable ["gdc_OFTTargetType","tralala",true];
*/

/*
	TODO :
	- utiliser https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#EnemyDetected
	- faire tourner le tout côté serveur ?
	- reporter les tirs subis ? les ennemis détruits ?
	- vérifier la compat JIP
*/

params [
	["_zeusModules",[],[[]]],
	["_accessItem","itemmap",[""]],
	["_otherUnits",[],[[]]],
	["_scanDelay",10,[999]],
	["_createMkDelay",10,[999]],
	["_fadeMkDelay",120,[999]],
	["_mkColor","ColorOPFOR",[""]]
];
private ["_boucle"];

gdc_OFTzeusModules = _zeusModules;
gdc_OFTaccessItem = _accessItem;
gdc_OFTotherUnits = _otherUnits;
gdc_OFTcreateMkDelay = _createMkDelay;
gdc_OFTfadeMkDuration = _fadeMkDelay;
gdc_OFTMkColor = _mkColor;

gdc_OFTtargetsList = [];
gdc_OFTmkList = [];

if (isnil "gdc_OFTDebug") then {
	gdc_OFTDebug = false;
};

if (isnil "gdc_OFTRun") then {
	gdc_OFTRun = true;
};

// Main while every x seconds : first get ennemy groups known by the friendlies and the display them on the map
[_scanDelay] spawn {
	params ["_scanDelay"];
	waitUntil {time > 5};
	if (gdc_OFTDebug) then {systemChat "Scan is starting";};
	_boucle = 0;
	while {gdc_OFTRun} do {
		_boucle = _boucle + 1;
		if (gdc_OFTDebug) then {
			systemChat ("Start of loop " + (str _boucle));
		};
		
		if ({_x isKindOf [gdc_OFTaccessItem,(configFile >> "CfgWeapons")] || {_x isKindOf gdc_OFTaccessItem}} count (items player) > 0) then {
			[] call gdc_fnc_OFTGetKnownEnnemyGroups;
			[] call gdc_fnc_OFTDrawEnnemyGroups;
		};
		sleep _scanDelay;
	};
};

//Briefing stuff
if !(player diarySubjectExists "gdc_hicom") then {
	player createDiarySubject ["gdc_hicom","HICOM"];
};
private _txt = format ["<font size='20'>High Command Opfor Tracker :</font>
<br/><br/>Les joueurs qui possèdent un <font color='#FF0000'>%1</font> voient et lisent les contact ennemis repérés par les unités contrôlées par le High Command.
<br/><br/><font size='15'>Légende :</font>",(gettext (configfile >> "CfgWeapons" >> _accessItem >> "displayname"))];
{
	_txt = _txt + format ["<br/><img image='%1' width='32' height='32'/> %2",(gettext (configfile >> "CfgMarkers" >> _x >> "icon")),(gettext (configfile >> "CfgMarkers" >> _x >> "name"))];
} forEach ["o_inf","o_motor_inf","o_armor","o_mech_inf","o_art","o_mortar","o_support","o_antiair","o_air","o_plane","o_naval"];
player createDiaryRecord ["gdc_hicom", ["Opfor Tracker",_txt,"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"]];
player createDiaryRecord ["gdc_hicom", ["Infos contacts","Ici sont enregistrées les communications radios reçues au cours de la mission.","a3\ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]];


/*
"a3\ui_f\data\IGUI\Cfg\simpletasks\Types\talk_ca.paa"
"a3\ui_f\data\IGUI\Cfg\simpletasks\Types\use_ca.paa"
"a3\ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"
"a3\ui_f\data\IGUI\Cfg\simpletasks\Types\radio_ca.paa"


*/