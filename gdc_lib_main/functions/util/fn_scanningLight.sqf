/**
 * @brief Function designed to work with an occupied spotlight. unit will scan a
 * conic area. This function works only in a schedulded environment and where
 * the unit is local (return an error otherwise).
 *
 * @param {object} _spotlight, spotlight. (Should also work with the gunner)
 * @param {Number} [_distance_watch = 200], pointing distance of the spotlight
 * @param {Number} [_direction_watch = 0], cone azimut (taken at the center)
 * @param {Number} [_semi_angle_watch = 90], cone semi angle
 * @param {Number} [_step_sleep = .3], time sleep between each step
 * @param {Number} [_step = 1], step angle size in degree
 *
 * @author Migoyan
 *
 * @exemple you want your unit scanning toward north with a 60° cone at long
 * range, put this in the unit init :
 * if (local this) then {[this, 200, 0, 30] spawn GDC_fnc_scanningLight};
 *
 * @note When unit enters combat mode the scan is suspended and resume when
 * unit exit combat mode.
 */
params [
	'_spotlight',
	['_distance_watch', 200, [0]],
	['_direction_watch', 0, [0]],
	['_semi_angle_watch', 90, [0]],
	['_step_sleep', .3, [0]],
	['_step', 1, [0]]
];
private [
	'_behaviour', '_direction_trig_circle', '_gunner', '_left_angle',
	'_pos_gunner', '_pos_watch', '_pos_watch_temp', '_right_angle'
];

_gunner = gunner _spotlight;

_gunner action ["SearchlightOn", vehicle _gunner];
_gunner setBehaviour "SAFE";

if (!canSuspend) throw (
	"Error: cannot suspend context. Execute function in scheduled environnement"
);
if (! local _gunner) throw (
	"Error: unit is not local to the machine " + str(clientOwner)
);

// Variables for computing
_pos_gunner = position _gunner;
_pos_watch = [];
_pos_watch_temp = [];
// Trigonometric formulae consider 0° to be the x axis. In Arma it points to the
// y axis
_direction_trig_circle = _direction_watch - 90;

// Azimut rotate clockwize while trigonemy rotate anticlockwise -> minus added.
_left_angle = -(_direction_trig_circle - _semi_angle_watch);
_right_angle = -(_direction_trig_circle + _semi_angle_watch);

//----------------------------Computing scanned area----------------------------
// Executed only at the beginning

_pos_watch_temp = [
	[
		_pos_gunner#0 + _distance_watch*cos(_left_angle),
		_pos_gunner#1 + _distance_watch*sin(_left_angle)
	]
];
while {_left_angle > _right_angle}
do {
	_left_angle = _left_angle - _step; // Trigonometric rotation of _step°
	_pos_watch_temp pushBack [
		_pos_gunner#0 + _distance_watch*cos(_left_angle),
		_pos_gunner#1 + _distance_watch*sin(_left_angle)
	];
};
_pos_watch = +_pos_watch_temp;
reverse _pos_watch_temp;
_pos_watch append _pos_watch_temp;

//------------------------------Scanning area loop------------------------------
// Executed indefinitely and suspended on detection.

while { true }
do{
	{
		_behaviour = behaviour _gunner;
		if (_behaviour isEqualTo "COMBAT") then {
			waitUntil {
				_behaviour isNotEqualTo "COMBAT"
			};
		};
		_gunner doWatch _x;
		sleep _step_sleep;
	} forEach _pos_watch;
};
