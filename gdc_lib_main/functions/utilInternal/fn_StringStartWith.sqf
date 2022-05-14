/*
	Author: Shinriel

	Description:
		Check if the 2nd argument start with the reference
		['123', '123456789'] call GDC_fnc_StringStartWith
		/!\ The check is always case INsensitive!

	Parameter(s):
		0 (optional): STRING - Reference
        1 (optional): STRING - String to check

	Returns:
		boolean: true if the 2nd argument start with the first
*/

params["_reference", "_string"];

if(count _reference > count _string) exitWith { false };
_reference == (_string select [0,count _reference]);
