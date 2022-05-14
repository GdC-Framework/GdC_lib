/*
	Author: Sparfell

	Description:
	Check if player one of the specified types of radios including those mounted on vehicle racks
	Same as acre_api_fnc_hasKindOfRadio but with racks compatibility

	Parameter(s):
		STRING OR ARRAY[string] - radio classes

	Returns:
	BOLEAN

	Example :
	[["ACRE_PRC117F","ACRE_PRC77"]] call GDC_fnc_hasKindOfRadio
	["ACRE_PRC148"] call GDC_fnc_hasKindOfRadio
*/

params [
	["_types",[],["",[]]]
];

if (typeName _types == "STRING") then {_types = [_types]};

private _r = false;
{
	private _class = _x;
	if ([player,_class] call acre_api_fnc_hasKindOfRadio) exitwith {_r = true;};
	{
		if (([_x] call acre_api_fnc_getBaseRadio) == _class) exitwith {_r = true;};
	} forEach ([] call acre_api_fnc_getCurrentRadioList);
} forEach _types;

_r
