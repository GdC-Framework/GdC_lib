/*
	Author: Sparfell

	Description:
	Adds an "inventory" tab in the diary displaying every player's inventory
	
	Parameter(s):
		NONE

	Returns:
	nothing
*/

if (player diarySubjectExists "inventory") exitwith {};

private _allrealplayers = switchableUnits;
if (isMultiplayer) then {
	_allrealplayers = playableUnits;
};
_allrealplayers = _allrealplayers - [HC_Slot];

reverse _allrealplayers;
player createDiarySubject ["inventory","Inventaire"];
{
	private _unit = _x;
	private _text = [_unit] call GDC_fnc_getInventoryBriefing;
	private _name = name _unit;
	private _role = getText (configFile >> "CfgVehicles" >> (typeOf _unit) >> "displayName");
	if ((roleDescription _unit) != "") then {
		_nbr = (roleDescription _unit) find "@";
		if (_nbr < 0) then {
			_role = (roleDescription _unit);
		} else {
			_role = ((roleDescription _unit) select [0,_nbr]);
		};
	};
	player createDiaryRecord ["inventory", [(_role + " - " + _name), _text]];	
} forEach _allrealplayers;