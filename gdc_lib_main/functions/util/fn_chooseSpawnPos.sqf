/*
	Author: Sparfell

	Description:
	this function will allow the players to choose their spawn position during the briefing by moving a marker on the map using leftmousebutton
	
	Parameter(s):
		0 : STRING - name of the marker that will be moved, the marker defines the spawn position
		1 (Optional): ARRAY - array fo objects that will be moved on selected position (default: []) if [] all playableunits will be moved
		2 (Optional): STRING - rank required in order to be able to move the marker (default: "SERGEANT")
		3 (Optional): ARRAY of STRINGs and/or OBJECTs - list of marker names or trigger names defining blacklisted areas (default: [])
		4 (Optional): NUMBER - 0: land only, 1: land and water, 2: water only (default: 1)
		5 (Optional): NUMBER - max spawn distance from marker (default: 30)
		6 (Optional): NUMBER - min spawn distance from terrain object (default: 4)

	Returns:
	nothing
*/

params ["_mk",["_units",[],[[]]],["_rank","SERGEANT",[""]],["_blist",[],[[]]],["_water",1,[0]],["_maxDist",30,[0]],["_objDist",4,[0]]];

// Si le le 2e paramètre n'est pas renseigné toutes les unités jouables sont déplacées
if ((count _units) == 0) then {
	if (isMultiplayer) then {
		_units = playableUnits;
	} else {
		_units = switchableUnits;
	};
};

// si le joueur a le rang requis il peut déplacer le marqeur avec un clic gauche sur la carte
if (rank player == _rank) then {
	[_mk,_blist,_water] onMapSingleClick {
		_valid = true;
		// on check si la position choisie n'est pas dans les zones blacklistées
		{
			if (_pos Inarea _x) then {
				_valid = false;
			};
		} forEach (_this select 1);
		// on check si la position choisie est sur l'eau ou pas en fonction du paramètre
		if ((_this select 2) != 1) then {
			switch (_this select 2) do {
				case 0: {if (surfaceIsWater _pos) then {_valid = false};};
				case 2: {if !(surfaceIsWater _pos) then {_valid = false};};
				default {_valid = false};
			};
		};
		// déplacement du marqueur
		if (_valid) then {
			(_this select 0) setmarkerPos _pos;
		};
	};
};

[_units,_mk,_maxDist,_objDist,_water] spawn {
	private ["_pos"];
	// au début de la mission, désactivation de la possibilité de déplacer le marqeur
	waituntil {time > 0};
	onMapSingleClick "";
	{
		_x allowdamage false;
	} forEach (_this select 0);

	// déplacement des objects sélectionnés sur la zone d'insertion
	if (isServer) then {
		// déplacer sur une position sûre
		{
			_pos = [(markerPos (_this select 1)),0,(_this select 2),(_this select 3),(_this select 4),0,0,[],(markerPos (_this select 1))] call BIS_fnc_findSafePos;
			if (isPlayer _x) then {
				[_x,_pos] remoteExec ["setpos",_x];
			} else {
				_x setpos _pos;
			};
		} forEach (_this select 0);
	};
	sleep 10;
	{
		_x allowdamage true;
	} forEach (_this select 0);
};