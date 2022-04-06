/*
 * add default medic equipement in the backpack of the selected units
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : Nothing
*/

params ["_objects"];
private ["_backpack","_items", "_unit_loadout"];

_objects = _objects select {_x isKindOf "man"};

{
	_unit_loadout = getUnitLoadout _x;
	_backpack = (_unit_loadout) #5;
	if (count _backpack > 0) then {
		_items = _backpack #1;
		_backpack = _backpack #0;
		_x setUnitLoadout [
			((_unit_loadout) #0),
			((_unit_loadout) #1),
			((_unit_loadout) #2),
			((_unit_loadout) #3),
			((_unit_loadout) #4),
			[_backpack,(_items + [["ACE_surgicalKit",1],["ACE_splint",12],["ACE_salineIV",2],["ACE_salineIV_250",2],["ACE_salineIV_500",2],["ACE_tourniquet",4],["ACE_morphine",8],["ACE_epinephrine",4],["ACE_packingBandage",15],["ACE_fieldDressing",15],["ACE_elasticBandage",10],["ACE_quikclot",10]])],
			((_unit_loadout) #6),
			((_unit_loadout) #7),
			((_unit_loadout) #8),
			((_unit_loadout) #9)
		];
		if ((loadBackpack _x) > 1) then { // Annulation si pas assez de place
			_x setUnitLoadout [
				((_unit_loadout) #0),
				((_unit_loadout) #1),
				((_unit_loadout) #2),
				((_unit_loadout) #3),
				((_unit_loadout) #4),
				[_backpack,_items],
				((_unit_loadout) #6),
				((_unit_loadout) #7),
				((_unit_loadout) #8),
				((_unit_loadout) #9)
			];
			systemchat (format ["Unité %1 : pas assez de place dans le sac.",str (str _x)]);
		} else {
			systemchat (format ["Unité %1 : loadout modifié.",str (str _x)]);
		};
		save3DENInventory [_x];
	} else {
		systemchat (format ["Unité %1 : pas de sac trouvé.",str (str _x)]);
	};
} forEach _objects;