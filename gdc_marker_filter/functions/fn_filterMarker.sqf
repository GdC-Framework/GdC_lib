params [
	["_tbMrk", []],
	["_show", true]
];

//If briefing has been skipped, initialize arrays
if (isNil "tbMrkAAPBlufor") then {[] call gdc_fnc_initMrkFilter;};

private _mrkAlpha = 0;
if (count _tbMrk > 1) then {
	//Dynamic array for player created markers
	if (([(_tbMrk#0#0),0,14] call BIS_fnc_trimString) isEqualTo "_USER_DEFINED #") exitWith {
		if (_show) then {_mrkAlpha = 1};
		{
			if (([(_x),0,14] call BIS_fnc_trimString) isEqualTo "_USER_DEFINED #") then {
				(_x) setMarkerAlpha _mrkAlpha;
			};
		} forEach allMapMarkers;
		[] call gdc_fnc_setBtnState;
	};

	if (_show) then {
		{_x#0 setMarkerAlphaLocal _x#1} forEach _tbMrk;
	} else {
		{_x#0 setMarkerAlphaLocal 0} forEach _tbMrk;
	};
};

//Set button state
[] call gdc_fnc_setBtnState;
