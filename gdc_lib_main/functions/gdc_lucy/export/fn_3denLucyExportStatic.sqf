/*
 * Exporter les unités statiques sélectionnée dans 3DEN pour LUCY
 * 
 * Parameters
 * 0 - ARRAY of objects : objects selected in 3DEN for instance
 *
 * Return : STRING : the text to past in your script
*/
params ["_objects"];
private ["_txt","_txtFinal","_br","_pos","_arraySides","_side","_arrayTypes","_type","_arrayPos"];

// Pour debug :
//_objects = (get3DENSelected "object");

_txt = "";
_txtFinal = "";
_br = toString [13,10];

_arraySides = [];
{
	_arraySides = _arraySides + [side _x];
} forEach _objects;
_arraySides = _arraySides arrayIntersect _arraySides;

{
	_side= _x;
	_arrayTypes = [];
	{
		_arrayTypes = _arrayTypes + [typeOf _x];
	} forEach (_objects select {(side _x) == _side});
	_arrayTypes = _arrayTypes arrayIntersect _arrayTypes;
	{
		_type = _x;
		_arrayPos = [];
		{
			_pos = getPosASL _x;
			_pos = [(_pos #0),(_pos #1),(_pos #2),(getDir _x)];
			_arrayPos = _arrayPos + [_pos];
		} forEach (_objects select {(typeOf _x) == _type});
		_txt = format ["[%1,%2,%3,""UP"",[""NOTHING""],-1,""""] call GDC_fnc_lucySpawnStaticInf;",(str _type),_arrayPos,_side];
		_txtFinal = _txtFinal + _br + _txt;
	} forEach _arrayTypes;
} forEach _arraySides;

copyToClipboard _txtFinal;
_txtFinal;
