//==================================================================fnc_DoInfPatrol===============================================================================================
// Validate if and organise transportation
//
// spirit 28-1-2014
//===========================================================================================================================================================================
private ["_group", "_wpPos", "_wptype"];

_group = _this select 0;

//where is this dude going?
_wpPos = (waypointPosition [_group ,(count(waypoints _group)-1)]);
_wptype = waypointType [_group ,(count(waypoints _group)-1)];


if ( _wppos distance [0,0,0]>0) then {

    //How fare does he need to travel?
    _dist = _wpPos distance (position leader _group);

    //If that is futther then the max range for slow speed groups, then he is legimate to receive transportation
    if (_dist > MCC_GAIA_MAX_SLOW_SPEED_RANGE) then {

        {
            //Now we go see if we hold a valid transporter
            _TransportGrp = _x;
            _TransportClass = (_TransportGrp getVariable ["GAIA_class", ""]);

            //Lets set the max range for transport (yes a case thingy migh be better, do it!)
            _TransportRange = MCC_GAIA_MAX_SLOW_SPEED_RANGE;
            if (_TransportClass in ["Car", "Tank"]) then {_TransportRange = MCC_GAIA_MAX_MEDIUM_SPEED_RANGE;};
            if (_TransportClass in ["Helicopter"]) then {_TransportRange = MCC_GAIA_MAX_FAST_SPEED_RANGE;};


            if (
                //Seems like allgroups opens up with all sorts of empty groups, better check it
                ((side _TransportGrp) == (side _group))
                // Ignore SHIP, that was never implemented
                and _TransportClass != "Ship"
                and (count(units _TransportGrp)>0)
                and (alive (leader _TransportGrp))
                and ((behaviour leader _TransportGrp)!="COMBAT")
                // Check if the transport unit is Gaia
				and (count(_x getVariable ["GAIA_zone_intend",[]])>1)
                //The transport vehicle must not be occupied
                and ((_x getVariable ["GAIA_Order", ""]) != "DoTransport")
                //The transport vehicle must not be busy with an attack
                //((_x getVariable ["GAIA_Order", ""]) != "DoAttack")
                and !(behaviour(leader _x)=="COMBAT")
                // He must be able to do transport
                and ("DoTransport" in (_TransportGrp getVariable ["GAIA_Portfolio",[]]))
                //He must be able to hold all of us
                and ((count units _group)<=(_TransportGrp getVariable ["GAIA_cargo",0]))
                //The vehicle cannot be so far out from the requesting group that it even exeeds its own max range based on medium speed
                and (((leader _group) distance (leader _TransportGrp))< _TransportRange)
                //The distance to transport must exceed the distance to the transport by 2 times.
                //and ((_dist*2) > ((leader _group) distance (leader _TransportGrp)))
                //A transporter takes atleast MCC_GAIA_TRANSPORT_RESTTIME seconds of breaktime before getting a new order
                //and ((time-(_TransportGrp getVariable ["GAIA_Ordertime",0]))>MCC_GAIA_TRANSPORT_RESTTIME)
                //and Cars only support patrols that are out of zone, they refure combat (until bis pays them more)
            ) then {

                switch(_TransportClass) do {
                    //Infantry
                    case "Car": {
                        _dummy = [_group,_TransportGrp] call GDC_gaia_fnc_doTransportCar;
                    };
                    case "Tank": {
                        _dummy = [_group,_TransportGrp] call GDC_gaia_fnc_doTransportTank;
                    };
                    case "Helicopter": {
                        _dummy = [_group,_TransportGrp] call GDC_gaia_fnc_doTransportHelicopter;
                    };
                    case "Ship": {
                        // _dummy = [_group,_TransportGrp] call GDC_gaia_fnc_DoTransportShip;
                    };

                };
            };

            //If we have waypoints, stop (more then 1 as the initial patrol waypoint is the first).
            //If this fails, every transport in the universe will try to serve us, maybe something smarter
            if ( ((_group getVariable ["GAIA_Order", ""]) == "DoTransport")) exitwith {true;};

        //Lets assume the closest valid transporter is the most logic one (not always true, but i dunno yet how to improve without overcomplicate stuff)
        } forEach ([AllGroups,[],{(leader _group) distance (leader _x)}, "ASCEND",{alive (leader _x)}] call BIS_fnc_sortBy);
    };
};


//Our result is waypoints
((count (waypoints _group)) - currentWaypoint _group)
