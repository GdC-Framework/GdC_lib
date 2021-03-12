
'Util tests' call ShowAndLog;
_success = true;

//////////////////////////
// chooseSpawnPos_onMapSingleClick
_moveable_mkr = "mkr_util_chooseSpawnPos_moveable";
{
	// https://community.bistudio.com/wiki/BIS_fnc_callScriptedEventHandler

	_old_pos = getMarkerPos _moveable_mkr;

	_x params ["_mkr", "_wanted_result"];
	_result = [_moveable_mkr, getMarkerPos _mkr, ["mkr_util_chooseSpawnPos_blacklist"], 0, ["mkr_util_chooseSpawnPos_ref"]] call GDC_fnc_chooseSpawnPos_onMapSingleClick;

	// Check if the old position has move, and if this test should be valid to move the marker
	if( !(_wanted_result == _result
		&& (!_result || getMarkerPos _mkr isEqualTo getMarkerPos _moveable_mkr))) then {
		format (["%1 GDC_fnc_chooseSpawnPos could return %2", _x]) call ShowAndLog;
		_success = false;
	};
} foreach [
	["mkr_util_chooseSpawnPos_earth_out", false],
	["mkr_util_chooseSpawnPos_earth_bl", false],
	["mkr_util_chooseSpawnPos_earth_in", true],
	["mkr_util_chooseSpawnPos_water_in", false]
];


if(_success) then {
	'Util tests: END with SUCCESS' call ShowAndLog;
} else {
	'Util tests: END and FAIL' call ShowAndLog;
};
