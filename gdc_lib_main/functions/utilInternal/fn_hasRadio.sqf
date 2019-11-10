/*
	Description:
		Check if the unit has a radio with the asked type
		[_unit, _radioType] call GDC_fnc_hasRadio

	Parameter(s):
		0 (optional): STRING - Unit to check
        1 (optional): STRING - Radio type to check

	Returns:
		boolean: true if the unit has a radio
*/

params[["_unit", player, [objNull]], ["_radioType", "ACRE_PRC117f", [""]]];
[_unit, _radioType] call acre_api_fnc_hasKindOfRadio;
