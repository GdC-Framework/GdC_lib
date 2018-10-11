/*
 * Create a group composition
 * 
 * Parameters
 * 0 - ARRAY of STRINGs and NUMBERs : possible classnames of units with indiviual weights for each class. Ex : ["classname1",0.8,"classname2",0.5,,"classname3",0.5,"classnameN",0.2]
 * 1 - NUMBER or ARRAY : number of units in the group. if ARRAY then [min,moy,max]
 * 2 (optionnal) - STRING : classname of the leader (default="") if "" the leader can be any classes defined in 0
 *
 * Return : ARRAY of STRINGs : the new group composition
*/
params ["_types","_count",["_leader",""]];
private ["_group","_unit"];

_group = [];

// Si le nombre est un array il faut convertir
if ((typeName _count) == "ARRAY") then {
	_count = round (random _count);
};

// Si un leader est défini, l'ajouter au début du groupe
if (_leader != "") then {
	_group = _group + [_leader];
	_count = _count - 1;
};

// Ajouter les unités dans le groupe
for "_i" from 1 to _count do {
	_unit = selectRandomWeighted _types;
	_group = _group + [_unit];
};

_group;