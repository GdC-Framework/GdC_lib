class CfgPatches
{
	class gdc_lib_main
	{
		units[] = {"GDC_moduleGdc"};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {"A3_Functions_F", "A3_Modules_F"};
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
	#include "functions\gdc_mission_making\CfgVehicles.hpp"
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


