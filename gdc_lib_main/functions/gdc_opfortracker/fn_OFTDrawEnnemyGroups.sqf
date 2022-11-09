/*
	Author: Sparfell

	Description: create markers on ennemy groups positions

	Parameter(s):

	Returns:
	nothing
*/

private ["_targetType","_targetPos","_target","_detector","_detectionDistance","_posError","_mkPos","_loopMkCount","_loopMkCount2"];

//Debug stuf
_loopMkCount = 0;
_loopMkCount2 = 0;

{
	_target = _x #0;
	_targetPos = getpos _target;
	_targetType = [group _target] call ace_common_fnc_getMarkerType;
	_targetType = _targetType regexReplace ["n_|b_","o_"];
	if (_target isKindOf "StaticWeapon") then {
		_targetType = switch true do {
			case (_target isKindOf "StaticMGWeapon");
			case (_target isKindOf "StaticATWeapon");
			case (_target isKindOf "StaticGrenadeLauncher"): {"o_installation"};
			default {_targetType};
		};
	};
	_detector = _x #1;
	
	// Position error
	_detectionDistance = (_target distance _detector);
	_posError = random (((_detectionDistance * (_detectionDistance / 1000)) / (0.5 + (skill _detector))) min 100);
	_mkPos = _targetPos getPos [_posError, random 360];

	private _nearestMkList = (gdc_OFTmkList select {(((markerPos _x) distance2D _mkPos) < 100) && ((markerType _x) == _targetType)});
	if (count _nearestMkList < 1) then {// Create marker if no other same type marker in vicinity (100m)
			private ["_mk"];
			_mk = createMarkerLocal [(format ["mk_target%1_%2_%3",_target,_targetPos,time]),_mkPos];
			_mk setMarkerAlphaLocal 0;
			_mk setMarkerColorLocal gdc_OFTMkColor;
			_mk setMarkerTypeLocal _targetType;
			_mk setMarkerTextLocal (_target getVariable ["gdc_OFTTargetType",""]);
			gdc_OFTmkList = gdc_OFTmkList + [_mk];
		[_mk,[_detector,_target,_targetType,_mkPos]] spawn { //Marker display and radio message are delayed
			sleep gdc_OFTcreateMkDelay;
			params ["_mk","_mkParams"];
			_mk setMarkerAlphaLocal 1;
			[_mk,true] call gdc_fnc_OFTMarkerEffects;
			_mkParams call gdc_fnc_OFTGenerateRadioMessage;
		};
		_loopMkCount = _loopMkCount + 1;
	} else {// update already placed markers
		{
			if (markerAlpha _x < 1) then {
				[_x] spawn {
					sleep gdc_OFTcreateMkDelay;
					params ["_mk"];
					[_mk] call gdc_fnc_OFTMarkerEffects;
					playsound "TacticalPing4";
				};
				_loopMkCount2 = _loopMkCount2 + 1;
			};
		} forEach _nearestMkList;
	};
} forEach gdc_OFTtargetsList;

if (gdc_OFTDebug) then {
	systemChat format ["%1 marker created",_loopMkCount];
	systemChat format ["%1 marker updated",_loopMkCount2];
};