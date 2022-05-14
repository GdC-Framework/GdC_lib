/*
 * Export positions in ASL [x,y,z,dir] or AGLS [x,y,z] - The result is an array of array exported to cliboard
 *
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 * 1 - NUMBER : export mode : 0=ASL [x,y,z,dir] ; 1=AGLS [x,y,z] ; 2=AGL [x,y,0]
 *
 * Return : ARRAY of ARRAY : the positions
*/
params ["_objects","_mode"];
private ["_output","_pos"];

_output = [];

switch (_mode) do {
	case 0 : { // ASL [x,y,z,dir]
		if ((count _objects) > 1) then {
			{
				_pos = getPosASL _x;
				_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
				_output = _output + [_pos];
			} foreach _objects;
		} else {
			_pos = getPosASL (_objects #0);
			_output = [(_pos #0),(_pos #1),(_pos #2),(getDir (_objects #0))];
		};
	};
	case 2 : {// AGL [x,y,0]
		if ((count _objects) > 1) then {
			{
				_pos = getpos _x;
				_pos = [(_pos #0),(_pos #1),0];
				_output = _output + [_pos];
			} foreach _objects;
		} else {
			_pos = getpos (_objects #0);
			_output = [(_pos #0),(_pos #1),0];
		};
	};
	case 1;// AGLS [x,y,z]
	default {
		if ((count _objects) > 1) then {
			{
				_pos = getpos _x;
				_output = _output + [_pos];
			} foreach _objects;
		} else {
			_output = getpos (_objects #0);
		};
	};
};

/*
if (_mode == 0) then {
	// ASL [x,y,z,dir]
	if ((count _objects) > 1) then {
		{
			_pos = getPosASL _x;
			_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
			_output = _output + [_pos];
		} foreach _objects;
	} else {
		_pos = getPosASL (_objects #0);
		_output = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
	};
} else {
	// AGLS [x,y,z]
	if ((count _objects) > 1) then {
		{
			_pos = getpos _x;
			_output = _output + [_pos];
		} foreach _objects;
	} else {
		_output = getpos (_objects #0);
	};
};
*/
copyToClipboard str _output;
systemChat (format ["%1 position(s) %2 copiée(s) dans le presse papier.",(count _objects),(if (_mode == 0) then {"ASL+DIR"} else {"AGL"})]);
_output;
