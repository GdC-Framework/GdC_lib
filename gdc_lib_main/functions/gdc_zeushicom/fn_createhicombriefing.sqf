/*
	Author: Sparfell

	Description:
	Subfunction of zeushicom. Generates HICOM briefing.

	Parameter(s):
		STRING : classname of the item the player must have in order to get the reports (default="itemmap")
		BOOL : is BFT activated ?
		BOOL : is OFT activated ?

	Returns:
	nothing
*/
params ["_itemcondition","_activateBFT","_activateOFT"];

if (isDedicated) exitwith {};

if (player diarySubjectExists "gdc_hicom") exitwith {};

player createDiarySubject ["gdc_hicom","HICOM"];

private _txt = format ["<font size='20'>High Command :</font>
<br/><br/>Les joueurs qui possèdent un(e) <font color='#FF0000'>%1</font> peuvent accéder au high command via le menu d'interaction sur soi de ACE.
<br/><br/>Une fois le High Command obtenu, ouvrez l'interface Zeus avec la touche dédiée pour donner des ordres à vos unités.
<br/><br/><font size='20'>Conseils :</font>
<br/>- Pour changer l'attitude d'un groupe (vitesse, comportement), double-cliquez sur le waypoint de ce groupe.
<br/>- Pour faire sortir un groupe d'un véhicule, créez un waypoint pour ce groupe, double-cliquez dessus et sélectionnez le type de waypoint ""Sortir"".
<br/>- Vous pouvez placer certains modules ACE afin de demander des tirs de suppression, générer des patrouilles aléatoires, placer des groupes dans des batiments, etc.",
(gettext (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))];
player createDiaryRecord ["gdc_hicom", ["Accès HICOM",_txt,"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestLeadership_ca.paa"]];

if (_activateBFT) then {
	private _txt = format ["<font size='20'>High Command Blufor Tracker :</font>
	<br/><br/>Les joueurs qui possèdent un(e) <font color='#FF0000'>%1</font> voient les groupes contrôlés par le High Command sur la carte.",
	(gettext (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))];
	player createDiaryRecord ["gdc_hicom", ["Blufor Tracker",_txt,"a3\ui_f\data\Map\Markers\NATO\b_inf.paa"]];
};

if (_activateOFT) then {
	private _txt = format ["<font size='20'>High Command Opfor Tracker :</font>
	<br/><br/>Les joueurs qui possèdent un(e) <font color='#FF0000'>%1</font> voient et lisent les contact ennemis repérés par les unités contrôlées par le High Command.
	<br/><br/><font size='15'>Légende :</font>",(gettext (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))];
	{
		_txt = _txt + format ["<br/><img image='%1' width='32' height='32'/> %2",(gettext (configfile >> "CfgMarkers" >> _x >> "icon")),(gettext (configfile >> "CfgMarkers" >> _x >> "name"))];
	} forEach ["o_inf","o_motor_inf","o_armor","o_mech_inf","o_art","o_mortar","o_support","o_antiair","o_air","o_plane","o_naval"];
	player createDiaryRecord ["gdc_hicom", ["Opfor Tracker",_txt,"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa"]];
	player createDiaryRecord ["gdc_hicom", ["Infos contacts","Ici sont enregistrées les communications radios reçues au cours de la mission.","a3\ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa"]];
};