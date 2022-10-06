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
private ["_txt"];

_txt = _target getVariable ["gdc_OFTTargetType","default"]; // Use custom type if defined
if (_txt == "default") then {
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
		case "o_support": {"Arme fixe"};
		default {"Contact non identifié"};
	};
};
_targetPos = mapGridPosition _targetPos;

_txt = format ["%1 adverse repéré(e), position %2",_txt,_targetPos];
_detector = vehicle _detector;
_detector SideChat _txt;
playsound "TacticalPing4";
_txt = format ["<font color='#2412D4'>%1</font> : %2",_detector,_txt];
player createDiaryRecord ["gdc_oft", ["Infos",_txt]];