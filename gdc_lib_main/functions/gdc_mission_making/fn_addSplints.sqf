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
	if (! isNil "GDC_disableAddSplints") exitwith {}; //Possibilité pour les MM de désactiver la fonction

	_allitems = uniformItems _unit + vestItems _unit + backpackItems _unit;
	if ("ACE_personalAidKit" in _allitems) then { //A une trousse de soin
		_unit removeItem "ACE_personalAidKit";
		for "_i" from 1 to 12 do {
			_unit additem "ACE_splint";
		};
	};
};
