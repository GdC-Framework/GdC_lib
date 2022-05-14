class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "A3_3DEN", "3DEN", "A3_UI_F"};
	};
};

class CfgFunctions
{
	class GDC
	{
		#include "functions\gdc_bft\index.hpp"
		#include "functions\gdc_choppa\index.hpp"
		#include "functions\gdc_extra\index.hpp"
		#include "functions\gdc_halo\index.hpp"
		#include "functions\gdc_lucy\index.hpp"
		#include "functions\gdc_mission_making\index.hpp"
		#include "functions\gdc_pluto\index.hpp"
		#include "functions\util\index.hpp"
		#include "functions\utilInternal\index.hpp"
	};

	#include "functions\gdc_gaia\index.hpp"
};

class ctrlMenuStrip;
class ctrlMenu;
class display3DEN
{
	class Controls
	{
		class MenuStrip: ctrlMenuStrip
		{
			class Items
			{
				class Attributes
				{
					items[] += {"GDC_AttributesCanardProof"};
				};
				class GDC_AttributesCanardProof
				{
					text = "Attributs mission CanardProof";
					picture = "\gdc_lib_main\data\gdc_icon_32.paa";
					action = "[] call GDC_fnc_3denSetGdCAttributes";
				};
				class Tools
				{
					items[] += {"GDC_Tools"};
				};
				class GDC_Tools
				{
					text = "Outils GDC";
					picture = "\gdc_lib_main\data\gdc_icon_32.paa";
					items[] = {"GDC_spawnHC","GDC_spawnEndTrigger"};
				};
				class GDC_spawnHC
				{
					text = "Creer le HC";
					action = "[] call GDC_fnc_3denCreateHCSlot";
				};
				class GDC_spawnEndTrigger
				{
					text = "Creer trigger radio fin de mission";
					action = "[] call GDC_fnc_3denCreateEndTrigger";
				};
			};
		};
	};
	class ContextMenu: ctrlMenu
	{
		class Items
		{
			class Log
			{
				items[] += {"GDC_exportMultiplePosAslDir","STDR_exportMultiplePosAgls","STDR_exportMultiplePosAgl0","STDR_exportMultipleClasses"};
			};
			class GDC_exportMultiplePosAslDir
			{
				text = "Exporter position(s) ASL [_x,_y,_z,_dir]";
				action = "[(get3DENSelected ""object""),0] call GDC_fnc_3denExportMultiplePos;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class STDR_exportMultiplePosAgls
			{
				text = "Exporter position(s) [_x,_y,_z]";
				action = "[(get3DENSelected ""object""),1] call GDC_fnc_3denExportMultiplePos;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class STDR_exportMultiplePosAgl0
			{
				text = "Exporter position(s) [_x,_y,0]";
				action = "[(get3DENSelected ""object""),2] call GDC_fnc_3denExportMultiplePos;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class STDR_exportMultipleClasses
			{
				text = "Exporter classnames [""_class"",""_class"",etc]";
				action = "[(get3DENSelected ""object"")] call GDC_fnc_3denExportMultipleClasses;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class Edit
			{
				items[] += {"GDC_medical","GDC_radio"};
			};
			class GDC_medical
			{
				text = "GDC stuff médical";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
				items[] = {"GDC_FillMedicalBackpack","GDC_FillHeavyMedicalBackpack"};
			};
			class GDC_FillMedicalBackpack
			{
				text = "Sac à dos médical standard";
				action = "[(get3DENSelected ""object""), false] call GDC_fnc_3denFillMedicalBackpack;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class GDC_FillHeavyMedicalBackpack
			{
				text = "Sac à dos médical lourd";
				action = "[(get3DENSelected ""object""), true] call GDC_fnc_3denFillMedicalBackpack;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class GDC_radio
			{
				text = "GDC stuff de base";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
				items[] = {"GDC_FillBasicItemsRadio","GDC_FillBasicItems"};
			};
			class GDC_FillBasicItemsRadio
			{
				text = "Équipement de base avec radio (uniforme)";
				action = "[(get3DENSelected ""object""), true] call GDC_fnc_3denFillBasicStuff;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
			class GDC_FillBasicItems
			{
				text = "Équipement de base sans radio (uniforme)";
				action = "[(get3DENSelected ""object""), false] call GDC_fnc_3denFillBasicStuff;";
				conditionShow = "selectedObject * hoverObject";
				picture = "\gdc_lib_main\data\gdc_icon_32.paa";
			};
		};
	};
};

class Cfg3DEN
{
	class Mission
	{
		class Scenario
		{
			class AttributeCategories
			{
				class GDC_MissionAttributes
				{
					displayName = "Attributs de mission GDC";
					class Attributes
					{
						class GDC_Inventory
						{
							property = "GDC_Inventory";
							displayName = "Inventaire Briefing";
							tooltip = "Afficher l'inventaire lors du briefing";
							control = "Checkbox";
							defaultValue = "false";
						};
						class GDC_Roster
						{
							property = "GDC_Roster";
							displayName = "Team Roster";
							tooltip = "Afficher la composition des équipes lors du briefing";
							control = "Checkbox";
							defaultValue = "false";
						};
						class GDC_DeleteSeagull
						{
							property = "GDC_DeleteSeagull";
							displayName = "Suppression de la mouette";
							tooltip = "Supprime la mouette créée quand un joueur devient spectateur";
							control = "Checkbox";
							defaultValue = "false";
						};
						class GDC_AcreSpectator
						{
							property = "GDC_AcreSpectator";
							displayName = "Spectateur ACRE";
							tooltip = "Active le mode spectateur de ACRE lorsque le joueur meurt et devient spectateur";
							control = "Checkbox";
							defaultValue = "false";
						};
						class GDC_AceDamage
						{
							property = "GDC_AceDamage";
							displayName = "Dégats ACE réduits";
							tooltip = "Réduit légèrement la létalité des munitions. Prévu uniquement pour les missions sans protections ballistiques utilisant ACE.";
							control = "Checkbox";
							defaultValue = "false";
						};
					};
				};
			};
		};
	};
};

#include "ui\index.hpp"
