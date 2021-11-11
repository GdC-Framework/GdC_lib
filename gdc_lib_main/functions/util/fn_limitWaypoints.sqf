/*
	Author: [GIE] Gavin "Morbakos" Sertix
	
	Description:
		Supprime les waypoints d'un groupe si il y en a plus que 25 (paramétrable)
	
	Parameter(s):
		Nothing 

	Returns:
		Nothing
*/

if(!isServer) exitWith {};

gdc_waypointsLimiter_run = true;
gdc_waypointsLimiter_maxWaypoints = 25; // Max waypoints remaining after deletion
gdc_waypointsLimiter_sleepDelay = 300; // in seconds

[] spawn {

	while {gdc_waypointsLimiter_run} do {
		{
			private _currentGroup = _x;
			private _waypoints = waypoints _currentGroup;
			_waypoints sort true; // a bit overkill ?
			private _waypointsCount = count _waypoints;

			if (_waypointsCount > gdc_waypointsLimiter_maxWaypoints) then {
				reverse _waypoints; // a bit overkill ?
				for "_i" from _waypointsCount to (gdc_waypointsLimiter_maxWaypoints-1) step -1 do {
					deleteWaypoint [_currentGroup, _i];
				}
			};

		} forEach allGroups select {!isPlayer(leader _x)};

		sleep gdc_waypointsLimiter_sleepDelay;
	};
}