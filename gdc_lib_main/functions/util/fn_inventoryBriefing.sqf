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
	_array = toArray(_path);
	_len = count _array;
	_last4 = toString[_array select _len-4, _array select _len-3, _array select _len-2, _array select _len-1];
	if(_last4 == ".paa")then {_this} else {_this + ".paa"};
};

// 
_addToArray =
{
	private["_value", "_array", "_count", "_found", "_x", "_forEachIndex"];
	_value = _this select 0;
	_array = _this select 1;
	_count = _this select 2;
	_found = false;
	{
		if(_x select 0 == _value)exitWith
		{
			_found = true;
			_array set [_forEachIndex, [_value, (_x select 1) + _count]];
		};
	}forEach _array;

	if(!_found)then
	{
		_array set [count _array, [_value, _count]];
	};
};

// Crée le texte+images pour le loadout d'un joueur
_addLoadoutUnitToDiary =
{
	_unit = _this select 0;
	_text = _text + "<font color='#FFFFBB'>" + (name _unit) + "</font> - " + (if((roleDescription _unit) != "")then{roleDescription _unit}else{getText(configFile >> "CfgVehicles" >> typeOf(_unit) >> "displayName")});
	_text = _text + "<br/>";
	if(primaryWeapon _unit != "")then
	{
		_name = getText(configFile >> "CfgWeapons" >> (primaryWeapon _unit) >> "displayName");
		_text = _text + "Arme principale : " + _name;
                _text = _text + "<br/>";
	};
	
	_weaponsPrimary = [primaryWeapon _unit] - [""];
	_weaponsSec = [secondaryWeapon _unit] - [""];
	_weapons = weapons _unit - _weaponsPrimary - _weaponsSec - [""];
	_items = assignedItems _unit - [""];
	_uniform = [uniform _unit, vest _unit, headgear _unit] - [""];
	_back = [backpack _unit] - [""];
	_magazines = (magazines _unit - [""])+(primaryWeaponMagazine _unit - [""])+(handgunMagazine _unit - [""])+(secondaryWeaponMagazine _unit - [""]);
	_teme = (uniformItems _unit - [""])+(vestItems _unit - [""])+(backpackItems _unit - [""]);
	
	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		_text = _text + "<img image=""" + _pic + """ height=70 /> ";
	} forEach (_weaponsPrimary)+(primaryWeaponItems _unit - [""]);
	_text = _text + "<br/>";

	if(secondaryWeapon _unit != "")then
	{
		_nama = getText(configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "displayName");
		_text = _text + "Launcher - " + _nama;
                _text = _text + "<br/>";
	};

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		_text = _text + "<img image=""" + _pic + """ height=50 /> ";
	} forEach (_weaponsSec)+(secondaryWeaponItems _unit - [""]);
	_text = _text + "<br/>";

	_weaponsList = [];
	_magasinesList = [];
	_uniformList = [];

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		if(!(_x in items _unit))then
		{
			[_pic, _weaponsList, 1] call _addToArray;
		};
	} forEach (_weapons)+(handgunItems _unit - [""]);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		[_pic, _weaponsList, 1] call _addToArray;
	} forEach (_items - _weapons - [""]);

	{
		_cfg = configFile >> "CfgMagazines" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		[_pic, _magasinesList, 1] call _addToArray;
	} forEach (_magazines);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		[_pic, _magasinesList, 1] call _addToArray;
	} forEach (_teme - _magazines - [""]);

	{
		_cfg = configFile >> "CfgWeapons" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		[_pic, _uniformList, 1] call _addToArray;
	} forEach (_uniform);

	{
		_cfg = configFile >> "CfgVehicles" >> _x;
		_pic = getText(_cfg >> "picture") call _addExtPAA;
		[_pic, _uniformList, 1] call _addToArray;
	} forEach (_back);

	{
		_pic = _x select 0;
		_count = _x select 1;
		for "_i" from 1 to _count do
		{
			_text = _text + "<img image=""" + _pic + """ height=35 /> ";
		};
	} forEach _weaponsList;
	_text = _text + "<br/>";

	{
	_pic = _x select 0;
			_count = _x select 1;
			_count = str _count;
			_text = _text + "<img image=""" + _pic + """ height=35 />" + "x" + _count + "  ";
	} forEach _magasinesList;
	_text = _text + "<br/>";
	_text = _text + "<br/>";

	{
		_pic = _x select 0;
		_count = _x select 1;
		for "_i" from 1 to _count do
		{
			_text = _text + "<img image=""" + _pic + """ height=50 /> ";
		};
	} forEach _uniformList;
	_text = _text + "<br/>";
	_text = _text + "<br/>";
};

_text = "";
[player] call _addLoadoutUnitToDiary;
_name = name player;
player createDiarySubject ["inventory","Inventaire"];
player createDiaryRecord ["inventory", ["Matos de " + _name, _text]];
