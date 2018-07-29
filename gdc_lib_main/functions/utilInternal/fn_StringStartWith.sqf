/*
	Author: Shinriel

	Description:
		Check if the 2nd argument start with the reference
		['123', '123456789'] call GDC_fnc_StringStartWith

	Parameter(s):
		0 (optional): STRING - Reference
        1 (optional): STRING - String to check

	Returns:
		boolean: true if the 2nd argument start with the first
*/

params["_reference", "_string"];

private ["_referenceArray", "_stringArray", "_result"];

if(count _reference > count _string) then {
	false;
};

_referenceArray = toUpper(_reference) splitString "";
_stringArray = toUpper(_string) splitString "";

_result = true; 
for [{ _i= 0}, {_i < (count _referenceArray)}, {_i = _i + 1}] do { 
	if((_referenceArray select _i) != (_stringArray select _i)) then { 
		_result = false; 
		_i = count _reference; // End the loop 
	} 
}; 
 
_result;
