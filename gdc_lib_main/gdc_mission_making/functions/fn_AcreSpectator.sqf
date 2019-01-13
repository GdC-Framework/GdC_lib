if (!hasInterface) exitwith {};

// Besoin du TAG dans le nom de variable ?
player setVariable ["AcreSpectator", true];

player addEventHandler ["Killed", {
	_acreSpectator = player getVariable ["AcreSpectator", true];

	//Spectateur ACRE
	if(_acreSpectator) then {
		if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {[true] call acre_api_fnc_setSpectator;};
	};
}];
true