/*
	Author: Mystery

	Description:
	Return a random formation group string

	Parameter(s):
    None

	Returns:
	nothing
*/

private ["_rand_formation"];

_rand_formation = ["COLUMN", "STAG COLUMN", "WEDGE", "ECH LEFT", "ECH RIGHT", "VEE", "LINE", "FILE", "DIAMOND"] call BIS_fnc_selectRandom;
_rand_formation;
