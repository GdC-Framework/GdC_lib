/*
	Author: Sparfell

	Description: marker visual ping

	Parameter(s):
		- STRING - marker

	Returns:
	nothing
*/
params [
	["_mk","",[""]]
];

private _pos = markerPos _mk;
_mk = createMarkerLocal [(format ["mk_ping_%1_%2",_pos,time]),_pos];
_mk setMarkerShapeLocal "ELLIPSE";
_mk setMarkerBrushLocal "Border";
_mk setMarkerColorLocal gdc_OFTMkColor;
_mk setMarkerSizeLocal [1,1];

for "_i" from 1 to 100 do {
	private _size = markerSize _mk;
	_mk setMarkerSizeLocal [(_size #0) + _i,(_size #1) + _i];
	sleep 0.01;
};
deleteMarkerLocal _mk;
