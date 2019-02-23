class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "A3_3DEN","3DEN"};
	};
};

class CfgFunctions
{
	class GDC
	{
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
					action = "[] call GDC_fnc_3DENsetGdCAttributes";
				};
				class Tools
				{
					items[] += {"GDC_Tools"};
				};
				class GDC_Tools
				{
					text = "Outils GDC";
					picture = "\gdc_lib_main\data\gdc_icon_32.paa";
					items[] = {"GDC_spawnHC"};
				};
				class GDC_spawnHC
				{
					text = "Creer le HC";
					action = "[] call GDC_fnc_3DENcreateHCslot";
				};
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
					};
				};
			};
		};
	};
};


