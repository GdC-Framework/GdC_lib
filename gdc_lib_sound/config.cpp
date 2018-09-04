/*
	Every sounds in this addon are protected by APL-ND licence.
	Visit https://www.bohemia.net/community/licenses/arma-public-license-nd for more informations.
*/

class CfgPatches
{
	class gdc_lib_sound
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"gdc_lib_main"};
	};
};

class CfgMusicClasses
{
	class gdc_lib_music
	{
		displayName = "GDC LIB";
	};
};


#include "CfgMusic.hpp"
