/*
 * Exporter les groupes sélectionnés dans 3DEN pour LUCY
 * 
 * Parameters
 * 0 - ARRAY of groups : groups selected in 3DEN for instance
 *
 * Return : STRING : the text to past in your script
*/
params ["_objects"];
private ["_txt","_txtFinal","_br","_group","_pos","_side","_units","_skill","_types","_wpList","_wpPosList"];

// Pour debug :
//_objects = (get3DENSelected "group");

_txt = "";
_txtFinal = "";
_br = toString [13,10];

{
	_group = _x;
	// Spawn du groupe
	_pos = getpos (leader _group);
	_side = side _group;
	_units = units _group;
	_skill = skill (leader _group);
	_types = [];
	{
		_types = _types + [typeOf _x];
	} forEach _units;
	_txt = format ["_group = [%1,%2,%3,%4] call GDC_fnc_lucySpawnGroupInf;",_pos,_side,_types,_skill];
	_txtFinal = _txtFinal + _br + _txt;

	//Cas d'une Patrouille avec waypoints
	_wpList = all3DENEntities #4;
	_wpList = _wpList select {(_x #0) == _group};
	if (count _wpList > 0) then {
		_wpPosList = [];
		{
			_pos = _x get3DENAttribute "position";
			_wpPosList = _wpPosList + _pos;
		} forEach _wpList;
		_txt = format ["[_group,%1,%2,%3,%4,%5,30,[0,0,0]] call GDC_fnc_lucyAddWaypointListMoveCycle;",_wpPosList,str(speedMode _group),str(behaviour (leader _group)),str(combatMode _group),str(formation _group)];
		_txtFinal = _txtFinal + _br + _txt;
	};
} forEach _objects;

copyToClipboard _txtFinal;
_txtFinal;


// _group = [[507.246,5416.52,0.00143909],WEST,["B_Soldier_SL_F","B_soldier_AR_F","B_HeavyGunner_F","B_soldier_AAR_F","B_soldier_M_F","B_Sharpshooter_F","B_soldier_LAT_F","B_medic_F"],0.5] call GDC_fnc_lucySpawnGroupInf;
// _group = [[517.479,5368.28,0.00143909],WEST,["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_soldier_LAT_F"],0.5] call GDC_fnc_lucySpawnGroupInf;
// [_group,[[514.991,5389.97,0],[567.066,5478.18,0],[731.037,5557.33,0],[533.863,5367.63,0]],"NORMAL","AWARE","YELLOW","WEDGE",30,[0,0,0]] call GDC_fnc_lucyAddWaypointListMoveCycle;
// _group = [[574.866,5397.84,0.00143909],WEST,["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_F","B_soldier_LAT2_F"],0.5] call GDC_fnc_lucySpawnGroupInf;
