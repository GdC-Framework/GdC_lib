/*
	Author: Sparfell

	Description:
	Main function for Zeus HICOM system. Generates ACE selfaction .

	Parameter(s):
		ARRAY of OBJECTS : zeus HICOM modules accessible for players (default=[])
		STRING (optionnal) : classname of the item the player must have in order to get the reports (default="itemmap")
		BOOL (optionnal) : if true the hicom will be executed if he kills another player (default=false)
		BOOL (optionnal) : if true, the attributes that can be modified through zeus are limited (default=true)

	Returns:
	nothing
	
	TODO :
	- nom des modules hicom dans la liste du menu
*/

params [
	["_zeusmodules",[],[[]]],
	["_itemcondition","itemmap",[""]],
	["_nohicomkill",false,[false]],
	["_limitcurator",true,[true]]
];
gdc_zeushicommodules = _zeusmodules;

// ACE actions
private _action = [
	"gdc_zeushicom_action",
	"High Command",
	"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestLeadership_ca.paa",
	{
		
	},
	{params ["_target","_player","_params"];({_x isKindOf [(_params #0),(configFile >> "CfgWeapons")] || {_x isKindOf (_params #0)}} count (items _player) > 0);},
	{
		params ["_target", "_player", "_params"];
		private _zeusmodules = _params #1;
		// Add children to this action
		private _actions = [];
		{
			private _icon = switch (getAssignedCuratorUnit _x) do {
				case _player: {"a3\ui_f\data\map\mapcontrol\taskIconFailed_ca.paa"};
				case objNull: {"a3\ui_f\data\map\mapcontrol\taskIconCreated_ca.paa"};
				default {if (alive (getAssignedCuratorUnit _x)) then {"a3\ui_f\data\map\mapcontrol\taskIconCanceled_ca.paa"} else {"a3\ui_f\data\map\mapcontrol\taskIconCreated_ca.paa"}};
			};
			private _playername = name (getAssignedCuratorUnit _x);
			if (_playername in ["Error: No vehicle",""]) then {_playername = "";} else {_playername = format [" (%1)",_playername];};
			private _zeusname = _x getVariable ["name",""];
			if (_zeusname in [""]) then {_zeusname = format ["Hicom %1",(_forEachIndex + 1)];};
			private _action = [
				(format ["gdc_zeushicom_%1_action",_x]),
				(format ["%1%2",_zeusname,_playername]),
				_icon,
				{
					params ["_target","_player","_params"];
					private _zeusmodule = _params #0;
					[_player,_zeusmodule] call gdc_fnc_assignzeushicom;
				},
				{true},
				{},
				[_x]
			] call ace_interact_menu_fnc_createAction;
			_actions pushBack [_action, [], _target]; // New action, it's children, and the action's target
		} forEach _zeusmodules;

		_actions
	},
	[_itemcondition,_zeusmodules]
] call ace_interact_menu_fnc_createAction;
[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

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
	} forEach ((playableUnits + switchableUnits) - (gdc_zeushicommodules apply {getAssignedCuratorUnit _x}));
};

//Curator limitations
if (_limitcurator) then {
	// attributes
	{
		[
			_x,
			"object",
			["UnitPos"]
		] call BIS_fnc_setCuratorAttributes;
		[
			_x,
			"group",
			["GroupID","Behaviour","Formation","SpeedMode","UnitPos"]
		] call BIS_fnc_setCuratorAttributes;
	} forEach _zeusmodules;
	if (isServer) then {
		[] spawn {
			waitUntil {time > 1};
			{
				// available addons
				removeAllCuratorAddons _x;
				_x addCuratorAddons ["ace_zeus","ace_zeus_captives"];
				[
					_x,
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
				] call BIS_fnc_curatorObjectRegisteredTable;
				// camera and editing area 
				_x addCuratorCameraArea [_foreachindex,[0,0,0],1];
				_x addCuratorEditingArea [_foreachindex,[0,0,0],1];
				_x setCuratorCameraAreaCeiling 1;
			} forEach gdc_zeushicommodules;
		};
	};
};

//Briefing stuff
if !(player diarySubjectExists "gdc_hicom") then {
	player createDiarySubject ["gdc_hicom","HICOM"];
};
private _txt = format ["<font size='20'>High Command :</font>
<br/><br/>Les joueurs qui possèdent un <font color='#FF0000'>%1</font> peuvent accéder au high command via le menu d'interaction sur soi de ACE.",
(gettext (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))];
player createDiaryRecord ["gdc_hicom", ["Accès HICOM",_txt,"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_requestLeadership_ca.paa"]];