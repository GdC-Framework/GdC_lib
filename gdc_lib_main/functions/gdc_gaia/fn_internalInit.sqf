/*
  Created by Spirit, 5-1-2014
*/

// Is that the last version? => https://github.com/shaygman/mcc_sandbox.Altis/tree/master/gaia ?

params [
  //GAIA Public (local) variables
  ["_MCC_GAIA_DEBUG", false, [true]],
  ["_MCC_GAIA_CA_DEBUG", [], [[]]],

  //Gaia cache
  ["_MCC_GAIA_CACHE", false, [true]],
  ["_GAIA_CACHE_SLEEP", 0.5, [0]],
  ["_GAIA_CACHE_STAGE_1", 1000, [0]],
  ["_MCC_GAIA_CACHE_STAGE2", [], [[]]],

  //Used for the breadcrumb blacklist system. How far should a waypoint be from a position a unit has last been?
  ["_MCC_GAIA_AWARENESSRANGE", 100, [0]],
  ["_MCC_GAIA_CLEARRANGE", 70, [0]],
  ["_MCC_GAIA_SHARETARGET_DELAY", 5, [0]],
  ["_MCC_GAIA_MAX_SLOW_SPEED_RANGE", 600, [0]],
  ["_MCC_GAIA_MAX_MEDIUM_SPEED_RANGE", 4500, [0]],
  ["_MCC_GAIA_MAX_FAST_SPEED_RANGE", 80000, [0]],
  // The seconds of rest a transporter takes after STARTING his last order
  ["_MCC_GAIA_TRANSPORT_RESTTIME", 40, [0]],
  //If an order is older then 10 minutes, cancel it. There is probbaly something wrong.
  ["_MCC_GAIA_MAX_ORDER_AGE", 5000, [0]],
  ["_MCC_GAIA_MORTAR_TIMEOUT", 300, [0]],

  //Ambient Combat
  ["_MCC_GAIA_AC", false, [true]],
  ["_MCC_GAIA_AC_MAXRANGE", 1000, [0]],
  ["_MCC_GAIA_AC_MAXGROUPS", 35, [0]],
  ["_MCC_GAIA_AMBIENT_ZONE_RESERVED", 1000, [0]],
  ["_MCC_GAIA_AMBIANT", true, [true]],
  ["_MCC_GAIA_AMBIANT_CHANCE", 20, [0]]
];

/* Init global var */
MCC_GAIA_DEBUG = _MCC_GAIA_DEBUG;
MCC_GAIA_CA_DEBUG = _MCC_GAIA_CA_DEBUG;
MCC_GAIA_CACHE = _MCC_GAIA_CACHE;
GAIA_CACHE_SLEEP = _GAIA_CACHE_SLEEP;
GAIA_CACHE_STAGE_1 = _GAIA_CACHE_STAGE_1;
MCC_GAIA_CACHE_STAGE2 = _MCC_GAIA_CACHE_STAGE2;
MCC_GAIA_AWARENESSRANGE = _MCC_GAIA_AWARENESSRANGE;
MCC_GAIA_CLEARRANGE = _MCC_GAIA_CLEARRANGE;
MCC_GAIA_SHARETARGET_DELAY = _MCC_GAIA_SHARETARGET_DELAY;
MCC_GAIA_MAX_SLOW_SPEED_RANGE = _MCC_GAIA_MAX_SLOW_SPEED_RANGE;
MCC_GAIA_MAX_MEDIUM_SPEED_RANGE = _MCC_GAIA_MAX_MEDIUM_SPEED_RANGE;
MCC_GAIA_MAX_FAST_SPEED_RANGE = _MCC_GAIA_MAX_FAST_SPEED_RANGE;
MCC_GAIA_TRANSPORT_RESTTIME = _MCC_GAIA_TRANSPORT_RESTTIME;
MCC_GAIA_MAX_ORDER_AGE = _MCC_GAIA_MAX_ORDER_AGE;
MCC_GAIA_MORTAR_TIMEOUT = _MCC_GAIA_MORTAR_TIMEOUT;
MCC_GAIA_AC = _MCC_GAIA_AC;
MCC_GAIA_AC_MAXRANGE = _MCC_GAIA_AC_MAXRANGE;
MCC_GAIA_AC_MAXGROUPS = _MCC_GAIA_AC_MAXGROUPS;
MCC_GAIA_AMBIENT_ZONE_RESERVED = _MCC_GAIA_AMBIENT_ZONE_RESERVED;
MCC_GAIA_AMBIANT = _MCC_GAIA_AMBIANT;
MCC_GAIA_AMBIANT_CHANCE = _MCC_GAIA_AMBIANT_CHANCE;


GAIA_INIT = FALSE;

// More cache variables
GAIA_CACHE_STAGE_2 = (2*GAIA_CACHE_STAGE_1);

//Side specific
MCC_GAIA_CA_WEST = [];
MCC_GAIA_CA_EAST = [];
MCC_GAIA_CA_INDEP = [];
MCC_GAIA_CA_CIV = [];
MCC_GAIA_ZONES_INDEP = [];
MCC_GAIA_ZONES_CIV = [];
MCC_GAIA_ZONES_POS_INDEP = [];
MCC_GAIA_ZONES_POS_CIV = [];
MCC_GAIA_ZONES_EAST = [];
MCC_GAIA_ZONES_POS_EAST = [];
MCC_GAIA_ZONES_WEST = [];
MCC_GAIA_ZONES_POS_WEST = [];
MCC_GAIA_GROUPS_WEST = [];
MCC_GAIA_GROUPS_EAST = [];
MCC_GAIA_GROUPS_INDEP = [];
MCC_GAIA_GROUPS_CIV = [];
MCC_GAIA_BREADCRUMBS_WEST = [];
MCC_GAIA_BREADCRUMBS_EAST = [];
MCC_GAIA_BREADCRUMBS_INDEP = [];
MCC_GAIA_BREADCRUMBS_CIV = [];
MCC_GAIA_WPPOS_WEST = [];
MCC_GAIA_WPPOS_EAST = [];
MCC_GAIA_WPPOS_INDEP = [];
MCC_GAIA_WPPOS_CIV = [];
MCC_GAIA_FACTIONS_WEST = [];
MCC_GAIA_FACTIONS_EAST = [];
MCC_GAIA_FACTIONS_INDEP = [];
MCC_GAIA_FACTIONS_CIV = [];
MCC_GAIA_DELAYED_SPAWNS = [];
MCC_GAIA_ZONESTATUS_WEST = []; for "_i" from 0 to 90 do { MCC_GAIA_ZONESTATUS_WEST set [_i, "0"];};
MCC_GAIA_ZONESTATUS_EAST = []; for "_i" from 0 to 90 do { MCC_GAIA_ZONESTATUS_EAST set [_i, "0"];};
MCC_GAIA_ZONESTATUS_INDEP = []; for "_i" from 0 to 90 do { MCC_GAIA_ZONESTATUS_INDEP set [_i, "0"];};
MCC_GAIA_ZONESTATUS_CIV = []; for "_i" from 0 to 90 do { MCC_GAIA_ZONESTATUS_INDEP set [_i, "0"];};
MCC_GAIA_TARGETS_WEST = []; for "_i" from 0 to 90 do { MCC_GAIA_TARGETS_WEST set [_i,[]];};
MCC_GAIA_TARGETS_EAST = []; for "_i" from 0 to 90 do { MCC_GAIA_TARGETS_EAST set [_i,[]];};
MCC_GAIA_TARGETS_INDEP = []; for "_i" from 0 to 90 do { MCC_GAIA_TARGETS_INDEP set [_i,[]];};
MCC_GAIA_TARGETS_CIV = []; for "_i" from 0 to 90 do { MCC_GAIA_TARGETS_INDEP set [_i,[]];};

//We spawn GAIA for each side (but dont worry, it will only be really active if there are units.)
//Still a smarter solution is welcome.

[WEST] spawn GDC_GAIA_fnc_startGaia;
[EAST] spawn GDC_GAIA_fnc_startGaia;
[independent] spawn GDC_GAIA_fnc_startGaia;
[civilian] spawn GDC_GAIA_fnc_startGaia;


[] spawn GDC_GAIA_fnc_startGaiaCache;
[] spawn GDC_GAIA_FNC_ambientCombat;

GAIA_INIT = TRUE;
