/*
	Initialize arrays for marker filter, MM created markers
*/

tbMrkAAPBlufor = [];
tbMrkAAPOpfor = [];
tbMrkAAPGuer = [];
tbMrkZn = [];
tbMrkOther = [];
tbMrkPlayer = [["_USER_DEFINED #fake",0]];
tbAllCtrl = ['chkAllMM','chkAAPBlufor','chkAAPOpfor','chkAAPGuer','chkAAPAll','chkZn','chkOther','chkPlayer'];

{
	private _mrkPrefix = [getMarkerType _x,0,1] call BIS_fnc_trimString;
	switch true do {
		//AAP BLUFOR markers
		case (_mrkPrefix isEqualTo "b_"): {
			tbMrkAAPBlufor pushBack [_x, markerAlphaLocal _x];
		};
		//AAP OPFOR markers
		case (_mrkPrefix isEqualTo "o_"): {
			tbMrkAAPOpfor pushBack [_x, markerAlphaLocal _x];
		};
		//AAP Guerria markers
		case (_mrkPrefix isEqualTo "n_"): {
			tbMrkAAPGuer pushBack [_x, markerAlphaLocal _x];
		};
		//Area markers
		case (getMarkerType _x isEqualTo ""): {
			tbMrkZn pushBack [_x, markerAlphaLocal _x];
		};
		//Exclude player created markers
		case (([_x,0,14] call BIS_fnc_trimString) isEqualTo "_USER_DEFINED #"): {};
		//Other markers
		default {tbMrkOther pushBack [_x, markerAlphaLocal _x]};
	};
} forEach allMapMarkers;

tbMrkAllMM = tbMrkAAPBlufor + tbMrkAAPGuer + tbMrkAAPOpfor + tbMrkZn + tbMrkOther;

//Reset button status
_btn = uiNamespace getVariable "BtnMrkFilter";
_btn ctrlSetTextColor [1,1,1,1];
