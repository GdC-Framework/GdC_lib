/*
	Description:
	Secure a parameter, that can be a string or an array, to return the array or an array containing only one element for the first case.

	Parameter(s):
		0: ARRAY/STRING - Param to secure
        1 (optional): ANY - Default value that will be returned, default value is empty array [] 

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

