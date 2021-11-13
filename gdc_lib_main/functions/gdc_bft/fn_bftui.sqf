/*
	Author: Sparfell

	Description:
	function that handle the dialog UI for gdc_bft

	Parameter(s):
		STRING : switch mode
		CONTROL : dialog's control

	Returns:
	nothing
*/

params [
	"_mode",
	"_control"
];

switch (_mode) do {
	case "list_type": {
		{
			private _index = _control lbAdd (gettext (configfile >> "CfgMarkers" >> _x >> "name"));
			_control lbSetPicture [_index,(gettext (configfile >> "CfgMarkers" >> _x >> "icon"))];
			_control lbSetData [_index,_x];
		} forEach ["b_inf","b_motor_inf","b_armor","b_mech_inf","b_air","b_plane","b_uav","b_art","b_naval","b_hq","b_med"];
		_control lbSetCurSel ((player getVariable ["gdc_bft_markertype",["b_unknown",0]]) #1);
	};
	case "list_color": {
		{
			private _index = _control lbAdd (gettext (configfile >> "CfgMarkerColors" >> (_x #0) >> "name"));
			_control lbSetPicture [_index,(gettext (configfile >> "CfgMarkers" >> "b_unknown" >> "icon"))];
			_control lbSetPictureColor [_index,(_x #1)];
			_control lbSetData [_index,(_x #0)];
		} forEach [["colorBLUFOR",[0,0.3,0.6,1]],["colorIndependent",[0,0.5,0,1]],["colorOPFOR",[0.5,0,0,1]],["colorCivilian",[0.4,0,0.5,1]]];
		_control lbSetCurSel ((player getVariable ["gdc_bft_markercolor",["colorBLUFOR",0]]) #1);
	};
	case "text_box": {
		_control ctrlSetText (player getVariable ["gdc_bft_markertext",(groupId (group player))]);
	};
	case "create_marker": {
		player setVariable ["gdc_bft_activated",true,true];
		player setVariable ["gdc_bft_markertext",(ctrlText 391),true];
		player setVariable ["gdc_bft_markertype",[(lbData [392,lbCurSel 392]),lbCurSel 392],true];
		player setVariable ["gdc_bft_markercolor",[(lbData [393,lbCurSel 393]),lbCurSel 393],true];
		closeDialog 1;
		hint "Marqueur BFT ajouté";
	};
	case "remove_marker": {
		player setVariable ["gdc_bft_activated",false,true];
		closeDialog 2;
		hint "Marqueur BFT supprimé";
	};
	default {};
};