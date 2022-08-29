/*
	Author: TECAK, Mystery, Sparfell

	Description:
	Adds an "inventory" tab in the diary displaying player's inventory

	Parameter(s):
		NONE

	Returns:
	nothing
*/

// If spectator or zeus... there is no inventory so don't care about this feature!
if(isNull player) exitWith {};

private _text = [player] call GDC_fnc_getInventoryBriefing;
private _name = name player;
player createDiarySubject ["inventory","Inventaire"];
player createDiaryRecord ["inventory", ["Matos de " + _name, _text,(format ["\a3\ui_f\data\gui\cfg\ranks\%1_gs.paa",(tolower rank player)])]];
