// See https://forums.bohemia.net/forums/topic/219480-pixel-grid-system-gui-sizeposition-immune-to-ui-scaling-and-resolution-how/

#include "\a3\3DEN\UI\macros.inc" //Eden Editor defines

//Defines for this GUI
#define WIDTH_VALUE 72 * GRID_W
#define HEIGHT_VALUE 47 * GRID_H
#define HORZ_RIGHT ( safeZoneX + safeZoneW )
#define ORIGIN_X  HORZ_RIGHT - WIDTH_VALUE
#define ORIGIN_Y  safezoneY	+ 7 * GRID_H

//Filter control group
class gdc_MrkFilter_grp: RscControlsGroup
{
    idc = -1;
    onLoad = "uiNamespace setVariable ['grpMrkFilter', _this select 0];";
    show = false;
    x = ORIGIN_X;
    y = ORIGIN_Y;
	w = WIDTH_VALUE;
	h = HEIGHT_VALUE;

    deletable = 0;
	fade = 0;

    class controls {
    
        class Backgrd: RscText
        {
            idc = -1;
            type = 0;
            style = 96;
            w = WIDTH_VALUE;
	        h = HEIGHT_VALUE;
            colorText[] = {1, 1, 1, 1};
            colorBackground[]={0,0,0,1};
            text = "";
        };

        class gdc_lbl: RscText
        {
            idc = -1;
            type = 0;
            style = 1;
            text = "Tous les marqueurs MM";
            tooltip = "Affiche/masque tous les marqueurs posés par le créateur de mission"; 
            x = 9 * GRID_W;
            y = 5 * GRID_H;
            w = 34 * GRID_W;
            h = 3 * GRID_H;
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            sizeEx = 0.015 * safezoneH;
        };
        class lbl2: gdc_lbl
        {
            idc = 9902;
            text = "Marqueurs AAP"; 
            y = 17 * GRID_H;
        };
        class lbl3: gdc_lbl
        {
            idc = -1;
            text = "Marqueurs de zone"; 
            y = 23 * GRID_H;
        };
        class lbl4: gdc_lbl
        {
            idc = -1;
            text = "Marqueurs autres"; 
            y = 29 * GRID_H;
        };
        class lbl5: gdc_lbl
        {
            idc = -1;
            text = "Tous les marqueurs joueurs";
            tooltip = "Affiche/masque tous les marqueurs posés par les joueurs";
            y = 37 * GRID_H;
        };

        //box blufor
        class gdc_ColorBox: RscText
        {
            idc = -1;
            x = 43 * GRID_W;
            y = 11 * GRID_H;
            w = 4 * GRID_W;
            h = 4 * GRID_H;
            colorBackground[] = {0,0.3,0.6,1};
        };
        //box opfor
        class gdc_ColorBox2: gdc_ColorBox
        {
            idc = -1;
            x = 49 * GRID_W;
            colorBackground[] = {0.5,0,0,1};
        };
        //box guer
        class gdc_ColorBox3: gdc_ColorBox
        {
            idc = -1;
            x = 55 * GRID_W;
            colorBackground[] = {0,0.5,0,1};
        };
        //box all
        class Bx69: RscText
        {
            idc = 2069;
            type = 0;
            style = 2;
            text = "Tous";
            x = 62 * GRID_W;
            w = 6 * GRID_W;
            y = 11 * GRID_H;
            colorText[] = {1,1,1,1};
            colorBackground[] = {-1,-1,-1,0};
            sizeEx = 0.015 * safezoneH;
        }; 

        //All MM Created markers
        class gdc_ChkBox: RscCheckbox 
        {
            idc = 99901;
            checked = 1;
            x = 42 * GRID_W;
            y = 3 * GRID_H;
            w = 1.2 * (((safezoneW / safezoneH) min 1.2) / 40);
            h = 1.2 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
            onLoad = "uiNamespace setVariable ['chkAllMM', _this select 0];['chkAllMM'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[['chkAAPBlufor','chkAAPOpfor','chkAAPGuer','chkAAPAll','chkZn','chkOther'], cbChecked (_this#0)] call gdc_fnc_setChkState;[tbMrkAllMM, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //APP Markers blufor
        class gdc_ChkBox2a: gdc_ChkBox
        {
            idc = 99902;
            x = 42 * GRID_W;
            y = 15 * GRID_H;
            onLoad = "uiNamespace setVariable ['chkAAPBlufor', _this select 0];['chkAAPBlufor'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPBlufor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //APP Markers opfor
        class gdc_ChkBox2b: gdc_ChkBox2a
        {
            idc = 99903;
            x = 48 * GRID_W;
            onLoad = "uiNamespace setVariable ['chkAAPOpfor', _this select 0];['chkAAPOpfor'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPOpfor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";   
        };
        //APP Markers guer
        class gdc_ChkBox2c: gdc_ChkBox2a
        {
            idc = 99904;
            x = 54 * GRID_W;
            onLoad = "uiNamespace setVariable ['chkAAPGuer', _this select 0];['chkAAPGuer'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPGuer, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //All APP Markers
        class gdc_ChkBox2d: gdc_ChkBox2a
        {
            idc = 99905;
            x = 62 * GRID_W;
            onLoad = "uiNamespace setVariable ['chkAAPAll', _this select 0];['chkAAPAll'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPGuer, cbChecked (_this#0)] call gdc_fnc_filterMarker;[['chkAAPBlufor','chkAAPOpfor','chkAAPGuer'], cbChecked (_this#0) ] call gdc_fnc_setChkState;[tbMrkAAPBlufor, cbChecked (_this#0)] call gdc_fnc_filterMarker;[tbMrkAAPOpfor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //Area markers           
        class gdc_ChkBox3: gdc_ChkBox
        {
            idc = 99906;
            x = 42 * GRID_W;
            y = 21 * GRID_H;
            onLoad = "uiNamespace setVariable ['chkZn', _this select 0];['chkZn'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkZn, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //Other markers        
        class gdc_ChkBox4: gdc_ChkBox
        {
            idc = 99907;
            y = 27 * GRID_H;
            onLoad = "uiNamespace setVariable ['chkOther', _this select 0];['chkOther'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkOther, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //All player created markers       
        class gdc_ChkBox5: gdc_ChkBox
        {
            idc = 99908;
            y = 35 * GRID_H;
            onLoad = "uiNamespace setVariable ['chkPlayer', _this select 0];['chkPlayer'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkPlayer, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
    };
};