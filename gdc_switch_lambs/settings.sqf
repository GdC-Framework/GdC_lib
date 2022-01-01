#include "script_component.hpp"
gdc_ModSettingName = "Grèce de canards";
gdc_category = "Switch LAMBS";
gdc_swLambsSettingSwitch = "Désactiver Lambs Danger FSM";
gdc_swLambsSettingSwitch_Tooltip = "Lambs Danger FSM est un mod qui améliore les réactions des IA. Ne l'activer que si vous savez ce que vous faites !";

_ret = [
    "gdc_disableLambs",
    "CHECKBOX",
    [gdc_swLambsSettingSwitch, gdc_swLambsSettingSwitch_Tooltip],
    [GDC_ModSettingName, gdc_category],
    true,
    0
] call CBA_fnc_addSetting;

diag_log text format ["[gdc_switch_lambs] gdc_disableLambs setting value : %1", str gdc_disableLambs];
