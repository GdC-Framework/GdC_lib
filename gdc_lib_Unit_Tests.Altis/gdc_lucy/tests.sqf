
systemChat 'Lucy tests';
_success = true;

//////////////////////////
// GDC_fnc_lucyGroupRandomPatrol


{	
	// Delete all waypoints
	while {(count (waypoints lucyGroup)) > 0} do {
		deleteWaypoint ((waypoints lucyGroup) select 0);
	};

	_area = _x select 0;
	_blacklist = _x select 1;
	[lucyGroup, _area, nil, _blacklist] call GDC_fnc_lucyGroupRandomPatrol;


	_good = true;
	{
		_pos = waypointPosition [lucyGroup, _forEachIndex];
		if(!(_pos inArea _area) || (_pos inArea _blacklist)) then {
			_good = false;
		}
	} forEach (waypoints lucyGroup);

	if( !_good ) then {
		systemChat format (["%1 GDC_fnc_lucyGroupRandomPatrol generate wrong waypoint with test number ", _forEachIndex]);
		_success = false;
	};

} foreach [
	['mkr_lucy_spawn_zone_whitelist', 'mkr_lucy_spawn_zone_blacklist']
];

//////////////////////////
// GDC_fnc_fn_lucyGroupRandomPatrolFixPoints
{	
	// Delete all waypoints
	while {(count (waypoints lucyGroup)) > 0} do {
		deleteWaypoint ((waypoints lucyGroup) select 0);
	};

	_area = _x select 2;
	_blacklist = _x select 3;
	[lucyGroup, _area, 5, nil, _blacklist] call GDC_fnc_lucyGroupRandomPatrolFixPoints;

	_good = true;
	{
		_pos = waypointPosition [lucyGroup, _forEachIndex];
		if(!(_pos inArea _area) || (_pos inArea _blacklist)) then {
			_good = false;
		}
	} forEach (waypoints lucyGroup);

	if( !_good ) then {
		systemChat format (["%1 GDC_fnc_lucyGroupRandomPatrolFixPoints generate wrong waypoint with test number ", _forEachIndex]);
		_success = false;
	};

} foreach [
	['mkr_lucy_spawn_zone_whitelist', 'mkr_lucy_spawn_zone_blacklist', 'mkr_lucy_spawn_zone_whitelist', 'mkr_lucy_spawn_zone_blacklist'],
	[['mkr_lucy_spawn_zone_whitelist'], ['mkr_lucy_spawn_zone_blacklist'], 'mkr_lucy_spawn_zone_whitelist', 'mkr_lucy_spawn_zone_blacklist']
];




if(_success) then {
	systemChat 'Lucy tests: END with SUCCESS';
} else {
	systemChat 'Lucy tests: END and FAIL';
};
