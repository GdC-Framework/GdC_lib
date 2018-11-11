/* ----------------------------------------------------------------------------
Function: fnc_DoTransportCar

Description:
    Organise transport Car

Parameters:
    - group (to be transported
    - group (transporter)

Returns:
    waypoints

Author:
    Spirit, 17-2-2014

---------------------------------------------------------------------------- 
_group = _this select 0;
_trnsprtgrp = _this select 1;



_PosCloseRoadStart = [];
_PosCloseRoadEnd = [];

//where is this dude going?
_wpPos = (waypointPosition [_group ,(count(waypoints _group)-1)]);
_wptype = waypointType [_group ,(count(waypoints _group)-1)];


_nearRoad = (leader _group nearRoads 300);

if (count(_nearroad)>0) then
//Arrange a pickup on the side of the street, else we gonna have ai crazyness going on
{_road = (([_nearRoad,[],{leader _group distance _x}, "ASCEND"] call BIS_fnc_sortBy ) select 0);

 _roadConnectedTo = roadsConnectedTo _road;

    if (count(_roadConnectedTo)>0) then
    {
            _connectedRoad = _roadConnectedTo select 0;
            _direction = [_road, _connectedRoad] call BIS_fnc_DirTo;
            _PosCloseRoadStart = [(position _road), 7, (_direction - 45)] call BIS_fnc_relPos;
    };
};


    _nearRoad = ( _wpPos nearRoads 400);
if (count(_nearroad)>0) then
{_PosCloseRoadEnd = position(([_nearRoad,[],{_wpPos distance _x}, "DESCEND"] call BIS_fnc_sortBy ) select 0);};

if (
            //There is a road found to pickup and a road foudn to drop him off
            (count(_PosCloseRoadStart)>0) and (count( _PosCloseRoadEnd)>0)


    ) then
{
 //Make the transporter stop hiding
 _dummy =[_trnsprtgrp] call GDC_gaia_fnc_removeWaypoints;
 _dummy =[_group] call GDC_gaia_fnc_removeWaypoints;


  // Get in
 _wpGroup = _group addWaypoint [_PosCloseRoadStart, 0];
 _wpGroup setWaypointType "GETIN";
 _wpGroup setWaypointCompletionRadius 20;

 _wpTransporter = _trnsprtgrp addWaypoint [_PosCloseRoadStart, 0];
 _wpTransporter setWaypointType "LOAD";
 _wpTransporter setWaypointCompletionRadius 20;
 _wpTransporter setWaypointSpeed "FULL";

 //Synchronize them
 _wpGroup synchronizeWaypoint [_wpTransporter];


  // Get the fuck out
 _wpGroup = _group addWaypoint [_PosCloseRoadEnd, 0];
 _wpGroup setWaypointType "GETOUT";
 _wpGroup setWaypointCompletionRadius 20;
 //We go on alone, set us free
 _wpGroup setWaypointStatements ["true", " (group this) setVariable ['GAIA_Order' , 'DoPatrol', false];(group this) setVariable ['GAIA_CombinedOrder' , GrpNull, false];"];

 _wpTransporter = _trnsprtgrp addWaypoint [_PosCloseRoadEnd, 0];
 _wpTransporter setWaypointType "TR UNLOAD";
 _wpTransporter setWaypointCompletionRadius 20;
 //release both groups from each other


 //Synchronize them
 _wpGroup synchronizeWaypoint [_wpTransporter];

 //patrolling units will pick this up first
 _group setVariable ["GAIA_OriginalDestination",_wpPos , false];

    //Lets set the current Order of the vehilce transporting ( so he dont get a new DoTransport when we are going)
    _trnsprtgrp setVariable ["GAIA_Order" , "DoTransport", false];
    _group setVariable ["GAIA_Order" , "DoTransport", false];
    //Also note when we gave that order and where the unit was. It gives us a chance to check his progress and to 'unstuck' him if needed.
    //Also all orders have a lifespan. MCC_GAIA_ORDERLIFETIME
    _trnsprtgrp setVariable ["GAIA_OrderTime" , Time, false];
    _trnsprtgrp setVariable ["GAIA_OrderPosition" , (_PosCloseRoadEnd), false];

    _x setVariable ["GAIA_CombinedOrder" , (_group), false];
    _group setVariable ["GAIA_CombinedOrder" , (_trnsprtgrp), false];



};


*/

/* ----------------------------------------------------------------------------
Function: fnc_DoTransportCar

Description:
    Organise transport Car

Parameters:
    - group (to be transported
    - group (transporter)

Returns:
    waypoints

Author:
    Spirit, 17-2-2014

---------------------------------------------------------------------------- */
_group = _this select 0;
_trnsprtgrp = _this select 1;

//player globalchat format ["%1 instappper, %2 vervoer",_group,_trnsprtgrp];

_PosCloseRoadStart = [];
_PosCloseRoadEnd = [];
_found = false;
_attempts = 0;
_pos = [];
_ToCloseCA = [];

//where is this dude going?
_wpPos = (waypointPosition [_group ,(count(waypoints _group)-1)]);
_wptype = waypointType [_group ,(count(waypoints _group)-1)];

switch (side _group) do {
    case west : {
        _CA = MCC_GAIA_CA_WEST;
    };
    case east : {
        _CA = MCC_GAIA_CA_EAST;
    };
    case independent : {
        _CA = MCC_GAIA_CA_INDEP;
    };
    case civilian : {
        _CA = MCC_GAIA_CA_CIV;
    };
};



while {!_found and _attempts<30} do {
    sleep 0.1;
    
    //With a -30 to + 30 degree difference do move 100 to TargetPos
    _pos = [_wpPos, (random 400) min 300 , random 360 ] call BIS_fnc_relPos;
    //And please, please, please, try some cover ok.Within 50, so another wild flanking thingy
    _CoverPos = [];
    _CoverPos =selectBestPlaces [_pos, 30, "meadow + 2*hills", 1, 1];
    

    //We found some good stuf, go use it
    if ((count (_CoverPos))>0) then {
        _CoverPos=(_CoverPos select 0 select 0);
        _pos = _CoverPos;
    };

    _ToCloseCA = [_ca, {(_x distance _pos)<300}] call BIS_fnc_conditionalSelect;                
    if (!(surfaceiswater _pos ) and count(_ToCloseCA)==0) then {
        _found = true;
    };
};



if _found then {

    //Make the transporter stop hiding
    _dummy =[_trnsprtgrp] call GDC_gaia_fnc_removeWaypoints;
    _dummy =[_group] call GDC_gaia_fnc_removeWaypoints;

    _PosCloseRoadStart = (position leader _group);
    _PosCloseRoadEnd =   _pos;
    // Get in
    _wpGroup = _group addWaypoint [_PosCloseRoadStart, 0];
    _wpGroup setWaypointType "GETIN";
    _wpGroup setWaypointCompletionRadius 20;

    _wpTransporter = _trnsprtgrp addWaypoint [_PosCloseRoadStart, 0];
    _wpTransporter setWaypointType "LOAD";
    _wpTransporter setWaypointCompletionRadius 20;
    _wpTransporter setWaypointSpeed "FULL";

    //Synchronize them
    _wpGroup synchronizeWaypoint [_wpTransporter];


    // Get the fuck out
    _wpGroup = _group addWaypoint [_PosCloseRoadEnd, 0];
    _wpGroup setWaypointType "GETOUT";
    _wpGroup setWaypointCompletionRadius 20;
    //We go on alone, set us free
    _wpGroup setWaypointStatements ["true", " (group this) setVariable ['GAIA_Order' , 'DoPatrol', false];(group this) setVariable ['GAIA_CombinedOrder' , GrpNull, false];"];

    _wpTransporter = _trnsprtgrp addWaypoint [_PosCloseRoadEnd, 0];
    _wpTransporter setWaypointType "TR UNLOAD";
    _wpTransporter setWaypointCompletionRadius 20;
    //release both groups from each other


    //Synchronize them
    _wpGroup synchronizeWaypoint [_wpTransporter];

    //patrolling units will pick this up first
    _group setVariable ["GAIA_OriginalDestination",_wpPos , false];

    //Lets set the current Order of the vehilce transporting ( so he dont get a new DoTransport when we are going)
    _trnsprtgrp setVariable ["GAIA_Order" , "DoTransport", false];
    _group setVariable ["GAIA_Order" , "DoTransport", false];
    //Also note when we gave that order and where the unit was. It gives us a chance to check his progress and to 'unstuck' him if needed.
    //Also all orders have a lifespan. MCC_GAIA_ORDERLIFETIME
    _trnsprtgrp setVariable ["GAIA_OrderTime" , Time, false];
    _trnsprtgrp setVariable ["GAIA_OrderPosition" , (_PosCloseRoadEnd), false];

    _x setVariable ["GAIA_CombinedOrder" , (_group), false];
    _group setVariable ["GAIA_CombinedOrder" , (_trnsprtgrp), false];
};         



 