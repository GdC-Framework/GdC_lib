/*
	Author: Skippy, Sparfell

	Description:
	Adds a "roster" tab in the diary displaying teams' composition.

	Parameter(s):
		0 (Optional): BOOL - AI are included (default: false)
		1 (Optional): BOOL - rank inclued (default: true)
		2 (Optional): BOOL - role inclued (default: true)

	Returns:
	nothing
*/

params [["_includeAI",false,[true]],["_rank",true,[true]],["_role",true,[true]]];
private["_strRank","_strRole","_strGrp","_strColorGrp","_strFinal","_oldGrp","_newGrp","_unitsArr","_nbr"];

_strRank 		= "";//will contain unit's rank
_strRole 		= "";//will contain unit's role
_strGrp 		= "";//will contain unit's group name
_strColorGrp 	= "";//will contain unit's group color
_strFinal 		= "";//will contain final string to be displayed
_oldGrp 		= grpNull;//group of last checked unit
_newGrp 		= grpNull;//group of current unit
_unitsArr 		= [];//will contain all units that have to be processed

if (_includeAI) then {
	_unitsArr = allUnits;
} else {
	if(isMultiplayer) then {
		_unitsArr = playableUnits;
	} else {
		_unitsArr = switchableUnits;
	};
};

{//forEach
	_newGrp = group _x;
	_strGrp = "";

	if(_rank) then {
		switch(rankID _x) do {
			case 0:{
				_strRank = "Pvt. ";
			};
			case 1:{
				_strRank = "Cpl. ";
			};
			case 2:{
				_strRank = "Sgt. ";
			};
			case 3:{
				_strRank = "Lt. ";
			};
			case 4:{
				_strRank = "Cpt. ";
			};
			case 5:{
				_strRank = "Maj. ";
			};
			case 6:{
				_strRank = "Col. ";
			};
			default{
				_strRank = "Pvt. ";
			};
		};
	};

	if (_role) then {
		_strRole = " - " + getText(configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName");
		if((roleDescription _x) != "") then {
			_nbr = (roleDescription _x) find "@";
			if (_nbr < 0) then {
				_strRole = " - " + (roleDescription _x);
			} else {
				_strRole = " - " + ((roleDescription _x) select [0,_nbr]);
			};
		};
	};

	if(_newGrp != _oldGrp) then {
		_nbr = (roleDescription _x) find "@";
		if (_nbr < 0) then {
			_strGrp = "<br/>" + (groupID(group _x)) + "<br/>";
		} else {
			_strGrp = "<br/>" + ((roleDescription _x) select [_nbr + 1]) + "<br/>";
		};

		switch (side _x) do {
			case EAST:{
				_strColorGrp = "'#990000'";
			};
			case WEST:{
				_strColorGrp = "'#0066CC'";
			};
			case RESISTANCE:{
				_strColorGrp = "'#339900'";
			};
			case CIVILIAN:{
				_strColorGrp = "'#990099'";
			};
		};
	};
	_strFinal =  _strFinal + "<font color="+_strColorGrp+">"+_strGrp+"</font>" + _strRank + name _x + _strRole + "<br/>";
	_oldGrp = group _x;
}forEach (_unitsArr select {side _x == side player});

player createDiarySubject ["roster","Team Roster"];
player createDiaryRecord ["roster",["Composition des équipes",_strFinal]];
