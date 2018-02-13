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
			class extraInit
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
			class choppaInit
			{
				
			};
			class choppaCall
			{
				
			};
		};
	};
};
