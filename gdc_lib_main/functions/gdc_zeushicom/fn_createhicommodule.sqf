/*
	Author: Sparfell

	Description:
	Subfunction of zeushicom. Create Zeus modules for HICOM system.

	Parameter(s):
		OBJECT : name of the logic object synchronized with the objects controlled by the hicom 
		NUMBER : specific id needed for each zeus
		BOOL : if true, the attributes that can be modified through zeus are limited

	Returns:
	nothing
*/
params ["_logic","_id","_limitcurator"];

private _name = _logic getVariable ["gdc_hicom_name",""];
private _module_group = createGroup sideLogic;
private _curator = _module_group createUnit ["ModuleCurator_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_curator setVariable ["name",_name,true];
//_curator setVariable ["owner", _owner, true];
_curator setVariable ["Addons", 0, true];
_curator setVariable ["BIS_fnc_initModules_disableAutoActivation", false];
_curator setCuratorCoef ["Place", 0];
_curator setCuratorCoef ["Delete", 0];
gdc_zeushicommodules pushBackUnique _curator;
publicVariable "gdc_zeushicommodules";
_module_group deleteGroupWhenEmpty true;

//availableunits
private _units = synchronizedObjects _logic;
_curator addCuratorEditableObjects [_units,false];

//Curator limitations
if (_limitcurator) then {
	// available addons
	[_curator] spawn {
		params ["_curator"];
		waitUntil {time > 1};
		//removeAllCuratorAddons _curator;
		//_curator addCuratorAddons ["ace_zeus","ace_zeus_captives"];
		_curator addCuratorAddons activatedAddons;
		[
			_curator,
			[
				"ace_zeus_moduleDefendArea",0,
				"ace_zeus_modulePatrolArea",0,
				"ace_zeus_moduleSearchArea",0,
				"ace_zeus_moduleSearchNearby",0,
				"ace_zeus_moduleGarrison",0,
				"ace_zeus_moduleUnGarrison",0,
				"ace_zeus_moduleToggleNvg",0,
				"ace_zeus_moduleToggleFlashlight",0,
				"ace_zeus_moduleSuppressiveFire",0,
				"ace_zeus_moduleCaptive",0,
				"ace_zeus_moduleSurrender",0
			]
		] remoteExec ["BIS_fnc_curatorObjectRegisteredTable"];
	};
	// camera and editing area 
	_curator addCuratorCameraArea [_id,[0,0,0],1];
	_curator addCuratorEditingArea [_id,[0,0,0],1];
	_curator setCuratorCameraAreaCeiling 1.75;
	// attributes
	[
		_curator,
		"object",
		["UnitPos"]
	] call BIS_fnc_setCuratorAttributes;
	[
		_curator,
		"group",
		["GroupID","Behaviour","Formation","SpeedMode","UnitPos"]
	] call BIS_fnc_setCuratorAttributes;
};