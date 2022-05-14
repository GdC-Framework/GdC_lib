/*
	Fonction qui permet de créer le slot HC dans 3DEN
*/

// On vérifie avant le slot HC ne soit pas déjà dans la mission
if (({(_x get3DENAttribute 'Name') select 0 == 'HC_Slot' } count (all3DENEntities #3)) < 1) then {
	private _hc = create3DENEntity ['Logic', 'HeadlessClient_F', screenToWorld [0.5,0.5]];
	_hc set3DENAttribute ['ControlMP',true];
	_hc set3DENAttribute ['ControlSP',false];
	_hc set3DENAttribute ['Description','HC_Slot'];
	_hc set3DENAttribute ['Name','HC_Slot'];
};
