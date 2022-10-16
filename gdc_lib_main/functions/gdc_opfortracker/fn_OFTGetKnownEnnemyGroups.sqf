/*
	Author: Sparfell

	Description: create a list of known ennemy groups

	Parameter(s):

	Returns:
	nothing
*/

private ["_unit","_side","_veh","_targetList","_targetPos","_targetSide","_target","_targetPosAcc","_range"];

// Update groups under the command of High command
_hicomGroupsList = [];
{
	private _hicomobjects = curatorEditableObjects _x;
	_hicomobjects = _hicomobjects + gdc_OFTotherUnits;
	{
		_hicomGroupsList pushBackUnique (group _x);
	} forEach (_hicomobjects select {alive _x});
} forEach gdc_OFTzeusModules;

// clear target list
gdc_OFTtargetsList = [];

// while on all groups under hicom control
{
	_unit = leader _x;
	_unitside = side _unit;
	_veh = vehicle _unit;
	_range = switch true do {
		case (_veh isKindOf "Man"): {1500};
		case (_veh isKindOf "Air"): {3000};
		default {2000}; //"LandVehicle"
	};
	// while on all target in group's vicinity
	_targetList = _unit nearTargets _range;
	{
		_x params ["_targetPos","","_targetSide","","_target","_targetPosAcc"];
		// target should not be HC, not already in the list, not friendly and real
		if ((_target != HC_Slot) && !(_target in gdc_OFTtargetsList) && (_targetSide != _unitside) && ((_unitside getFriend _targetSide) < 0.6) && (_target iskindof "AllVehicles")) then {
			// check if target is alive and well know and not captive
			if ((alive _target) && ((_unit knowsAbout _target) > 1.5) && (_targetPosAcc < 20) && (!captive _target)) then {
				gdc_OFTtargetsList = gdc_OFTtargetsList + [[_target,_unit]]; // add target in list
			};
		};
	} forEach _targetList;
} forEach _hicomGroupsList;

if (gdc_OFTDebug) then {systemChat format ["%1 ennemy detected",count gdc_OFTtargetsList];};