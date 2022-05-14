/*
	Description:

	Check if the position passed is valid to update the marker's.

	Parameter(s):
		0 : STRING - name of the marker that will be moved, the marker defines the spawn position
		1 : ARRAY - position to check
		3 (Optional): STRING or ARRAY[string] - list of marker names or trigger names defining blacklisted areas (default: [])
		4 (Optional): NUMBER - 0: land only, 1: land and water, 2: water only (default: 1)
		7 (Optional): STRING or ARRAY[string] - area where the user can move the marker, if nothing passed, the whole map is allowed (default: [])

	Returns:
		BOOLEAN - Has changed the marker's position
*/

params [
	"_mk",
	"_pos",
	["_blist", [], [[]]],
	["_water", 1, [0]],
	["_wlist", [], [[]]]
];

_valid = true;

// Check if whilisted area, in other case the whole map is valid
if(count _wlist > 0) then {
	_valid = false;
	{
		if (_pos Inarea _x) then {
			_valid = true;
		};
	} forEach (_wlist);
};

if(_valid) then {
	// on check si la position choisie n'est pas dans les zones blacklistées
	{
		if (_pos Inarea _x) then {
			_valid = false;
		};
	} forEach (_blist);
};

// on check si la position choisie est sur l'eau ou pas en fonction du paramètre
if(_valid) then {
	if (_water != 1) then {
		switch _water do {
			case 0: {if (surfaceIsWater _pos) then {_valid = false};};
			case 2: {if !(surfaceIsWater _pos) then {_valid = false};};
			default {_valid = false};
		};
	};
};

// déplacement du marqueur
if (_valid) then {
	_mk setmarkerPos _pos;
};

_valid;
