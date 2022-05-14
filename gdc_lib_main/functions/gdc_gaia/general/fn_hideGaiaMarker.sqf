
// To be called in initClient.sqf
// GDC_Gaia_fnc_hideGaiaMarker
{
	if(["gaia_", _x] call GDC_fnc_StringStartWith) then {
		_x setmarkerAlpha 0;
	};
} foreach allMapMarkers;
