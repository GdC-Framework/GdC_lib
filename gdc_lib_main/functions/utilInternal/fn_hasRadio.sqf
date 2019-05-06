/*
	Description:
		Check if the unit has a radio with the asked type
		[_unit, _radioType] call GDC_fnc_hasRadioOnRightChannel

	Parameter(s):
		0 (optional): STRING - Unit to check
        1 (optional): STRING - Radio type to check

	Returns:
		boolean: true if the unit has a radio
*/

params[["_unit", player], ["_radioType", "ACRE_PRC117f"]];

// If true foreach will return true, else it will return the last "false"
{ 
	if([_radioType, _x] call GDC_fnc_StringStartWith)
		exitWith { true };
	false; 
} foreach ([_unit] call acre_api_fnc_getCurrentRadioList);
