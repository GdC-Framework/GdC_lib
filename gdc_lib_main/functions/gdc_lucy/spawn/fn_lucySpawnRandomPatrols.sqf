/**
 * @brief Fully randomized spawns and group size of patrols inside given positions using Lucy. Randomize loadouts inside <*.sqf> loaded into Lucy
 * for complete randomization.
 *
 * @param {Array} _positions, elements can be Arrays, Objects, Groups, Locations and Strings. (see BIS_fnc_position).
 * @param {Array} [_blacklist = ["water"]], blacklisted position. (see BIS_fnc_position)
 * @param {Number} [_numbers = 10], number of patrol
 * @param {Arrays} [_size = [4, 8, 12]], Random sizes of patrols, [min,mid,max] Gaussian, max included.
 * @param {Side} [_side = east], side of patrols.
 * @param {String} [_classname = "O_Soldier_F"], Classname of units spawned.
 * @param {Array} [_patrol_params = ["MOVE", "UNCHANGED", "SAFE", "NO CHANGE", "COLUMN"]], parameters of the patrols. (see GDC_fnc_lucyGroupRandomPatrol)
 *
 * @returns {Array} - All groups spawned.
 * @author Migoyan
 */
params[
	["_positions", [], [[]]],
	["_blacklist", ["water"], [[]]],
	["_numbers", 10, [0]],
	["_size", [4, 8, 12], [[]], [3]],
	["_side", east, [east]],
	["_classname", "O_Soldier_F", [""]],
	["_patrol_params", ["MOVE", "UNCHANGED", "SAFE", "NO CHANGE", "COLUMN"], [[]]]
];

private['_template', '_groups'];

_groups = [];
for '_i' from 1 to _numbers do {
	_pos = [_positions, _blacklist] call BIS_fnc_randomPos;

	// Resize is better than pushback as it changes the size of the array once.
	_template = [];
	_template resize [(floor random (_size + 1)), _classname];

	_group = [_pos, _side, _template] call GDC_fnc_lucySpawnGroupInf;
	_groups pushBack _group;
	[_group, _positions, _patrol_params, _blacklist] call GDC_fnc_lucyGroupRandomPatrol;
};

_groups
