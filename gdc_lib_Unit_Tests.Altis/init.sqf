
ShowAndLog = {
	diag_log _this;
	systemChat _this;
};

// Old way to detect if a file exists
customFileExists = {
    private ["_ctrl", "_fileExists"];
    disableSerialization;
    _ctrl = findDisplay 0 ctrlCreate ["RscHTML", -1];
    _ctrl htmlLoad _this;
    _fileExists = ctrlHTMLLoaded _ctrl;
    ctrlDelete _ctrl;
    _fileExists
};

// Init gaia
[] call GDC_gaia_fnc_init;
[] call GDC_fnc_lucyInit;

[] spawn {
	sleep 1;
	["ACRE_PRC117F", 5, blufor, "RHS_UH60M", [4805.27, 4671.13, 0]] call GDC_fnc_extra;

	if (isServer) then
	{
		// call compile preprocessfile "gaia\gaia_init.sqf";

		civilian setFriend [east, 1];

		// Start tests

		'Start tests' call ShowAndLog;

		{
			_file = _x;
			{
				// Check if file exists
				_finalFile = _x + _file + '.sqf';
				// if (_finalFile call customFileExists) then {
				if (fileExists _finalFile) then {
					call compile preprocessFileLineNumbers _finalFile;
					sleep 1;
				};
			} foreach [
				'gdc_choppa\',
				'gdc_extra\',
				'gdc_gaia\',
				'gdc_halo\',
				'gdc_lucy\',
				'gdc_pluto\',
				'util\',
				'utilInternal\'
			];
		} foreach [
			'init',
			'tests',
			'final'
		];

		'End tests' call ShowAndLog;
	};
};
