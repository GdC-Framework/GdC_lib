class gdc_bft_display
{
	idd = 390;
	class ControlsBackground
	{
		class gdc_bft_Background: RscText
		{
			idc = -1;
			x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y;
			w = 20 * GUI_GRID_CENTER_W;
			h = 17 * GUI_GRID_CENTER_H;
			colorBackground[] = {0,0,0,0.8};
		};
		class gdc_bft_titleMarkerText: RscText
		{
			idc = -1;
			x = GUI_GRID_CENTER_X + 11 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 0 * GUI_GRID_CENTER_H;
			w = 18 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			text = "Texte du marqueur :";
		};
		class gdc_bft_titleMarkerType: gdc_bft_titleMarkerText
		{
			idc = -1;
			y = GUI_GRID_CENTER_Y + 4 * GUI_GRID_CENTER_H;
			text = "Icône du marqueur :";
		};
		class gdc_bft_titleMarkerColor: gdc_bft_titleMarkerText
		{
			idc = -1;
			y = GUI_GRID_CENTER_Y + 8 * GUI_GRID_CENTER_H;
			text = "Couleur du marqueur :";
		};
	};
	class Controls
	{
		class gdc_bft_EditMarkerText: RscEdit
		{
			idc = 391;
			x = GUI_GRID_CENTER_X + 11 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 2 * GUI_GRID_CENTER_H;
			w = 18 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLoad = "params ['_control'];['text_box',_control] call GDC_fnc_bftui;";
		};
		class gdc_bft_ComboListMarkerType: RscCombo
		{
			idc = 392;
			x = GUI_GRID_CENTER_X + 11 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 6 * GUI_GRID_CENTER_H;
			w = 18 * GUI_GRID_CENTER_W;
			h = 2 * GUI_GRID_CENTER_H;
			onLoad = "params ['_control'];['list_type',_control] call GDC_fnc_bftui;";
		};
		class gdc_bft_ComboListMarkerColor: gdc_bft_ComboListMarkerType
		{
			idc = 393;
			y = GUI_GRID_CENTER_Y + 10 * GUI_GRID_CENTER_H;
			onLoad = "params ['_control'];['list_color',_control] call GDC_fnc_bftui;";
		};
		class gdc_bft_ButtonCreateMarker: RscButton
		{
			idc = -1;
			text = "Créer/modifier mon marqueur";
			onButtonClick = "params ['_control'];['create_marker',_control] call GDC_fnc_bftui;";
			x = GUI_GRID_CENTER_X + 11 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 14 * GUI_GRID_CENTER_H;
			w = 18 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
		};
		class gdc_bft_ButtonRemoveMarker: gdc_bft_ButtonCreateMarker
		{
			idc = -1;
			text = "Supprimer mon marqueur";
			onButtonClick = "params ['_control'];['remove_marker',_control] call GDC_fnc_bftui;";
			y = GUI_GRID_CENTER_Y + 15.5 * GUI_GRID_CENTER_H;
		};
	};
};