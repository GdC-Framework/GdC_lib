//Filter control group
class gdc_MrkFilter_grp: RscControlsGroup
{
    idc = -1;
    onLoad = "uiNamespace setVariable ['grpMrkFilter', _this select 0];";
    show = false;
    x = safeZoneW + safeZoneX - (0.1765 * safezoneW);
    y = 0.032 * safezoneH + safezoneY;
    h = 0.206 * safezoneH;
    w = 0.176 * safezoneW;
    deletable = 0;
	fade = 0;

    class controls {
    
        class Backgrd: RscText
        {
            idc = -1;
            type = 0;
            style = 96;
            h = 0.206 * safezoneH;
            w = 0.176 * safezoneW;
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
            x = 0.035;
            y = 0.03;
            w = "0.075 * safezoneW";
            h = "0.015 * safezoneH";
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            sizeEx = 0.015 * safezoneH;
        };
        class lbl2: gdc_lbl
        {
            idc = 9902;
            text = "Marqueurs AAP"; 
            y = 0.13;
        };
        class lbl3: gdc_lbl
        {
            idc = -1;
            text = "Marqueurs de zone"; 
            y = 0.18;
        };
        class lbl4: gdc_lbl
        {
            idc = -1;
            text = "Marqueurs autres"; 
            y = 0.23;
        };
        class lbl5: gdc_lbl
        {
            idc = -1;
            text = "Tous les marqueurs joueurs";
            tooltip = "Affiche/masque tous les marqueurs posés par les joueurs";
            y = 0.315;
        };

        //box blufor
        class gdc_ColorBox: RscText
        {
            idc = -1;
            x = 0.212;
            y = 0.08;
            w = 1 * (((safezoneW / safezoneH) min 1.2) / 40);
            h = 1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
            colorBackground[] = {0,0.3,0.6,1};
        };
        //box opfor
        class gdc_ColorBox2: gdc_ColorBox
        {
            idc = -1;
            x = 0.262;
            colorBackground[] = {0.5,0,0,1};
        };
        //box guer
        class gdc_ColorBox3: gdc_ColorBox
        {
            idc = -1;
            x = 0.313;
            colorBackground[] = {0,0.5,0,1};
        };
        //box all
        class Bx69: RscText
        {
            idc = 2069;
            type = 0;
            style = 2;
            text = "Tous";
            x = 0.372;
            y = 0.08;
            w = 1 * (((safezoneW / safezoneH) min 1.2) / 40);
            h = 1 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
            colorText[] = {1,1,1,1};
            colorBackground[] = {-1,-1,-1,0};
            sizeEx = 0.015 * safezoneH;
        }; 

        //All MM Created markers
        class gdc_ChkBox: RscCheckbox 
        {
            idc = 99901;
            checked = 1;
            x = 0.21;
            y = 0.02;
            w = 1.2 * (((safezoneW / safezoneH) min 1.2) / 40);
            h = 1.2 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25);
            onLoad = "uiNamespace setVariable ['chkAllMM', _this select 0];['chkAllMM'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[['chkAAPBlufor','chkAAPOpfor','chkAAPGuer','chkAAPAll','chkZn','chkOther'], cbChecked (_this#0)] call gdc_fnc_setChkState;[tbMrkAllMM, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //APP Markers blufor
        class gdc_ChkBox2a: gdc_ChkBox
        {
            idc = 99902;
            x = 0.21;
            y = 0.12;
            onLoad = "uiNamespace setVariable ['chkAAPBlufor', _this select 0];['chkAAPBlufor'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPBlufor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //APP Markers opfor
        class gdc_ChkBox2b: gdc_ChkBox
        {
            idc = 99903;
            x = 0.26;
            y = 0.12;
            onLoad = "uiNamespace setVariable ['chkAAPOpfor', _this select 0];['chkAAPOpfor'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPOpfor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";   
        };
        //APP Markers guer
        class gdc_ChkBox2c: gdc_ChkBox
        {
            idc = 99904;
            x = 0.31;
            y = 0.12;
            onLoad = "uiNamespace setVariable ['chkAAPGuer', _this select 0];['chkAAPGuer'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPGuer, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //All APP Markers
        class gdc_ChkBox2d: gdc_ChkBox
        {
            idc = 99905;
            x = 0.37;
            y = 0.12;
            onLoad = "uiNamespace setVariable ['chkAAPAll', _this select 0];['chkAAPAll'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkAAPGuer, cbChecked (_this#0)] call gdc_fnc_filterMarker;[['chkAAPBlufor','chkAAPOpfor','chkAAPGuer'], cbChecked (_this#0) ] call gdc_fnc_setChkState;[tbMrkAAPBlufor, cbChecked (_this#0)] call gdc_fnc_filterMarker;[tbMrkAAPOpfor, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //Area markers           
        class gdc_ChkBox3: gdc_ChkBox
        {
            idc = 99906;
            x = 0.21;
            y = 0.17;
            onLoad = "uiNamespace setVariable ['chkZn', _this select 0];['chkZn'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkZn, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //Other markers        
        class gdc_ChkBox4: gdc_ChkBox
        {
            idc = 99907;
            x = 0.21;
            y = 0.22;
            onLoad = "uiNamespace setVariable ['chkOther', _this select 0];['chkOther'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkOther, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
        //All player created markers       
        class gdc_ChkBox5: gdc_ChkBox
        {
            idc = 99908;
            x = 0.21;
            y = 0.305;
            onLoad = "uiNamespace setVariable ['chkPlayer', _this select 0];['chkPlayer'] call gdc_fnc_restoreCtrlState";
            onCheckedChanged = "[tbMrkPlayer, cbChecked (_this#0)] call gdc_fnc_filterMarker;";
        };
    };
};