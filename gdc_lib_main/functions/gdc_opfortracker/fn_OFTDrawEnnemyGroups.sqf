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
	_targetType = switch true do { // TODO : possibilité d'assigner un type de marqueur via une variable pour s'assurer d'avoir le bon type ?
		case (_target isKindOf "Man"): {"o_inf"};
		case (_target isKindOf "Car"): {
			switch true do {
				case (_target isKindOf "Wheeled_APC_F");
				case (_target isKindOf "MRAP_01_base_F"): {"o_mech_inf"};
				default {"o_motor_inf"};
			};
		};
		case (_target isKindOf "Tank"): {"o_armor"};
		case (_target isKindOf "Helicopter"): {"o_air"};
		case (_target isKindOf "Plane"): {"o_plane"};
		case (_target isKindOf "Ship"): {"o_naval"};
		case (_target isKindOf "StaticWeapon"): {
			switch true do {
				case (_target isKindOf "StaticMortar"): {"o_mortar"};
				case (_target isKindOf "StaticCannon"): {"o_art"};
				case (_target isKindOf "StaticAAWeapon"): {"o_antiair"};
				case (_target isKindOf "StaticMGWeapon");
				case (_target isKindOf "StaticATWeapon");
				case (_target isKindOf "StaticGrenadeLauncher"): {"o_support"};
				default {"o_unknown"};
			};
		};
		default {"o_unknown"};
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
			[_mk] call gdc_fnc_OFTMarkerEffects;
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