/*
	Author: Morbakos & Sparfell

	Description:
	Main function for BFT (Blue Force Tracker) system. Generates ACE selfaction and the per frame handler that updates marker's positions.

	Parameter(s):
		STRING (optionnal) : classname of the item that should be in player's inventory in order to see and add BFT markers (default="itemmap")
		ARRAY of OBJECTS (optionnal) : list of objects that should have a marker attached even if they do not carry the item defined in the first parameter (default=[])
		NUMBER (optionnal) : time in seconds for refresh interval for markers' position (lower value may affect performances) (default=5)

	Returns:
	nothing

	Marker settings can be modified by hande using (this being vehicle/unit with a marker attached)
		this setVariable ["gdc_bft_markertext","mymarkertext"];
		this setVariable ["gdc_bft_markertype",["mymarkertype",0]];
		this setVariable ["gdc_bft_markercolor",["mymarkercolor",0]];
*/

params [
	["_itemcondition","itemmap",[""]],
	["_otherobjects",[],[[]]],
	["_interval",5,[5]]
];

private _action = [
	"gdc_bft_action",
	"BFT",
	"",
	{
		if (!dialog) then {createDialog "gdc_bft_display";};
	},
	{params ["_target","_player","_params"];(_params #0) in (items _player);},
	{},
	[_itemcondition]
] call ace_interact_menu_fnc_createAction;
[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

if (isnil "gdc_bft_eh") then {
	gdc_bft_eh = [{
		(_this select 0) params ["_unit","_itemcondition","_otherobjects"];

		{
			deleteMarkerLocal _x;
		} forEach (allMapMarkers select {"gdc_bft_" in _x});

		if (_itemcondition in (items _unit)) then {
			private _playerobjects = (playableUnits + switchableUnits) select {(_itemcondition in (items _x)) && (_x getvariable ["gdc_bft_activated",false]) && !(_x in _otherobjects)};
			{
				private _object = _x;
				if !((_object != vehicle _object) && ((vehicle _object) in _otherobjects)) then {
					private _markerText = _object getVariable ["gdc_bft_markertext",(if (_object isKindOf "Man") then {groupId (group _object)} else {gettext (configfile >> "CfgVehicles" >> (typeOf _object) >> "displayname")})];
					if (_object in _otherobjects) then {
						{
							_markerText = _markerText + " + " + (_x getVariable ["gdc_bft_markertext",(if (_object isKindOf "Man") then {groupId (group _object)} else {gettext (configfile >> "CfgVehicles" >> (typeOf _object) >> "displayname")})]);
						} forEach ((crew _object) arrayIntersect (_playerobjects + (_otherobjects select {_x != _object})));
					};
					private _markerType = (_object getVariable ["gdc_bft_markertype",[([group _object] call ace_common_fnc_getMarkerType),0]]) #0;
					private _markerColor = (_object getVariable ["gdc_bft_markercolor",["colorBLUFOR",0]]) #0;
					private _marker = createMarkerLocal [format ["gdc_bft_%1", _object], getPos _object];
					_marker setMarkerTextLocal _markerText;
					_marker setMarkerTypeLocal _markerType;
					_marker setMarkerColorLocal _markerColor;
				};
			} forEach (_playerobjects + _otherobjects) ;
		};
	},_interval,[player,_itemcondition,_otherobjects]] call CBA_fnc_addPerFrameHandler;
};

private _txt = format ["<font size='20'>Blue Force Tracker :</font>
<br/><br/>Les joueurs qui possèdent un <font color='#FF0000'>%1</font> peuvent ajouter un marqueur BFT au moyen de l'action disponible dans le menu d'interaction sur soi de ACE.
<br/><br/>Seuls les joueurs qui disposent d'un <font color='#FF0000'>%1</font> peuvent voir les marqueurs BFT.
<br/><br/><font size='15'>Légende :</font>",(gettext (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))];
{
	_txt = _txt + format ["<br/><img image='%1' width='32' height='32'/> %2",(gettext (configfile >> "CfgMarkers" >> _x >> "icon")),(gettext (configfile >> "CfgMarkers" >> _x >> "name"))];
} forEach ["b_inf","b_motor_inf","b_armor","b_mech_inf","b_air","b_plane","b_uav","b_art","b_naval","b_hq","b_med"];
player createDiarySubject ["gdc_bft","BFT"];
player createDiaryRecord ["gdc_bft", ["Instructions",_txt]];