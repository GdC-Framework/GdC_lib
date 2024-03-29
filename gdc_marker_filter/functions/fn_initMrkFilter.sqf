/*
	Initialize arrays for marker filter, MM created markers
*/

GDC_tbMrkAAPBlufor = [];
GDC_tbMrkAAPOpfor = [];
GDC_tbMrkAAPGuer = [];
GDC_tbMrkZn = [];
GDC_tbMrkOther = [];
GDC_tbMrkPlayer = [["_USER_DEFINED #fake",0]];
GDC_tbAllCtrl = ['chkAllMM','chkAAPBlufor','chkAAPOpfor','chkAAPGuer','chkAAPAll','chkZn','chkOther','chkPlayer'];

GDC_tbMrkAllMM = [allMapMarkers, { !("bis_fnc_moduleCoverMap" in _x) }] call BIS_fnc_conditionalSelect;

{
	private _mrkPrefix = [getMarkerType _x,0,1] call BIS_fnc_trimString;
	switch true do {
		//AAP BLUFOR markers
		case (_mrkPrefix isEqualTo "b_"): {
			GDC_tbMrkAAPBlufor pushBack [_x, markerAlpha _x];
		};
		//AAP OPFOR markers
		case (_mrkPrefix isEqualTo "o_"): {
			GDC_tbMrkAAPOpfor pushBack [_x, markerAlpha _x];
		};
		//AAP Guerria markers
		case (_mrkPrefix isEqualTo "n_"): {
			GDC_tbMrkAAPGuer pushBack [_x, markerAlpha _x];
		};
		//Area markers
		case (getMarkerType _x isEqualTo ""): {
			GDC_tbMrkZn pushBack [_x, markerAlpha _x];
		};
		//Exclude player created markers
		case ((_x select [0,15];) isEqualTo "_USER_DEFINED #"): {};
		//Other markers
		default {GDC_tbMrkOther pushBack [_x, markerAlpha _x]};
	};
} forEach _all_markers;

//Reset button status
_btn = uiNamespace getVariable "BtnMrkFilter";
_btn ctrlSetTextColor [1,1,1,1];
