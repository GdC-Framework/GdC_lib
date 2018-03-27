/*
	Author: Mystery

	Description:
	Return the nearest player of a position

	Parameter(s):
		0 : ARRAY - The position to test

	Returns:
	An array which contains: [Nearest player, distance]
*/

params["_arg_pos"];
private["_nearest_player", "_nearest_distance", "_current_distance", "_current_players"];

_arg_pos = _this select 0;

_nearest_distance = 1000000;     // 1000km max distance... you should find nearest player ;)
if (isMultiplayer) then {_current_players = playableUnits;} else {_current_players = switchableUnits;};

{
    _current_distance = _x distance _arg_pos;
    if (_current_distance < _nearest_distance) then {
        _nearest_player = _x;
        _nearest_distance = _current_distance;
    };
} forEach _current_players;

[_nearest_player, _nearest_distance];
