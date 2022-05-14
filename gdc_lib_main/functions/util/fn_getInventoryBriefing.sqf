/*
	Author: TECAK, Mystery, Sparfell

	Description:
	get the string for fn_inventoryBriefing.sqf

	Parameter(s):
		OBJECT : unit we need the inventory from

	Returns:
	STRING :
*/

params ["_unit"];

// Vérifie si le path vers l'image est correct (met une image par défaut si nécessaire)
_VerifyPic =
{
	private ["_path"];
	_path = _this;
	if (_path == "") then {
		_path = "\A3\ui_f\data\map\diary\icons\taskFailed_ca";
	};
	_path call _addExtPAA;
};

// Ajoute l'extension .paa si elle n'est pas présente
_addExtPAA =
{
	private["_path","_last4"];
	_path = toLower _this;
	_last4 = _path select [(count _path) - 4];
	if (_last4 == ".paa") then {_this} else {_this + ".paa"};
};

// Ajoute les items dans la liste en vérifiant si un item du même type n'est pas déjà présent
_addToArray =
{
	private["_found", "_x", "_forEachIndex"];
	params["_value", "_array", "_count", "_class"];

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
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	if (!(_x in items _unit)) then
	{
		[_pic, _weaponsList, 1, _x] call _addToArray;
	};
} forEach (_weapons);

{
	_cfg = configFile >> "CfgWeapons" >> _x;
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	[_pic, _weaponsList, 1, _x] call _addToArray;
} forEach (_linkeditems - _weapons - [""]);

{
	_cfg = configFile >> "CfgMagazines" >> _x;
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	[_pic, _magasinesList, 1, _x] call _addToArray;
} forEach (_magazines);

{
	_cfg = configFile >> "CfgWeapons" >> _x;
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	[_pic, _itemsList, 1, _x] call _addToArray;
} forEach (_items - _magazines - [""]);

{
	_cfg = configFile >> "CfgWeapons" >> _x;
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	[_pic, _uniformList, 1, _x] call _addToArray;
} forEach (_uniform);

{
	_cfg = configFile >> "CfgVehicles" >> _x;
	_pic = getText (_cfg >> "picture") call _VerifyPic;
	[_pic, _uniformList, 1, _x] call _addToArray;
} forEach (_back);

// Affichage du role
private _role = getText (configFile >> "CfgVehicles" >> (typeOf _unit) >> "displayName");
if ((roleDescription _unit) != "") then {
	_nbr = (roleDescription _unit) find "@";
	if (_nbr < 0) then {
		_role = (roleDescription _unit);
	} else {
		_role = ((roleDescription _unit) select [0,_nbr]);
	};
};
// Premiere ligne
private _text = "";
_text = _text + "<font size=20><font color='#FFFFBB'>" + (name _unit) + "</font> - " + _role + " - " + (if (isClass (configFile >> "CfgPatches" >> "ace_main")) then {[_unit] call ace_common_fnc_getWeight} else {""}) + "</font>";
_text = _text + "<br/><br/>";

// Conteneurs et chapeaux
{
	_x params["_pic", "_count"];
	for "_i" from 1 to _count do
	{
		_text = _text + "<img image=""" + _pic + """ height=50 /> ";
	};
} forEach _uniformList;
_text = _text + "<br/><br/>";

// Affichage des protections
if ((vest _unit) != "") then {
	_text = _text + "<font color='#EF7619'>Veste</font> : " + (gettext (configFile >> "CfgWeapons" >> (vest _unit) >> "displayName")) + " : <font color='#F193F1'>" + (gettext (configFile >> "CfgWeapons" >> (vest _unit) >> "descriptionShort")) + "</font>";
	_text = _text + "<br/>";
};
if ((headgear _unit) != "") then {
	_text = _text + "<font color='#EF7619'>Casque</font> : " + (gettext (configFile >> "CfgWeapons" >> (headgear _unit) >> "displayName")) + " : <font color='#F193F1'>" + (gettext (configFile >> "CfgWeapons" >> (headgear _unit) >> "descriptionShort")) + "</font>";
	_text = _text + "<br/><br/>";
};

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
	_x params["_pic", "_count"];
	_count = str _count;
	_text = _text + "<img image=""" + _pic + """ height=35 />" + "<font color='#F193F1'>x" + _count + "</font>   ";
	_name = getText (configFile >> "CfgMagazines" >> (_x select 2) >> "displayName");
	_text = _text + _name + "<br/>";
} forEach _magasinesList;

_text = _text + "<br/>" + "<font size=15><font color='#EF7619'>Items : </font><br/>";

// Items
{
	_x params["_pic", "_count"];
	_count = str _count;
	_text = _text + "<img image=""" + _pic + """ height=35 />" + "<font color='#F193F1'>x" + _count + "</font>   ";
	_name = getText(configFile >> "CfgWeapons" >> (_x select 2) >> "displayName");
	_text = _text + _name + "<br/>";
} forEach (_weaponsList + _itemsList);

_text;
