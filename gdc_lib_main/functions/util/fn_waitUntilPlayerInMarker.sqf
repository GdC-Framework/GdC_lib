/*
	Description:
		Preset for a waitUntil, usesful to create a trigger that wait for players on a marker

		To be call from only one source. You could call it from HC ou server for example.

		[] spawn {
			["_mkr_objective_1"] call GDC_fnc_waitUntilPlayerInMarker;
			// Do what you want, when player are in the area
		};

	Parameter(s):
		0 : STRING - Marker area where the player have to go
		1 : (OPTIONAL) NUMBER - Time to wait between 2 checks

	Returns:
		Nothing
*/

params ['_marker', ['_wait', 5]];
private ['_all_players'];

if (isMultiplayer) then {
	_all_players = playableUnits;
} else {
	_all_players = switchableUnits;
};

waitUntil { 
	sleep _wait;
	// Check isPlayer, because can be a ia playable, but not a player for now
	// But the playable unit, could become player ;)
	({alive _x && isPlayer _x && _x inArea _marker} count _all_players) > 0
};
