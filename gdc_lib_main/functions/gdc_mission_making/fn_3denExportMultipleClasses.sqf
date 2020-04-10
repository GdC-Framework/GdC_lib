/*
 * Export classnames - The result is an array of strings exported to cliboard
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : ARRAY of STRING : the classes
*/
params ["_objects"];
private ["_output","_pos"];

_output = []; 
{
	_output = _output + [typeOf _x];
} forEach _objects;

copyToClipboard str _output;
systemChat (format ["%1 classname(s) copié(s) dans le presse papier.",(count _objects)]);
_output;