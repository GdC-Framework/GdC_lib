/*
 * Create Victory and defeat triggers
 *
 */
private ["_trigger"];

if (
		{
			(_x get3DENAttribute 'ActivationBy')#0 isEqualTo 'ALPHA'
		} count (all3DENEntities#2) < 1
		or {
			(_x get3DENAttribute 'ActivationBy')#0 isEqualTo 'BRAVO'
		} count (all3DENEntities#2) < 1
) then {
	_trigger = create3DENEntity [
		'Trigger', 'EmptyDetector', screenToWorld [.45, .5]
	];
	_trigger set3DENAttribute ['text',"Victoire"];
	_trigger set3DENAttribute ['ActivationBy',"ALPHA"];
	_trigger set3DENAttribute [
		'onActivation',"[""end1"", true] remoteExec [""BIS_fnc_endMission""];"
	];

	_trigger = create3DENEntity [
		'Trigger', 'EmptyDetector', screenToWorld [.55, .5]
	];
	_trigger set3DENAttribute ['text', "Défaite"];
	_trigger set3DENAttribute ['ActivationBy', "BRAVO"];
	_trigger set3DENAttribute [
		'onActivation',"[""end1"", false] remoteExec [""BIS_fnc_endMission""];"
	];
} else {
	systemChat "ERREUR : le trigger radio Alpha/Bravo existe déjà.";
};
