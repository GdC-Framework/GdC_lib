/*
	Author: Shinriel

	Description:
	Secure a parameter, that can be a string or a string, to return an array

	Parameter(s):
		0: ARRAY/STRING - Param to secure
        1 (optional): ANY - Default value that will be returne, default value is empty array [] 

	Returns:
		ARRAY, with one element if a string was passed
		ARRAY, with all elements if an array was passed
*/

params [
	["_paramToSecure", nil, ["", []]],
	["_defaultValue", []]
];

if(isNil "_paramToSecure" ) exitWith {
	_defaultValue;
};

if (typename _paramToSecure == "ARRAY") exitWith {
	_paramToSecure;
};

[_paramToSecure];

