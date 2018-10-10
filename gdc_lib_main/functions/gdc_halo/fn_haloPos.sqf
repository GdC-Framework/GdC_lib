/*
	Author: Sparfell

	Description:
	Function for gdc_halo, player place Drop zone on map

	Parameter(s):
		none

	Returns:
	nothing
*/

gdc_halo_dispo = false;
publicVariable "gdc_halo_dispo";

if (gdc_halo_dzpos in [[0,0,0]]) then {
// Choix de la DZ
	hint "Ouvrez votre map et cliquez à l'endroit désiré pour désigner la DZ";
	onMapSingleClick {
		_valid = true;
		{
			if (_pos Inarea _x) then {
				_valid = false;
			};
		} forEach gdc_halo_blist;
		if (_valid) then {
			hint "";
			if ("mk_gdc_halo" in allMapMarkers) then {
				"mk_gdc_halo" setMarkerPos _pos;
			} else {
				createMarker ["mk_gdc_halo",_pos];
				"mk_gdc_halo" setMarkerType "mil_end";
				"mk_gdc_halo" setMarkerColor "colorBLUFOR";
			};
			[[]] remoteExec ["GDC_fnc_haloPlayer",0];
			[[],GDC_fnc_haloServer] remoteExec ["spawn",2];
			onMapSingleClick "";
		};
	};	
} else {
// Pas de choix de la DZ, DZ imposée
	[[]] remoteExec ["GDC_fnc_haloPlayer",0];
	[[],GDC_fnc_haloServer] remoteExec ["spawn",2];
};