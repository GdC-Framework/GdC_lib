/*
	Author: Mystery

	Description:
	Set Lucy parameters to a unit

	Parameter(s):
		0 : OBJECT - the unit
        1 : NUMBER - unit skill

	Returns:
	nothing
*/

params ["_unit_spawn", "_unit_skill"];
// Configure IA skill
if (_unit_skill != -1) then {
    _unit_spawn setSkill _unit_skill;
};
// Configure the fatigue
if (LUCY_IA_FATIGUE_DISABLED) then {
    _unit_spawn enableFatigue false;
};
// Configure Clean of bodies
if (LUCY_IA_CLEAN_BODIES) then {
    _unit_spawn addEventHandler ['killed',{[_this, LUCY_IA_CLEAN_BODIES_TIMER] spawn GDC_fnc_lucyAICleaner;}];
};
