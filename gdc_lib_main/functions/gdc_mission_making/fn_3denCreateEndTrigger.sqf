/*
 * create a radio trigger that ends the mission
 * 
 * Parameters
 * NONE
 *
 * Return : Nothing
*/
private ["_trg"];

if (({(_x get3DENAttribute 'ActivationBy') select 0 == 'ALPHA' } count (all3DENEntities #2)) < 1) then {
	_trg = create3DENEntity ['Trigger','EmptyDetector',screenToWorld [0.5,0.5]];
	_trg set3DENAttribute ['text',"Couper la mission"];
	_trg set3DENAttribute ['ActivationBy',"ALPHA"];
	_trg set3DENAttribute ['onActivation',"[""end1"",true] remoteExec [""BIS_fnc_endMission""];"];
} else {
	systemChat "ERREUR : le trigger radio Alpha existe déjà dans la mission";
};