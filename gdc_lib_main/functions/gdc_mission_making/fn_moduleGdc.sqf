
if is3DEN then {

	_mode = param [0,"",[""]];
	_input = param [1,[],[[]]];

	switch _mode do {
		// Default object init
		case "init": {
			_logic = _input param [0,objNull,[objNull]]; // Module logic
			_isActivated = _input param [1,true,[true]]; // True when the module was activated, false when it's deactivated
			_isCuratorPlaced = _input param [2,false,[true]]; // True if the module was placed by Zeus
			// ... code here...
		};
		// When some attributes were changed (including position and rotation)
		case "attributesChanged3DEN": {
			_logic = _input param [0,objNull,[objNull]];
			// ... code here...
		};
		// When added to the world (e.g., after undoing and redoing creation)
		case "registeredToWorld3DEN": {
			_logic = _input param [0,objNull,[objNull]];
			// ... code here...
		};
		// When removed from the world (i.e., by deletion or undoing creation)
		case "unregisteredFromWorld3DEN": {
			_logic = _input param [0,objNull,[objNull]];
			// ... code here...
		};
		// When connection to object changes (i.e., new one is added or existing one removed)
		case "connectionChanged3DEN": {
			_logic = _input param [0,objNull,[objNull]];
			// ... code here...
		};
		// When object is being dragged
		case "dragged3DEN": {
			_logic = _input param [0,objNull,[objNull]];
			// ... code here...
		};
	};
	
} else {

	// Argument 0 is module logic.
	_logic = param [0,objNull,[objNull]];
	// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
	_units = param [1,[],[[]]];
	// True when the module was activated, false when it's deactivated (i.e., synced triggers are no longer active)
	_activated = param [2,true,[true]];
	// Module specific behavior. Function can extract arguments from logic and use them.
	if (_activated) then {
		// Attribute values are saved in module's object space under their class names
		// _bombYield = _logic getVariable ["Yield",-1]; //(as per the previous example, but you can define your own.) 

		// lancement du script qui affiche le loadout lors du briefing.
		[] call GDC_fnc_inventoryBriefing; 
		// lancement du script qui affiche le roster lors du briefing.
		[] call GDC_fnc_rosterBriefing;

		player addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];

			//Spectateur ACRE
			if (isClass(configFile >> "CfgPatches" >> "acre_main")) then {[true] call acre_api_fnc_setSpectator;};

			//Anti mouettes
			{
				if(_x isKindOf "seagull") then {
					_x setPos [0,0,500];
					hideobjectglobal _x;
					_x enablesimulationglobal false;
				};
			} forEach nearestObjects [player, [], 250];
		}];
	};
};

true