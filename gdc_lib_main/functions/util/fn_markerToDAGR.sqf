/*
	Author: Sparfell

	Description:
	this function will allow the players to register into the DAGR the positions of several markers placed during the briefing
	
	Parameter(s): none

	Returns:
	nothing
*/
private ["_mks","_pos","_count"];

// Onglet briefing
player createDiarySubject ["markerToDAGR","Marqueurs DAGR"];
player createDiaryRecord ["markerToDAGR", ["Instructions","<font size='20'><font color='#FF0000'>Marqueurs pour le DAGR</font></font>
<br/><br/>Pendant le briefing, les joueurs peuvent placer des marqueurs sur la carte afin que les positions ainsi marquées soient automatiquement ajoutés à la liste des waypoints enregistrés dans le DAGR.
<br/>Pour cela, les marqueurs doivent être nommés avec le préfix <font color='#EF7619'>DAGR_</font>."]];

waitUntil {time > 0};

// Récolte des markers
_mks = (allMapMarkers select {["DAGR_",(markerText _x)] call GDC_fnc_StringStartWith});
_count = (count _mks) min 5;
ace_dagr_numWaypoints = 0;

// Ajout des positions dans le DAGR
for "_i" from 1 to _count do {
	_pos = MarkerPos (_mks select (_i -1));
	_pos = [_pos] call ace_common_fnc_getMapGridFromPos;
	_pos = ((_pos select 0) select [0,4]) + ((_pos select 1) select [0,4]);
	_str = _pos;
	_pos = parseNumber _pos;
	switch (_i) do {
		case 1: {ace_dagr_wp0 = _pos;ace_dagr_wpString0 = _str;};
		case 2: {ace_dagr_wp1 = _pos;ace_dagr_wpString1 = _str;};
		case 3: {ace_dagr_wp2 = _pos;ace_dagr_wpString2 = _str;};
		case 4: {ace_dagr_wp3 = _pos;ace_dagr_wpString3 = _str;};
		case 5: {ace_dagr_wp4 = _pos;ace_dagr_wpString4 = _str;};
	};
	ace_dagr_numWaypoints = ace_dagr_numWaypoints + 1;
};