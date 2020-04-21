
// En cas d'absence du slot HC
if (isNil "HC_Slot") then {
	HC_Slot = objNull;
};

if(hasInterface) then {
	_inventory = getMissionConfigValue ["GDC_Inventory",false];
	_roster = getMissionConfigValue ["GDC_Roster",false];

	// remplacer la trousse de soin par 12 attelles.
	if (isNil "GDC_allowPAK") then {
		[
			"ACE_personalAidKit",
			["ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint"]
		] call ace_common_fnc_registerItemReplacement;
	};

	// lancement du script qui affiche le loadout lors du briefing.
	if(_inventory isEqualTo true || _inventory isEqualTo 1) then {
		[] call GDC_fnc_inventoryBriefing; 
	};
	// lancement du script qui affiche le roster lors du briefing.
	if(_roster isEqualTo true || _roster isEqualTo 1) then {
		[] call GDC_fnc_rosterBriefing;
	};

	player addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];

		_acreSpectator = getMissionConfigValue ["GDC_AcreSpectator",false];
		_deleteSeagull = getMissionConfigValue ["GDC_DeleteSeagull",false];

		//Spectateur ACRE
		if(_acreSpectator isEqualTo true || _acreSpectator isEqualTo 1) then {
			if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {
				[true] call acre_api_fnc_setSpectator;
			};
		};

		//Anti mouettes
		if(_deleteSeagull isEqualTo true || _deleteSeagull isEqualTo 1) then {
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