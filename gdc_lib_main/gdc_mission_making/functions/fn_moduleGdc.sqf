
if !is3DEN then {
	// Argument 0 is module logic.
	_logic = param [0,objNull,[objNull]];
	// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
	_units = param [1,[],[[]]];
	// True when the module was activated, false when it's deactivated (i.e., synced triggers are no longer active)
	_activated = param [2,true,[true]];
	// Module specific behavior. Function can extract arguments from logic and use them.
	if (_activated) then {
		// Attribute values are saved in module's object space under their class names
		if(hasInterface) then {
			_inventory = _logic getVariable ["Inventory", true];
			_roster = _logic getVariable ["Roster", true];
			_acreSpectator = _logic getVariable ["AcreSpectator", true];
			_deleteSeagull = _logic getVariable ["DeleteSeagull", true];

			// lancement du script qui affiche le loadout lors du briefing.
			if(_inventory) then {
				[] call GDC_fnc_inventoryBriefing; 
			};
			// lancement du script qui affiche le roster lors du briefing.
			if(_roster) then {
				[] call GDC_fnc_rosterBriefing;
			};

			player setVariable ["GDC_AcreSpectator", _acreSpectator];
			player setVariable ["GDC_DeleteSeagull", _deleteSeagull];

			player addEventHandler ["Killed", {
				params ["_unit", "_killer", "_instigator", "_useEffects"];

				_acreSpectator = player getVariable ["GDC_AcreSpectator", true];
				_deleteSeagull = player getVariable ["GDC_DeleteSeagull", true];


				//Spectateur ACRE
				if(_acreSpectator) then {
					if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {[true] call acre_api_fnc_setSpectator;};
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
	};
};

true