/*
	Author: Shinriel

	Description:
	TO BE USED FROM EDEN!
	Use in the debug console in the editor to generate in your clipboard all units or objects, their type, their position and their azimute.

    ["CUP_I_GUE_Soldier_AKM", [56.8,23.74,5.99855], 240.725]
    ["CUP_I_GUE_Soldier_MG", [43.4,70.73,6.0013], 71.0722]
    ["billboard", [15.1,66.27,10.75], 193.479]


	To point the right object, you should debug this: "nearestobject screenToWorld getMousePosition;"
	And execute the method "call GDC_fnc_getPositionsFromReference"

	Parameter(s):
	nothing

	Returns:
	nothing
*/

private ["_br", "_pos_by_unit", "_reference"];

_reference = nearestobject screenToWorld getMousePosition;
_br = toString [13,10]; // \r\n
_pos_by_unit = [];
{
	_veh = _x;
	_type = typeOf _veh;
	_pos = _reference worldToModel (getposATL _veh);
	_azimute = getDir _veh;

	_pos_by_unit = _pos_by_unit + [str ([_type, [_pos], _azimute]) ];
	_pos_by_unit = _pos_by_unit + [_br]; // line break

} foreach (get3DENSelected "object");

copyToClipboard str composeText _pos_by_unit;
