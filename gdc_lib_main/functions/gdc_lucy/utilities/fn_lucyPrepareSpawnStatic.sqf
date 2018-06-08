/*
	Author: Shinriel

	Description:
	Use in the debug console in the editor to generate in your clipboard all unit and type of the selected units.
	Very useful to spawn unit with fn_lucySpawnStaticInf

    ["CUP_I_GUE_Soldier_AKM", [[10656.8,2423.74,5.99855,240.725]], east] call GDC_fnc_lucySpawnStaticInf;
    ["CUP_I_GUE_Soldier_MG", [[10043.4,2070.73,6.0013,71.0722]], east] call GDC_fnc_lucySpawnStaticInf;
    ["CUP_I_GUE_Sniper", [[10415.1,2366.27,10.75,193.479]], east] call GDC_fnc_lucySpawnStaticInf;


	Parameter(s):
    None

	Returns:
	nothing
*/

private ["_br", "_pos_by_unit"];

_br = toString [13,10];
_pos_by_unit = [];
{ 
	_veh = _x; 
	_pos = getPosASL _veh;
	_pos_dir = [_pos select 0, _pos select 1, _pos select 2, getDir _veh]; 
	_class = typeOf _veh;
	_side = side _veh;
	_pos_by_unit find _class;

	_pos_by_unit = _pos_by_unit + [str ([_class, [_pos_dir], _side]) + " call GDC_fnc_lucySpawnStaticInf;"];
	_pos_by_unit = _pos_by_unit + [_br];

} foreach (get3DENSelected "object");

copyToClipboard str composeText _pos_by_unit;

