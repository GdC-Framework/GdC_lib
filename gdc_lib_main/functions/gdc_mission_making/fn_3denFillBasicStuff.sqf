/**
 */
params["_objects", ["_radio", true, [true]]];
private["_old_loadout", "_new_loadout", "_uniform", "_old_items", "_items"];

_objects = _objects select {_x isKindOf "man"};

if (_radio) then {
	_items = [
		["ACE_CableTie",1],
		["ACE_EarPlugs",1],
		["ACE_EntrenchingTool",1],
		["ACE_fieldDressing",5],
		["ACRE_PRC343",1],
		["ACE_tourniquet",1],
		["SmokeShell",2]
	];
} else {
	_items = [
		["ACE_CableTie",1],
		["ACE_EarPlugs",1],
		["ACE_EntrenchingTool",1],
		["ACE_fieldDressing",5],
		["ACE_tourniquet",1],
		["SmokeShell",2]
	];
};


_objects apply {
	_old_loadout = getUnitLoadout _x;
	_new_loadout = _old_loadout;
	_new_loadout#3 set [1, _new_loadout#3#1 + _items];
	_new_loadout#9 set [2, ""];

	_uniform = (_old_loadout) #3;
	if (count _uniform > 0) then {
		_items = _backpack #1;
		_backpack = _backpack #0;
		_x setUnitLoadout _new_loadout;
		if ((loadUniform _x) > 1) then { // Annulation si pas assez de place
			_x setUnitLoadout _old_loadout;
			systemchat (format ["Unité %1 : pas assez de place dans l'uniforme.",str (str _x)]);
		} else {
			systemchat (format ["Unité %1 : loadout modifié.",str (str _x)]);
		};
		save3DENInventory [_x];
	} else {
		systemchat (format ["Unité %1 : pas d'uniforme trouvé.",str (str _x)]);
	};
};
