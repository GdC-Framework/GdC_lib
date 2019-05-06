/*
	Author: Shinriel

	Description:
		To string the expression, and remove the brackets to be able to recompile it.

	Parameter(s):
		0 : CODE - Code to convert

	Returns:
		string: Code converted as string.
*/

private["_functionString", "_functionArray", "_startIndex", "_endIndex"];

_functionString = str _function;

// Remove the brackets to convert it as string
_startIndex = _functionString find "{";
// Recalculate by ignoring the caracter
_startIndex = _startIndex + 1;

// Reverse the string to find the LAST }
_functionArray = toArray _functionString;
reverse _functionArray;
_endIndex = (toString _functionArray) find "}";
// Recalculate the index, to know how many caracters we still get.
// -1 to ignore the last }
_endIndex = count _functionString - _endIndex - _startIndex - 1;

_functionString select [_startIndex, _endIndex];
