
// En cas d'absence du slot HC
if (isNil "HC_Slot") then {
	HC_Slot = objNull;
};

// lancement du script qui affiche le loadout lors du briefing.
_inventory = getMissionConfigValue ["GDC_Inventory",false];
if(_inventory isEqualTo true || _inventory isEqualTo 1) then {
	if (isServer && isMultiplayer) then {
			GDC_playersinbriefing = 0;
			GDC_inventoryBriefingEH = addMissionEventHandler ["OnUserClientStateChanged", {
				params ["_networkId", "_clientStateNumber", "_clientState"];
				if (_clientState == "BRIEFING SHOWN") then {
					GDC_playersinbriefing = GDC_playersinbriefing + 1;
					if (GDC_playersinbriefing >= (count allUsers)) then {
						[] remoteExec ["GDC_fnc_inventoryBriefing_v2",0,true];
						removeMissionEventHandler ["OnUserClientStateChanged", GDC_inventoryBriefingEH];
					};
				};
			}];
	} else {
		[] call GDC_fnc_inventoryBriefing_v2;
	};
};

if(hasInterface) then {
	_roster = getMissionConfigValue ["GDC_Roster",false];

	// remplacer la trousse de soin par 12 attelles.
	if (isNil "GDC_allowPAK") then {
		[
			"ACE_personalAidKit",
			["ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint"]
		] call ace_common_fnc_registerItemReplacement;
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

// Létalité réduite (ACE) pour les missions sans protections
if (getMissionConfigValue ["GDC_AceDamage", false]) then {
	ace_medical_playerDamageThreshold = 5;
};

true