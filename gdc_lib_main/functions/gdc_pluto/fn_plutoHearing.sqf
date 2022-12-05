/**
 * @brief Clean AI's ears with delicacy adding a grain of qalt.
 *
 * @returns {int} - MissionEventHanler ID.
 * @author Migoyan
 */
[
	"CAManBase",
	"FiredMan",
	{
		if (_unit getVariable ["pluto_lastShot", 0] < time + 2) exitWith {}; // We don't the event to fire too often
		if (_weapon isEqualTo "Put" || _weapon isEqualTo "Throw") exitwith {}; // We filter grenades out

		_unit setVariable ["pluto_lastShot", time];
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
		private _silencer = _unit weaponAccessories _muzzle param [0, ""];
		private _suppressed = (_silencer isNotEqualTo "") && {
			getNumber(configFile >> "CfgWeapons" >> _silencer >> "ItemInfo" >> "AmmoCoef" >> "audibleFire") < 1
		};
		private _distance = gdc_hearingRanges select _suppressed;

		{
			// nearEntities doesn't returns units inside vehicles, entities does but doesn't have radius argument.
			// We got bohemia trolled
			if (_x isKindOf "CAManBase") then {
				_x reveal [
					_unit,
					(_x knowsAbout _unit) + linearConversion [0, _distance, _x distance _units, .35, .15]
				];
			} else {
				crew _x apply {
					_x reveal [
						_unit,
						(_x knowsAbout _unit) + linearConversion [0, _distance, _x distance _units, .35, .15]
					];
				}
			};
		} forEach (_unit nearEntities [
			["CAManBase", "Car", "StaticWeapon", "Helicopter", "Ship"],
			_distance
		]);
	}
] call CBA_fnc_addClassEventHandler;

