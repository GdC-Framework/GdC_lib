/*
	Description:
		Make a call to an url
		[URL, { Function }] call GDC_fnc_urlFetch;

	Author & Source: http://killzonekid.com/arma-scripting-tutorials-url_fetch-callback/

	Parameter(s):
		0 : URL
		1 : Callback ( parameters [_fromUrl, _result] )

	Returns:
		string: Return nothing
*/

if (isNil "url_fetch_queue") then {
	url_fetch_queue = [_this];
	{
		_url = _x select 0;
		_scr = _x select 1;
		waitUntil {
			if ("url_fetch" callExtension format [
				"%1",
				_url
			] == "OK") exitWith {true};
			false
		};
		private "_res";
		waitUntil {
			_res = "url_fetch" callExtension "OK";
			if (_res != "WAIT") exitWith {true};
			false
		};
		if (_res == "ERROR") then {
			0 = [
				_url,
				"url_fetch" callExtension "ERROR"
			] spawn url_fetch_error;
		} else {
			if (typeName _scr == typeName {}) then {
				[_url, _res] spawn _scr;
			} else {
				[_url, _res] execVM _scr;
			};
		};
	} forEach url_fetch_queue;
	url_fetch_queue = nil;
} else {
	url_fetch_queue set [count url_fetch_queue, _this];
};