class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F"};
	};
};

class CfgFunctions
{
	class GDC
	{
		class gdc_choppa
		{
			file = "\gdc_lib_main\functions\gdc_choppa";
			class choppa
			{
				
			};
			class choppaCall
			{
				
			};
		};
        class gdc_extra
		{
			file = "\gdc_lib_main\functions\gdc_extra";
			class extra
			{
				
			};
			class extraCall
			{
				
			};
			class extraCancel
			{
				
			};
		};
		class gdc_halo
		{
			file = "\gdc_lib_main\functions\gdc_halo";
			class halo
			{
				
			};
			class haloPos
			{
				
			};
			class haloPlayer
			{
				
			};
			class haloServer
			{
				
			};
		};
		class lucy
        {
			file = "gdc_lib_main\functions\gdc_lucy";
			class lucyInit {};
			class lucyExecVMHC {};
            class lucyConfigLoadoutIA {};
        };
        class lucyMoves
        {
            file = "gdc_lib_main\functions\gdc_lucy\moves";
            class lucyAddWaypoint {};
            class lucyAddWaypointListMoveCycle {};
            class lucyGroupRandomPatrol {};
            class lucyGroupRandomPatrolFixPoints {};
        };
        class lucySpawn
        {
            file = "gdc_lib_main\functions\gdc_lucy\spawn";
            class lucySpawnGroupInf {};
            class lucySpawnGroupVehicle {};
            class lucySpawnStaticInf {};                
            class lucySpawnVehicleReinforcement {};                
        };
        class lucyUtilities
        {
            file = "gdc_lib_main\functions\gdc_lucy\utilities";
            class lucyAICleaner {};
            class lucyAISetConfig {};
            class lucyGetNearestPlayer {};
            class lucyGetRandomFormation {};
            class lucyVehicleRemoveItems {};
        };
		class util
		{
			file = "\gdc_lib_main\functions\util";
			class chooseSpawnPos
			{
				
			};
			class chooseIAHelicoInsert
			{
				
			};
			class inventoryBriefing
			{
				
			};
			class rosterBriefing
			{
				
			};
		};
	};
};
