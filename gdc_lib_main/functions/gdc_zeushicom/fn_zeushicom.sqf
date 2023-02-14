/*
	Author: Sparfell

	Description:
	Main function for Zeus HICOM system.

	Parameter(s):
		ARRAY of ARRAYs : hicom modules available ["hicomname",logicname] the logicname is the name of the logic synchronized with the objects controlled by the hicom (default=[])
		STRING (optionnal) : classname of the item the player must have in order to get the reports (default="itemmap")
		BOOL (optionnal) : if true, the HICOM BFT is activated (default=true)
		BOOL (optionnal) : if true, the HICOM OFT is activated (default=true)
		ARRAY of OBJECTS (optionnal) : other units that should report contact to the hicom with OFT (default=[])
		BOOL (optionnal) : if true the hicom will be executed if he kills another player (default=false)
		BOOL (optionnal) : if true, the attributes that can be modified through zeus are limited (default=true)

	Returns:
	nothing

	TODO :
	- tuto 3den
	- modules ACE pas dispos
	- repop le hicom immédiatement si il est supprimé :
	https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#Deleted
*/

params [
	["_hicoms",[],[[]]],
	["_itemcondition","itemmap",[""]],
	["_activateBFT",true,[true]],
	["_activateOFT",true,[true]],
	["_otherunits",[],[[]]],
	["_nohicomkill",false,[false]],
	["_limitcurator",true,[true]]
];
//gdc_zeushicommodules = [];
gdc_zeushicomlogics = [];
gdc_zeushicomlimit = _limitcurator;

{
	_x params ["_name","_logic"];
	_logic setVariable ["gdc_hicom_name",_name,true];
	gdc_zeushicomlogics pushBack _logic;
} forEach _hicoms;

if (isServer) then {
	// BFT
	if (_activateBFT) then {[_itemcondition] remoteExec ["GDC_fnc_hicombft",0,true];};
	// Briefing stuff
	[_itemcondition,_activateBFT,_activateOFT] remoteExec ["gdc_fnc_createhicombriefing",0,true];

	// zeus modules creation
	gdc_zeushicommodules = [];
	{
		[_x,_foreachindex,gdc_zeushicomlimit] call gdc_fnc_createhicommodule;
	} forEach gdc_zeushicomlogics;
	[] spawn {
		waitUntil {time > 0};
		publicVariable "gdc_zeushicommodules";
	};

	// ACE actions
	[_itemcondition] remoteExec ["gdc_fnc_createhicomaceactions",0,true];
	// opfor tracker
	if (_activateOFT) then {[gdc_zeushicomlogics,_itemcondition,_otherunits] remoteExec ["gdc_fnc_InitOpforTracker",0,true];};
};

if (_nohicomkill) then {
	{
		_x addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			if (isnull _instigator) then {
				_instigator = _killer;
			};
			if (_instigator == _unit) exitwith {}; //suicide
			if (_instigator in (gdc_zeushicommodules apply {getAssignedCuratorUnit _x})) then {
				[["Le hicom a tué un joueur, il va mourrir.","PLAIN DOWN"]] remoteExec ["titleText",0];
				[_instigator] spawn {
					params ["_instigator"];
					sleep 2;
					private _tempTarget = createSimpleObject ["Land_HelipadEmpty_F", getPosASL _instigator];
					[_tempTarget, nil, true] remoteExec ["BIS_fnc_moduleLightning",0];
					_instigator setDamage 1;
				};
			};
		}];
	} forEach (playableUnits + switchableUnits);
};

waitUntil { !isNull (findDisplay 46) };
findDisplay 46 displayAddEventHandler ["KeyDown", {
	if (inputAction "CuratorInterface" > 0) then
	{
		private _curator = getAssignedCuratorLogic player;
		private _camid = ((curatorCameraArea _curator) #0) #0;
		[_curator,[_camid,position player,1]] remoteExec ["addCuratorCameraArea",2];
	};
	false
}];