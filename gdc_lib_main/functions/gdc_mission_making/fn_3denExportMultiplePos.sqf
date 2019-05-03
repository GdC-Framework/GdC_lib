/*
 * Export positions in ASL [x,y,z,dir] or AGLS [x,y,z] - The result is an array of array exported to cliboard
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 * 1 - NUMBER : export mode : 0=ASL [x,y,z,dir] ; 1=AGLS [x,y,z]
 *
 * Return : ARRAY of ARRAY : the positions
*/
params ["_objects","_mode"];
private ["_Posarray","_pos"];

_Posarray = []; 

if (_mode == 0) then {
	// ASL [x,y,z,dir]
	{
		_pos = getPosASL _x;
		_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
		_Posarray = _Posarray + [_pos];
	} foreach _objects;
} else {
	// AGLS [x,y,z]
	{
		_pos = getpos _x;
		_Posarray = _Posarray + [_pos];
	} foreach _objects;
};
copyToClipboard str _posArray;
systemChat (format ["%1 position(s) %2 copiée(s) dans le presse papier.",(count _objects),(if (_mode == 0) then {"ASL+DIR"} else {"AGLS"})]);
_posArray;