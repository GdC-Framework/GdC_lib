/*
 * add default medic equipement in the backpack of the selected units
 *
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 * 1 - BOOLEAN : heavy medical equipement
 *
 * Return : Nothing
*/

params ["_objects", ["_heavy_medical", false, [true]]];
private ["_backpack","_items", "_unit_loadout", "_medical_equipement"];

_objects = _objects select {_x isKindOf "man"};

if (_heavy_medical) then {
	_medical_equipement = [
		["ACE_surgicalKit",1],
		["ACE_splint",10],
		["ACE_salineIV",6],
		["ACE_salineIV_250",4],
		["ACE_salineIV_500",8],
		["ACE_tourniquet",6],
		["ACE_morphine",12],
		["ACE_epinephrine",10],
		["ACE_packingBandage",20],
		["ACE_fieldDressing",15],
		["ACE_elasticBandage",20],
		["ACE_quikclot",20]
	];
} else {
	_medical_equipement = [
		["ACE_surgicalKit",1],
		["ACE_splint",8],
		["ACE_salineIV",3],
		["ACE_salineIV_250",2],
		["ACE_salineIV_500",6],
		["ACE_tourniquet",4],
		["ACE_morphine",8],
		["ACE_epinephrine",6],
		["ACE_packingBandage",15],
		["ACE_fieldDressing",10],
		["ACE_elasticBandage",15],
		["ACE_quikclot",10]
	];
};

{
	_backpack = (getUnitLoadout _x) #5;
	if (count _backpack > 0) then {
		_items = _backpack #1;
		_backpack = _backpack #0;
		_x setUnitLoadout [
			nil,
			nil,
			nil,
			nil,
			nil,
			[_backpack, (_items + _medical_equipement)],
			nil,
			nil,
			nil,
			nil
		];
		if ((loadBackpack _x) > 1) then { // Annulation si pas assez de place
			_x setUnitLoadout [
				nil,
				nil,
				nil,
				nil,
				nil,
				[_backpack, _items],
				nil,
				nil,
				nil,
				nil
			];
			if (_heavy_medical) then {
				systemchat (format ["Unité %1 : pas assez de place dans le sac (11,25Kg minimum).",str (str _x)]);
			} else {
				systemchat (format ["Unité %1 : pas assez de place dans le sac (6,35Kg minimum).",str (str _x)]);
			};
		} else {
			systemchat (format ["Unité %1 : loadout modifié.",str (str _x)]);
		};
		save3DENInventory [_x];
	} else {
		systemchat (format ["Unité %1 : pas de sac trouvé.",str (str _x)]);
	};
} forEach _objects;
