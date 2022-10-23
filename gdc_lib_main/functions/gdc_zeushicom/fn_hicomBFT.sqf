/*
	Author: Morbakos & Sparfell

	Description:
	BFT (Blue Force Tracker) system for HICOM.

	Parameter(s):
		STRING (optionnal) : classname of the item that should be in player's inventory in order to see BFT markers (default="itemmap")
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
	["_interval",5,[5]]
];
if (isDedicated) exitwith {};

if (isnil "gdc_bfthicom_eh") then {
	gdc_bfthicom_eh = [{
		(_this select 0) params ["_unit","_itemcondition"];

		{
			deleteMarkerLocal _x;
		} forEach (allMapMarkers select {"gdc_bfthicom_" in _x});
		
		if ({_x isKindOf [_itemcondition,(configFile >> "CfgWeapons")] || {_x isKindOf _itemcondition}} count (items _unit) > 0) then {
			private _hicomGroupsList = [];
			{
				private _hicomobjects = synchronizedObjects _x;
				{
					_hicomGroupsList pushBackUnique (group _x);
				} forEach (_hicomobjects select {(alive _x) && (_x isKindOf "AllVehicles")});
			} forEach gdc_zeushicomlogics;
			{
				private _object = leader _x;
				private _markerText = _object getVariable ["gdc_bft_markertext",(if (_object isKindOf "Man") then {groupId (group _object)} else {gettext (configfile >> "CfgVehicles" >> (typeOf _object) >> "displayname")})];
				private _markerType = (_object getVariable ["gdc_bft_markertype",[([group _object] call ace_common_fnc_getMarkerType),0]]) #0;
				private _markerColor = (_object getVariable ["gdc_bft_markercolor",["colorBLUFOR",0]]) #0;
				private _marker = createMarkerLocal [format ["gdc_bfthicom_%1", _object], getPos _object];
				_marker setMarkerTextLocal _markerText;
				_marker setMarkerTypeLocal _markerType;
				_marker setMarkerColorLocal _markerColor;
			} forEach _hicomGroupsList;
		};
	},_interval,[player,_itemcondition]] call CBA_fnc_addPerFrameHandler;
};