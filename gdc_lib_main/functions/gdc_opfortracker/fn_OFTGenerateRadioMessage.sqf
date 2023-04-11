/*
	Author: Sparfell

	Description: generate and display radio messages upon ennemy detection

	Parameter(s):
		- OBJECT - detector
		- OBJECT - target
		- STRING - targetType
		- ARRAY - position

	Returns:
	nothing

	Mission maker can define a custom Target Type displayed in the radio message by using the following line in the unit/vehicle init :
	this setVariable ["gdc_OFTTargetType","your custom target type",true];
*/

params ["_detector","_target","_targetType","_targetPos"];
private ["_txt","_targetLoc"];

_txt = gettext (configfile >> "CfgMarkers" >> _targetType >> "name");
_txt = switch _targetType do {
	case "o_inf": {"Infanterie"};
	case "o_motor_inf": {"Véhicule"};
	case "o_mech_inf": {"Véhicule blindé léger"};
	case "o_armor": {"véhicule blindé"};
	case "o_air": {"Hélicoptère"};
	case "o_plane": {"Avion"};
	case "o_naval": {"Bateau"};
	case "o_mortar": {"Mortier"};
	case "o_art": {"Artillerie"};
	case "o_antiair": {"Arme AA"};
	case "o_installation": {"Arme fixe"};
	default {_txt};
};
_txt = _target getVariable ["gdc_OFTTargetType",_txt]; // Use custom type if defined

_targetLoc = nearestLocations [_targetPos, ["Name","NameCity","NameCityCapital","NameLocal","NameVillage","Airport","Hill"],2000,_targetPos];
_targetPos = mapGridPosition _targetPos;
_targetPos = (_targetPos select [0,3]) + "-" + (_targetPos select [3,6]);
if ((count _targetLoc) > 0) then {
	_targetLoc = text (_targetLoc #0);
	_txt = format ["%1 adverse repéré(e), environs de %2 (%3)",_txt,_targetLoc,_targetPos];
} else {
	_txt = format ["%1 adverse repéré(e), position %2",_txt,_targetPos];
};

_detector = vehicle _detector;
_detector SideChat _txt;
playsound "TacticalPing4";
_txt = format ["<font color='#0061c1'>%1</font> : %2",_detector,_txt];
if (player diarySubjectExists "gdc_hicom") then {
	player createDiaryRecord ["gdc_hicom", ["Infos contacts",_txt]];
} else {
	player createDiaryRecord ["gdc_oft", ["Infos contacts",_txt]];
};