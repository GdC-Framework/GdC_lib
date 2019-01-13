if (!hasInterface) exitwith {};

// Besoin du TAG dans le nom de variable ?
player setVariable ["DeleteSeagull", true];

player addEventHandler ["Killed", {
	_deleteSeagull = player getVariable ["DeleteSeagull", true];

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
true