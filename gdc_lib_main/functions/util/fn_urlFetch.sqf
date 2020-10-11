/*
	Description:
		Make a call to an url
		[URL, { Function }] call GDC_fnc_urlFetch;

	Parameter(s):
		0: URL
		1: Callback ( parameters [_fromUrl, _result] )

	Tests:
		Could be tested with https://docs.postman-echo.com/
		GET - 
			["https://postman-echo.com/get?foo1=bar1", { systemChat str _this }] call GDC_fnc_urlFetch;

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
