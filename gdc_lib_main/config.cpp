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
		class util
		{
			file = "\gdc_lib_main\functions\util";
			class chooseSpawnPos
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
