/*
 * add Splints and remove PAK on mission start if needed.
 * 
 * Parameters
 * None
 *
 * Return : Nothing
*/

_this spawn {
	params ["_unit"];
	private ["_allitems"];
	waituntil {time > 4}; // Attente des scripts tardifs
	if ((! isNil "GDC_disableAddSplints") OR (time > 10)) exitwith {}; //Possibilité pour les MM de désactiver la fonction et pas d'exécution si la mission est lancée depuis 10 secondes

	_allitems = uniformItems _unit + vestItems _unit + backpackItems _unit;
	if !("ACE_splint" in _allitems) then { //Pas d'attelles
		_unit additem "ACE_splint";
	};
	if ("ACE_personalAidKit" in _allitems) then { //A une trousse de soin
		_unit removeItem "ACE_personalAidKit";
		for "_i" from 1 to 5 do {
			_unit additem "ACE_splint";
		};
	};
};
