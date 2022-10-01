/*
	Author: Sparfell

	Description:
	Subfunction of zeushicom. Will assign or assign the player to the chosen zeus curator module.

	Parameter(s):
		OBJECT : player object
		OBJECT : zeus curator module

	Returns:
	nothing
*/

params ["_player","_zeusmodule"];

if ((getAssignedCuratorUnit _zeusmodule) == _player) then { // cas d'un HICOM occupé par le joueur
	[_zeusmodule] remoteExec ["unassignCurator",2];
	hint "Vous avez quitté ce High Command";
} else { // cas d'un HICOM occupé par un autre joueur ou libre
	[getAssignedCuratorLogic _player] remoteExec ["unassignCurator",2];
	[_zeusmodule] remoteExec ["unassignCurator",2];
	[_player,_zeusmodule] remoteExec ["assignCurator",2];
	hint "Vous avez obtenu ce High Command";
};