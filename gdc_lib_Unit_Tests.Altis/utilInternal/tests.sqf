
'UtilInternal tests' call ShowAndLog;
_success = true;

//////////////////////////
// GDC_fnc_animVehicleDoor
// {
// _veh = (_x select 1) createVehicle (getMarkerPos 'mkr_animVehicleDoor');

// [_veh, 1] call GDC_fnc_animVehicleDoor;
// sleep 5;
// if( !(_veh doorPhase "door" isEqualTo 1) ) then {
// format (["%1 GDC_fnc_animVehicleDoor could return %2", _x]) call ShowAndLog;
// _success = false;
// };

// [_veh, 0] call GDC_fnc_animVehicleDoor;
// sleep 5;
// if( !(_veh doorPhase "door" isEqualTo 0) ) then {
// format (["%1 GDC_fnc_animVehicleDoor could return %2", _x]) call ShowAndLog;
// _success = false;
// };

// deleteVehicle _veh;
// } foreach [
// ["VTOL_01_base_F", "Door_1_source"]
// ];

//////////////////////////
// GDC_fnc_hasRadioOnRightChannel
_has_no_radio = false;
if(!([player, "ACRE_PRC148"] call acre_api_fnc_hasKindOfRadio)) then {
	_has_no_radio = true;
	player addItemToUniform "ACRE_PRC148";
	sleep 0.5;
};

// ["ACRE_PRC152_ID_123", 5] call acre_api_fnc_setRadioChannel;
[["ACRE_PRC148"] call acre_api_fnc_getRadioByType, 5] call acre_api_fnc_setRadioChannel;

{
	if( !(((_x select 0) call GDC_fnc_hasRadioOnRightChannel) isEqualTo (_x select 1)) ) then {
		format (["%1 GDC_fnc_hasRadioOnRightChannel could return %2", _x]) call ShowAndLog;
		_success = false;
	};

} foreach [
	[[player, "ACRE_PRC148", 5], true],
	[[player, "ACRE_PRC148", 9], false]
];

if(_has_no_radio) then {
	player removeItemFromUniform "ACRE_PRC148";
};

//////////////////////////
// GDC_fnc_StringStartWith
{

	if( !(((_x select [0, 2]) call GDC_fnc_StringStartWith) isEqualTo (_x select 2)) ) then {
		format (["[%1, %2] GDC_fnc_StringStartWith could return %3", _x]) call ShowAndLog;
		_success = false;
	};

} foreach [
	['123', '123', true],
	['a', 'b', false],
	['abc', 'abcd', true],
	['abc', 'a', false],
	['ABC', 'abc', true]
];



if(_success) then {
	'UtilInternal tests: END with SUCCESS' call ShowAndLog;
} else {
	'UtilInternal tests: END and FAIL' call ShowAndLog;
};
