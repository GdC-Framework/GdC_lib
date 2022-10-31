/*
	Author: Sparfell

	Description:
	Subfunction of zeushicom. Will assign or assign the player to the chosen zeus curator module.

	Parameter(s):
		OBJECT : player object
		OBJECT : zeus module

	Returns:
	nothing
*/

params ["_player","_zeusmodule"];

// if zeus module was deleteted by a fucked up bug, create it again !
if (isNull _zeusmodule) exitwith {
	{
		deleteVehicle _x;
	} forEach gdc_zeushicommodules;
	gdc_zeushicommodules = [];
	publicVariable "gdc_zeushicommodules";
	{
		[_x,_foreachindex,gdc_zeushicomlimit] remoteExec ["gdc_fnc_createhicommodule",2];
	} forEach gdc_zeushicomlogics;
	hint parseText "<t color='#ff0000'>! ERREUR !</t><br/> Les modules ZEUS ont du être regénérés.<br/>Fermez le menu ACE et réessayez.";
};

_currentcurator = (getAssignedCuratorUnit _zeusmodule);
if (_currentcurator == _player) then { // cas d'un HICOM occupé par le joueur
	[_zeusmodule] remoteExec ["unassignCurator",2];
	hint parseText "Vous avez quitté ce High Command.<br/><img size='4' color='#eb6e0e' image='a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_passLeadership_ca.paa'/>";
} else { // cas d'un HICOM occupé par un autre joueur ou libre
	if !(isnull _currentcurator) then {
		[(parseText "Vous avez été expulsé de ce High Command par un autre joueur.<br/><img size='4' color='#ff0000' image='a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_passLeadership_ca.paa'/>")] remoteExec ["hint",_currentcurator];
	};
	[getAssignedCuratorLogic _player] remoteExec ["unassignCurator",2];
	[_zeusmodule] remoteExec ["unassignCurator",2];
	[_player,_zeusmodule] remoteExec ["assignCurator",2];
	hint parseText "Vous avez obtenu ce High Command.<br/><img size='4' color='#2a6d27' image='a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestLeadership_ca.paa'/>";
};