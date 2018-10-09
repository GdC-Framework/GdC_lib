/*
	Author: Sparfell

	Description:
	Will animate the doors of some vehicles

	Parameter(s):
		0 : OBJECT - vehicle
		1 : BOOLEAN - 1=open 0=close

	Returns:
	nothing
*/
params ["_veh","_state_p"];
private ["_vehBaseClass","_state"];

// Déterminer la classe de base du véhicule :
_vehBaseClass = [
	"RHS_Mi8_base","RHS_CH_47F_base","rhsusf_CH53E_USMC","RHS_C130J_Base","RHS_AN2_Base",
	"CUP_AN2_Base","CUP_C130J_Base","CUP_DC3_Base","LIB_C47_Skytrain","LIB_Ju52",
	"CUP_B_MV22_USMC","CUP_CH53E_Base","CUP_Merlin_HC3_Base","CUP_SA330_Base","CUP_AW159_Unarmed_Base","CUP_Uh60_FFV_Base","CUP_MH60S_FFV_Base","CUP_Uh60_Base","CUP_MH60S_Base","CUP_Ka60_Base",
	"VTOL_01_base_F","VTOL_02_base_F","Heli_Transport_03_base_F","Heli_Transport_02_base_F","Heli_Transport_04_base_F","Heli_Light_02_base_F","Heli_Transport_01_base_F"
];
//_vehBaseClass = _vehBaseClass arrayIntersect ([(configFile >> "CfgVehicles" >> (typeOf _veh)),true] call BIS_fnc_returnParents);
_vehBaseClass = ([(configFile >> "CfgVehicles" >> (typeOf _veh)),true] call BIS_fnc_returnParents) arrayIntersect _vehBaseClass;
if ((count _vehBaseClass) > 0) then {
	_vehBaseClass = _vehBaseClass select 0;
} else {
	_vehBaseClass = "";
};

//Ouvert ou fermé
_state = if (_state_p == 0) then {0} else {1};
// fonction pour animation de la porte
switch (_vehBaseClass) do {
	case "RHS_CH_47F_base": {
		_state = if (_state_p == 0) then {0} else {0.75};
		_veh animateSource ["ramp_anim",_state];
	};
	case "rhsusf_CH53E_USMC";
	case "CUP_CH53E_Base";
	case "RHS_C130J_Base": {
		_state = if (_state_p == 0) then {0} else {0.75};
		_veh animateSource ["ramp",_state];
	};
	case "RHS_AN2_Base";
	case "CUP_AN2_Base": {
		_veh animateSource ["door",_state];
	};
	case "CUP_C130J_Base": {
		_state = if (_state_p == 0) then {[0,0]} else {[0.85,0.65]};
		_veh animateSource ["Ramp_Top",(_state select 0)];
		_veh animateSource ["Ramp_Bottom",(_state select 1)];
	};
	case "CUP_DC3_Base": {
		_veh animateSource ["door_1",_state];
	};
	case "CUP_B_MV22_USMC": {
		_veh animateDoor ["Ramp_Top",_state];
		_veh animateDoor ["Ramp_Bottom",_state];
	};
	case "CUP_Merlin_HC3_Base":{
		_veh animateDoor ["dvere_l",_state];
		_veh animateDoor ["dvere_p",_state];
	};
	case "CUP_SA330_Base":{
		_veh animateDoor ["ofrp_puma_porte_gauche",_state];
		_veh animateDoor ["ofrp_puma_porte_droite",_state];
	};
	case "CUP_AW159_Unarmed_Base":{
		_veh animateDoor ["CargoDoorL",_state];
		_veh animateDoor ["CargoDoorR",_state];
	};
	case "LIB_C47_Skytrain";
	case "LIB_Ju52": {
		_veh animateSource ["Hide_Door",_state];
	};
	case "VTOL_02_base_F";
	case "VTOL_01_base_F": {
		_veh animateDoor ["Door_1_source",_state];
	};
	case "Heli_Transport_03_base_F":{ // Huron
		_veh animateDoor ["Door_rear_source",_state];
	};
	case "Heli_Transport_02_base_F":{ //Mohawk
		_veh animateDoor ["Door_Back_L",_state];
		_veh animateDoor ["Door_Back_R",_state];
	};
	case "Heli_Transport_04_base_F":{ // Taru
		_veh animateDoor ["Door_4_source",_state];
		_veh animateDoor ["Door_5_source",_state];
	};
	case "CUP_MH60S_Base";
	case "CUP_Uh60_Base";
	case "CUP_Ka60_Base";
	case "Heli_Light_02_base_F":{ //Orca
		_veh animateSource ["Doors",_state];
	};
	case "Heli_Transport_01_base_F":{ //Gosthawk
		_veh animateDoor ["Door_L",_state];
		_veh animateDoor ["Door_R",_state];
	};
	case "CUP_MH60S_FFV_Base";
	case "CUP_Uh60_FFV_Base";
	default {};
};
