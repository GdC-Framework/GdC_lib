
// Attribute values are saved in module's object space under their class names
if(hasInterface) then {
	_inventory = player getVariable ["GDC_config_inventoryBriefing", false];
	_roster = player getVariable ["GDC_config_rosterBriefing", false];

	// lancement du script qui affiche le loadout lors du briefing.
	if(_inventory) then {
		[] call GDC_fnc_inventoryBriefing; 
	};
	// lancement du script qui affiche le roster lors du briefing.
	if(_roster) then {
		[] call GDC_fnc_rosterBriefing;
	};

	player addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];

		_acreSpectator = player getVariable ["GDC_config_DeleteSeagull", false];
		_deleteSeagull = player getVariable ["GDC_config_AcreSpectator", false];

		//Spectateur ACRE
		if(_acreSpectator) then {
			if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {
				[true] call acre_api_fnc_setSpectator;
			};
		};

		//Anti mouettes
		if(_deleteSeagull) then {
			{
				if(_x isKindOf "seagull") then {
					_x setPos [0,0,500];
					hideobjectglobal _x;
					_x enablesimulationglobal false;
				};
			} forEach nearestObjects [player, [], 250];
		};
	}];
};

true