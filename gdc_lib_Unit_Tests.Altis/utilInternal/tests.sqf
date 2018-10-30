
systemChat 'UtilInternal tests: Init';
_success = true;





{
	if( !(((_x select [0, 2]) call GDC_fnc_StringStartWith) isEqualTo (_x select 2)) ) then {
		systemChat format (["[%1, %2] GDC_fnc_StringStartWith should return %3"] + _x); 
		_success = false;
	}
} foreach [
	['123', '123', true],
	['a', 'b', false],
	['abc', 'abcd', true],
	['abc', 'a', false],
	['ABC', 'abc', true]
];



if(_success) then {
	systemChat 'UtilInternal tests: END with SUCCESS';
} else {
	systemChat 'UtilInternal tests: END and FAIL';
}
