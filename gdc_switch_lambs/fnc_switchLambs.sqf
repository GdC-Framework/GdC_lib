#include "script_component.hpp"
diag_log text format ["[gdc_switchLambs] gdc_disableLambs value : %1", str gdc_disableLambs];

[
	"CAManBase",
	"init",
	{
		(_this select 0) setVariable ["lambs_danger_disableAI", gdc_disableLambs];
		diag_log text format ["[gdc_switchLambs] unit %1 - lambs_danger_disableAI set to %2", _this, str gdc_disableLambs];
	},
	true,
	[],
	true
] call CBA_fnc_addClassEventHandler;