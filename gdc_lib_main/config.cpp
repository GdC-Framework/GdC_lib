class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {"GDC_moduleGdc"};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F", "A3_Modules_F", "CBA_settings"};
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
					action = "set3DENMissionAttributes [['Multiplayer','respawn',1],['Scenario','EnableDebugConsole',1],['Multiplayer','RespawnTemplates',['EndMission','Spectator']]];";
				};
				class Tools
				{
					items[] += {"GDC_Tools"};
				};
				class GDC_Tools
				{
					text = "Outils GDC";
					picture = "\gdc_lib_main\data\gdc_icon_32.paa";
					items[] = {"GDC_spawnHC","GDC_spawnModule"};
				};
				class GDC_spawnHC
				{
					text = "Creer le HC";
					action = "if (({(_x get3DENAttribute 'Name') select 0 == 'HC_Slot' } count (all3DENEntities #3)) < 1) then {_hc = create3DENEntity ['Logic', 'HeadlessClient_F', screenToWorld [0.5,0.5]];	_hc set3DENAttribute ['ControlMP',true];_hc set3DENAttribute ['ControlSP',false];_hc set3DENAttribute ['Description','HC_Slot'];_hc set3DENAttribute ['Name','HC_Slot'];};";
				};
				class GDC_spawnModule
				{
					text = "Creer le module COOP CanardProof";
					action = "if (({ typeOf _x == 'GDC_ModuleGdc' } count (all3DENEntities #3)) < 1) then {create3DENEntity ['Logic', 'GDC_ModuleGdc', screenToWorld [0.45,0.45]];};";
				};
			};
		};
	};
};


