/*
	Author: Sparfell

	Description: marker blink and marker fade

	Parameter(s):
		- STRING - marker

	Returns:
	nothing
*/

_this spawn 
{
	params
	[
		["_mk","",[""]],
		["_ping",false,[false]]
	];
	
	// First we close any previous fade and we wait until the marker can blink
	missionNamespace setVariable ["interruptFade_" + _mk,true];
	waitUntil {missionNamespace getVariable ["canblink_" + _mk,true]};
	missionNamespace setVariable ["canblink_" + _mk,false];

	// blinking
	sleep 1;
	for "_i" from 1 to 6 do {
		if (_ping) then {[_mk] spawn gdc_fnc_OFTMarkerPing;};
		_mk setMarkerColorLocal "ColorRED";
		_mk setMarkerSizeLocal [1.5,1.5];
		sleep 0.5;
		_mk setMarkerColorLocal gdc_OFTMkColor;
		_mk setMarkerSizeLocal [1,1];
		sleep 0.5;
	};

	private _NR_OF_STEPS = 16;
	private _actualAlpha = 1;
	private _step = _actualAlpha/_NR_OF_STEPS;
	missionNamespace setVariable ["interruptFade_" + _mk,false];

	while {(markerAlpha _mk) > 0} do
	{
		sleep (gdc_OFTfadeMkDuration / _NR_OF_STEPS);
		if (missionNamespace getVariable ["interruptFade_" + _mk,false]) exitWith {
			_mk setMarkerAlphaLocal 1;
			missionNamespace setVariable ["canblink_" + _mk,true];
		};
		if (_actualAlpha == 0) exitWith {deleteMarkerLocal _mk;};
		_actualAlpha = (_actualAlpha - _step);
		_mk setMarkerAlphaLocal _actualAlpha;
	};
	if ((markerAlpha _mk) == 0) then {deleteMarkerLocal _mk;};
};