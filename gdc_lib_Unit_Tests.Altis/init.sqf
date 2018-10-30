
fileExists = {
    private ["_ctrl", "_fileExists"];
    disableSerialization;
    _ctrl = findDisplay 0 ctrlCreate ["RscHTML", -1];
    _ctrl htmlLoad _this;
    _fileExists = ctrlHTMLLoaded _ctrl;
    ctrlDelete _ctrl;
    _fileExists
};





["ACRE_PRC117F", 5, blufor, "RHS_UH60M", [4805.27, 4671.13, 0]] call GDC_fnc_extra;

if (isServer) then
{
	// call compile preprocessfile "gaia\gaia_init.sqf";

  	civilian setFriend [east, 1];




	// Start tests


	systemChat 'Start tests';

	{
		// Check if file exists
		if (_x call fileExists) then {
			call compile preprocessFileLineNumbers _x;
			sleep 1;
		};
	} foreach [
		'gdc_choppa\tests.sqf',
		'gdc_extra\tests.sqf',
		'gdc_gaia\tests.sqf',
		'gdc_halo\tests.sqf',
		'gdc_lucy\tests.sqf',
		'gdc_pluto\tests.sqf',
		'util\tests.sqf',
		'utilInternal\tests.sqf'
	];

	systemChat 'End tests';

};

