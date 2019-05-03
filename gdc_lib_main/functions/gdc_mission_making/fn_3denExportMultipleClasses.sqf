/*
 * Export classnames - The result is an array of strings exported to cliboard
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : ARRAY of STRING : the classes
*/
params ["_objects"];
private ["_classArray","_pos"];

_classArray = []; 
{
	_classArray = _classArray + [typeOf _x];
} forEach _objects;

copyToClipboard str _classArray;
_classArray;