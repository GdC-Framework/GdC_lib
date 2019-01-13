if (!hasInterface) exitwith {};

player addEventHandler ["Killed", {
	//Spectateur ACRE
	if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {
		[true] call acre_api_fnc_setSpectator;
	};
}];
true