/*
	Fonction qui permet de modifier les attributs 3DEN de la mission pour qu'ils correspondent aux standards CanardProof.
*/

set3DENMissionAttributes [
	["Multiplayer","respawn",1],
	["Multiplayer","RespawnTemplates",["EndMission","Spectator"]],
	["Scenario","EnableDebugConsole",1],
	["Scenario","GDC_Inventory",true],
	["Scenario","GDC_Roster",true],
	["Scenario","GDC_DeleteSeagull",true],
	["Scenario","GDC_AcreSpectator",true]
];