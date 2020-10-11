/*
	Description:
		Make a call to an url
		[URL, { Function }] call GDC_fnc_urlFetch;

	Parameter(s):
		0: URL
		1: Callback ( parameters [_fromUrl, _result] )

	Returns:
		string: Return nothing
*/

params [
	["_url","",[""]],
	["_callback",{},[{}, ""]]
];

_res = "GDC" callExtension ["send", [_url, "Get"]];
if (typeName _callback == typeName {}) then {
	[_url, _res] spawn _callback;
} else {
	[_url, _res] execVM _callback;
};
