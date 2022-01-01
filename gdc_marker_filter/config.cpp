class CfgPatches 
{
    class gdc_lib_main 
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
        requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "A3_3DEN", "3DEN", "A3_UI_F"};
    };
};

class CfgFunctions
{
	class gdc
	{
        #include "functions\index.hpp"
    };
};

#include "ui\base_classes.hpp"
#include "ui\gdc_btnMrkFilter.hpp"

// Ecran carte en jeu
class RscDisplayMainMap {
    //IDD 12
    // Ajoute le dialogue de filtre des marqueurs
    class controls {
        class gdc_btnMrkFilter1: gdc_btnMrkFilter 
        {
            	idc= -1;
                onButtonClick = "_ctrl = uiNameSpace getVariable 'grpMrkFilter';if !(ctrlShown _ctrl) then {_ctrl ctrlShow true} else {_ctrl ctrlShow false}";
                x = safeZoneW + safeZoneX - (0.020630 * safezoneW);
                y = safezoneY;
                text = "\GDC_mrkFilter\data\icon-filter.jpg";
                tooltip = "Filtrer les marqueurs";
                onLoad = "uiNamespace setVariable ['BtnMrkFilter', _this select 0];[] call GDC_fnc_restoreCtrlState";
        }
        #include "ui\gdc_ctrlMrkFilter.hpp"
    };
};

// BRIEFING SCREEN
class RscDisplayGetReady: RscDisplayMainMap {
    //IDD 37
    // Ajoute le dialogue de filtre des marqueurs
    class controls {
        class gdc_btnMrkFilter2: gdc_btnMrkFilter {
            idc= -1;
            onButtonClick = "_ctrl = uiNameSpace getVariable 'grpMrkFilter';if !(ctrlShown _ctrl) then {_ctrl ctrlShow true} else {_ctrl ctrlShow false}";
            x = safeZoneW + safeZoneX - (0.020630 * safezoneW);
            y = safezoneY;
            w = 0.020625 * safezoneW;
            onLoad = "uiNamespace setVariable ['BtnMrkFilter', _this select 0];[] call GDC_fnc_initMrkFilter;";
            onDestroy = "[tbAllCtrl] call gdc_fnc_saveCtrlstate";
        };
        #include "ui\gdc_ctrlMrkFilter.hpp"
    };
    
};

class RscDisplayClientGetReady: RscDisplayGetReady {
    //IDD 53
    // Ajoute le dialogue de filtre des marqueurs
    class controls {
        class gdc_btnMrkFilter2: gdc_btnMrkFilter {
            idc= -1;
            onButtonClick = "_ctrl = uiNameSpace getVariable 'grpMrkFilter';if !(ctrlShown _ctrl) then {_ctrl ctrlShow true} else {_ctrl ctrlShow false}";
            x = safeZoneW + safeZoneX - (0.020630 * safezoneW);
            y = safezoneY;
            w = 0.020625 * safezoneW;
            onLoad = "uiNamespace setVariable ['BtnMrkFilter', _this select 0];[] call GDC_fnc_initMrkFilter;";
            onDestroy = "[tbAllCtrl] call gdc_fnc_saveCtrlstate";
        };
        #include "ui\gdc_ctrlMrkFilter.hpp"
    };
};

class RscDisplayServerGetReady: RscDisplayGetReady {
    //IDD 52
    // Ajoute le dialogue de filtre des marqueurs
    class controls {
        class gdc_btnMrkFilter2: gdc_btnMrkFilter {
            idc= -1;
            onButtonClick = "_ctrl = uiNameSpace getVariable 'grpMrkFilter';if !(ctrlShown _ctrl) then {_ctrl ctrlShow true} else {_ctrl ctrlShow false}";
            x = safeZoneW + safeZoneX - (0.020630 * safezoneW);
            y = safezoneY;
            w = 0.020625 * safezoneW;
            onLoad = "uiNamespace setVariable ['BtnMrkFilter', _this select 0];[] call GDC_fnc_initMrkFilter;";
            onDestroy = "[tbAllCtrl] call gdc_fnc_saveCtrlstate";
        };
        #include "ui\gdc_ctrlMrkFilter.hpp"
    };
};
