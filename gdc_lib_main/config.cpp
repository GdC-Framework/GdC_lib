class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {"GDC_moduleGdc"};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "A3_3DEN","3DEN"};
	};
};

class CfgFactionClasses
{
	class Multiplayer;
	class GDC_moduleGdc: Multiplayer
	{
		displayName = "GDC modules";
	};
};

class CfgVehicles
{
	#include "gdc_mission_making\CfgVehicles.hpp"
};

class CfgFunctions
{
	class GDC
	{
		#include "functions\gdc_choppa\index.hpp"
		#include "functions\gdc_extra\index.hpp"
		#include "functions\gdc_halo\index.hpp"
		#include "functions\gdc_lucy\index.hpp"
		#include "gdc_mission_making\index.hpp"
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
					action = "set3DENMissionAttributes [['Multiplayer','respawn',1],['Scenario','EnableDebugConsole',1],['Multiplayer','RespawnTemplates',['EndMission','Spectator']],['Scenario','GDC_Inventory',1],['Scenario','GDC_Roster',1],['Scenario','GDC_DeleteSeagull',1],['Scenario','GDC_AcreSpectator',1]];";
				};
				class Tools
				{
					items[] += {"GDC_Tools"};
				};
				class GDC_Tools
				{
					text = "Outils GDC";
					picture = "\gdc_lib_main\data\gdc_icon_32.paa";
					//items[] = {"GDC_spawnHC","GDC_spawnModule"};
					items[] = {"GDC_spawnHC"};
				};
				class GDC_spawnHC
				{
					text = "Creer le HC";
					action = "if (({(_x get3DENAttribute 'Name') select 0 == 'HC_Slot' } count (all3DENEntities #3)) < 1) then {_hc = create3DENEntity ['Logic', 'HeadlessClient_F', screenToWorld [0.5,0.5]];	_hc set3DENAttribute ['ControlMP',true];_hc set3DENAttribute ['ControlSP',false];_hc set3DENAttribute ['Description','HC_Slot'];_hc set3DENAttribute ['Name','HC_Slot'];};";
				};
				/*
				class GDC_spawnModule
				{
					text = "Creer le module COOP CanardProof";
					action = "if (({ typeOf _x == 'GDC_ModuleGdc' } count (all3DENEntities #3)) < 1) then {create3DENEntity ['Logic', 'GDC_ModuleGdc', screenToWorld [0.45,0.45]];};";
				};
				*/
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
							control = "CheckboxNumber";
							value = 0;
							defaultValue = "0";
							expression = "if ((_value > 0) && !is3DEN ) then {remoteExecCall ['GDC_fnc_inventoryBriefing',0,false];};";
						};
						class GDC_Roster
						{
							property = "GDC_Roster";
							displayName = "Team Roster";
							tooltip = "Afficher la composition des équipes lors du briefing";
							control = "CheckboxNumber";
							value = 0;
							defaultValue = "0";
							expression = "if ((_value > 0) && !is3DEN ) then {remoteExecCall ['GDC_fnc_rosterBriefing',0,false];};";
						};
						class GDC_DeleteSeagull
						{
							property = "GDC_DeleteSeagull";
							displayName = "Suppression de la mouette";
							tooltip = "Supprime la mouette créée quand un joueur devient spectateur";
							control = "CheckboxNumber";
							value = 0;
							defaultValue = "0";
							expression = "if ((_value > 0) && !is3DEN ) then {remoteExecCall ['GDC_fnc_DeleteSeagull',0,false];};";
						};
						class GDC_AcreSpectator
						{
							property = "GDC_AcreSpectator";
							displayName = "Spectateur ACRE";
							tooltip = "Active le mode spectateur de ACRE lorsque le joueur meurt et devient spectateur";
							control = "CheckboxNumber";
							value = 0;
							defaultValue = "0";
							expression = "if ((_value > 0) && !is3DEN ) then {remoteExecCall ['GDC_fnc_AcreSpectator',0,false];};";
						};
					};
				};
			};
		};
	};
};


