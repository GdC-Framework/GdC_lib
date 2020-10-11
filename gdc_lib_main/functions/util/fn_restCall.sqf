/*
	Description:
		Make a rest call to an url, with the right verb and if needed the body
		[URL, "Get", nil, { Function }] call GDC_fnc_restCall;
		[URL, "Post", "{ json: ""valid"" }", { Function }] call GDC_fnc_restCall;

	Parameters:
		0: URL
		1: Verb (Get, Post, Put, Delete, Patch) // Patch Not implemented Yet
		2: Body as json format, could be nil if verb is Get or Delete
		3: Callback ( parameters [_fromUrl, _result] )

	Tests:
		Could be tested with https://docs.postman-echo.com/
		GET - 
			systemChat str (["https://postman-echo.com/get?foo1=bar1", "Get"] call GDC_fnc_restCall);
		POST - 
			systemChat str (["https://postman-echo.com/post", "Post", "{ a: 1 }"] call GDC_fnc_restCall);
		PUT - 
			systemChat str (["https://postman-echo.com/put", "Put", "{ a: 1 }"] call GDC_fnc_restCall);
		DELETE - 
			systemChat str (["https://postman-echo.com/put", "Delete"] call GDC_fnc_restCall);

	Returns:
		string: the body of the response
*/

params [
	["_url","",[""]],
	["_verb",{},[""]],
	["_body",{},[""]],
	["_callback",{},[{}, ""]]
];

if(! _verb in ["Get", "Post", "Put", "Delete", "Patch"]) exitWith {
	systemChat str ["Wrong verb: ", _verb];
};

_response = "";
if(_verb in ["Get", "Delete"]) then {
	_response = "GDC" callExtension ["send", [_url, _verb]];
} else {
	_response = "GDC" callExtension ["send", [_url, _verb, _body]];
};

if (typeName _callback == typeName {}) then {
	[_url, _response] spawn _callback;
} else {
	[_url, _response] execVM _callback;
};

_response;
