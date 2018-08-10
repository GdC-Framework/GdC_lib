/*
	Author: TECAK, Mystery, Sparfell

	Description:
	Adds an "inventory" tab in the diary displaying player's inventory
	
	Parameter(s):
		NONE

	Returns:
	nothing
*/

// Ajoute l'extension .paa si elle n'est pas présente
_addExtPAA =
{
	private["_path", "_array", "_len", "_last4"];
	_path = toLower _this;
	_array = toArray (_path);
	_len = count _array;
	_last4 = toString [_array select _len-4, _array select _len-3, _array select _len-2, _array select _len-1];
	if (_last4 == ".paa") then {_this} else {_this + ".paa"};
};

// 
_addToArray =
{
	private["_value", "_array", "_count", "_class", "_found", "_x", "_forEachIndex"];
	_value = _this select 0;
	_array = _this select 1;
	_count = _this select 2;
	_class = _this select 3;
	_found = false;
	{
		if (_x select 2 == _class) exitWith {
			_found = true;
			_array set [_forEachIndex, [_value, (_x select 1) + _count, _class]];
		};
	} forEach _array;

	if (!_found) then {
		_array set [count _array, [_value, _count, _class]];
	};
};

// Crée le texte+images pour le loadout d'un joueur
_addLoadoutUnitToDiary =
{
	_unit = _this select 0;
	
	_weaponsPrimary = [primaryWeapon _unit] - [""];
	_weaponsSec = [secondaryWeapon _unit] - [""];
	_weaponsHandgun = [handgunWeapon _unit] - [""];
	_weapons = weapons _unit - _weaponsPrimary - _weaponsSec - _weaponsHandgun - [""];
	_linkeditems = assignedItems _unit - [""];
	_uniform = [uniform _unit, vest _unit, headgear _unit] - [""];
	_back = [backpack _unit] - [""];
	_magazines = (magazines _unit - [""]) + (primaryWeaponMagazine _unit - [""]) + (handgunMagazine _unit - [""]) + (secondaryWeaponMagazine _unit - [""]);
	_items = (uniformItems _unit - [""]) + (vestItems _unit - [""]) + (backpackItems _unit - [""]);
	
	_weaponsList = [];
	_magasinesList = [];
	_itemsList = [];
	_uniformList = [];

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		if (!(_x in items _unit)) then
		{
			[_pic, _weaponsList, 1, _x] call _addToArray;
		};
	} forEach (_weapons);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		[_pic, _weaponsList, 1, _x] call _addToArray;
	} forEach (_linkeditems - _weapons - [""]);

	{
		_cfg = configFile >> "CfgMagazines" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		[_pic, _magasinesList, 1, _x] call _addToArray;
	} forEach (_magazines);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		[_pic, _itemsList, 1, _x] call _addToArray;
	} forEach (_items - _magazines - [""]);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		[_pic, _uniformList, 1, _x] call _addToArray;
	} forEach (_uniform);

	{
		_cfg = configFile >> "CfgVehicles" >> _x;
		_pic = getText (_cfg >> "picture") call _addExtPAA;
		[_pic, _uniformList, 1, _x] call _addToArray;
	} forEach (_back);
	
	// Premiere ligne
	_text = _text + "<font size=20><font color='#FFFFBB'>" + (name _unit) + "</font> - " + (if ((roleDescription _unit) != "") then {roleDescription _unit}else{getText (configFile >> "CfgVehicles" >> typeOf(_unit) >> "displayName")}) + " - " + (if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {[_unit] call ace_common_fnc_getWeight} else {""}) + "</font>";
	_text = _text + "<br/><br/>";
	
	// Conteneurs et chapeaux
	{
		_pic = _x select 0;
		_count = _x select 1;
		for "_i" from 1 to _count do
		{
			_text = _text + "<img image=""" + _pic + """ height=50 /> ";
		};
	} forEach _uniformList;
	_text = _text + "<br/><br/>";
	
	// Arme principale
	if (primaryWeapon _unit != "") then	{
		_name = getText (configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "displayName");
		_text = _text + "<font size=15><font color='#EF7619'>Arme principale : </font>" + _name + "</font>";
		_text = _text + "<br/>";
		if (count (primaryWeaponItems _unit - [""]) != 0) then {
			{
				_text = _text + " + " + (getText (configFile >> "CfgWeapons" >> _x >> "displayName"));
			} forEach (primaryWeaponItems _unit - [""]);
			_text = _text + "<br/>";
		};
		{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			_text = _text + "<img image=""" + _pic + (if (_forEachIndex == 0) then {""" height=60 /> "} else {""" height=40 /> "});
		} forEach (_weaponsPrimary) + (primaryWeaponItems _unit - [""]);
		_text = _text + "<br/>";
	};
	
	// Arme secondaire
	if (secondaryWeapon _unit != "") then	{
		_name = getText (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "displayName");
		_text = _text + "<font size=15><font color='#EF7619'>Lanceur : </font>" + _name + "</font>";
		_text = _text + "<br/>";
		if (count (secondaryWeaponItems _unit - [""]) != 0) then {
			{
				_text = _text + " + " + (getText(configFile >> "CfgWeapons" >> _x >> "displayName"));
			} forEach (secondaryWeaponItems _unit - [""]);
			_text = _text + "<br/>";
		};
		{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText (_cfg >> "picture") call _addExtPAA;
			_text = _text + "<img image=""" + _pic + (if (_forEachIndex == 0) then {""" height=60 /> "} else {""" height=40 /> "});
		} forEach (_weaponsSec) + (secondaryWeaponItems _unit - [""]);
		_text = _text + "<br/>";
	};
	
	// Arme de poing
	if (handgunWeapon _unit != "") then	{
		_name = getText(configFile >> "CfgWeapons" >> (handgunWeapon _unit) >> "displayName");
		_text = _text + "<font size=15><font color='#EF7619'>Arme de poing : </font>" + _name + "</font>";
		_text = _text + "<br/>";
		if (count (handgunItems _unit - [""]) != 0) then {
			{
				_text = _text + " + " + (getText (configFile >> "CfgWeapons" >> _x >> "displayName"));
			} forEach (handgunItems _unit - [""]);
			_text = _text + "<br/>";
		};
		{
			_cfg = configFile >> "CfgWeapons" >> _x;
			_pic = getText(_cfg >> "picture") call _addExtPAA;
			_text = _text + "<img image=""" + _pic + (if (_forEachIndex == 0) then {""" height=50 /> "} else {""" height=40 /> "});
		} forEach (_weaponsHandgun) + (handgunItems _unit - [""]);
		_text = _text + "<br/>";
	};
	
	// Munitions
	_text = _text + "<br/>" + "<font size=15><font color='#EF7619'>Munitions : </font><br/>";
	{
		_pic = _x select 0;
		_count = _x select 1;
		_count = str _count;
		_text = _text + "<img image=""" + _pic + """ height=35 />" + "<font color='#F193F1'>x" + _count + "</font>   ";
		_name = getText (configFile >> "CfgMagazines" >> (_x select 2) >> "displayName");
		_text = _text + _name + "<br/>";
	} forEach _magasinesList;
	
	_text = _text + "<br/>" + "<font size=15><font color='#EF7619'>Items : </font><br/>";
	
	// Items
	{
		_pic = _x select 0;
		_count = _x select 1;
		_count = str _count;
		_text = _text + "<img image=""" + _pic + """ height=35 />" + "<font color='#F193F1'>x" + _count + "</font>   ";
		_name = getText(configFile >> "CfgWeapons" >> (_x select 2) >> "displayName");
		_text = _text + _name + "<br/>";
	} forEach (_weaponsList + _itemsList);
};

_text = "";
[player] call _addLoadoutUnitToDiary;
_name = name player;
player createDiarySubject ["inventory","Inventaire"];
player createDiaryRecord ["inventory", ["Matos de " + _name, _text]];
