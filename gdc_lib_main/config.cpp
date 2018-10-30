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
		#include "functions\gdc_choppa\index.hpp"
		#include "functions\gdc_extra\index.hpp"
		#include "functions\gdc_halo\index.hpp"
		#include "functions\gdc_lucy\index.hpp"
		#include "functions\gdc_pluto\index.hpp"
		#include "functions\util\index.hpp"
		#include "functions\utilInternal\index.hpp"
	};

	#include "functions\gdc_gaia\index.hpp"
};
