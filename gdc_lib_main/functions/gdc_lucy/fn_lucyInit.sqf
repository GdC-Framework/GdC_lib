/*
	Author: Mystery

	Description:
	Init function for gdc_lucy, a library of functions to simplify edition life

	Parameter(s):
		0 (optional) : NUMBER - delay between spawn of each unit (default: 1.0)
        1 (optional) : STRING - name of a marker to initialize spawn of static units (default: "mkr_spawn_static_unit")
        2 (optional) : BOOL - enable/disable cleaning of dead units (default: True)
        3 (optional) : NUMBER - timer to clean bodies of dead units (default: 600.0)
        4 (optional) : BOOL - enable/disable cleaning of destroyed vehicles (default: False)
        5 (optional) : NUMBER - timer to clean destroyed vehicles (default: 3600.0)
        6 (optional) : BOOL - enable/disable fatigue of IA (default: True)
        7 (optional) : BOOL - enable/disable cleaning of vehicle's inventories (default: True)
        8 (optional) : BOOL - enable/disable infinite fuel for vehicles (default: True)
        9 (optional) : STRING - rank of group's leaders (default: "COLONEL")

	Returns:
	nothing
*/

params [["_ia_spawn_delay", 1.0],
        ["_ia_spawn_static_unit_marker_name", "mkr_spawn_static_unit"],
        ["_ia_clean_bodies", True], 
        ["_ia_clean_bodies_timer", 600.0], 
        ["_ia_clean_dead_vehicles", False],
        ["_ia_clean_dead_vehicles_timer", 3600.0],
        ["_ia_fatigue_disabled", True],
        ["_ia_vehicles_remove_inventory", True],
        ["_ia_vehicles_infinite_fuel", True],
        ["_ia_rank_leader", "COLONEL"]];
LUCY_INIT = FALSE;

// Load default configuration
// *** LUCY IA CONFIGURATION ***
// Spawn delay between each unit
LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT = _ia_spawn_delay;
// Marker name to temporary spawn static units before move to their position
LUCY_IA_MARKER_SPAWN_STATIC_UNIT_NAME = _ia_spawn_static_unit_marker_name;
// Enable/Disable the remove of IAs bodies
LUCY_IA_CLEAN_BODIES = _ia_clean_bodies;
// Set timer before remove IA body after death in seconds
LUCY_IA_CLEAN_BODIES_TIMER = _ia_clean_bodies_timer;
// Enable/Disable the remove of IAs dead vehicles
LUCY_IA_CLEAN_DEAD_VEHICLES = _ia_clean_dead_vehicles;
// Set timer before remove IA vehicles after death in seconds
LUCY_IA_CLEAN_DEAD_VEHICLES_TIMER = _ia_clean_dead_vehicles_timer;
// Enable/Disable IAs fatigue
LUCY_IA_FATIGUE_DISABLED = _ia_fatigue_disabled;
// Remove all inventory of all vehicles
LUCY_IA_REMOVE_VEHICLES_INVENTORY = _ia_vehicles_remove_inventory;
// Set a refuel every 5min for vehicles
LUCY_IA_INFINITE_FUEL = _ia_vehicles_infinite_fuel;
// Rank of IAs groups leaders
LUCY_IA_RANK_LEADER = _ia_rank_leader;

// Maximum waiting time before waypoint completion for random patrols in area
LUCY_RANDOM_PATROL_MAX_TIMEOUT = 1;


// Configure if we are a HC !
LUCY_LOCAL_SPAWN_UNIT = nil;
if !(isMultiplayer) then {
    if (isServer) then {
        // Editing mode, enable spawn units
        LUCY_LOCAL_SPAWN_UNIT = True;
    };
} else {
    if !(hasInterface or isServer) then {
        // HC, spawn units 
        LUCY_LOCAL_SPAWN_UNIT = True;
    }
    else {
        // Not HC, don't spawn units
        LUCY_LOCAL_SPAWN_UNIT = False;
    };
};

// Constants
LUCY_UNIT_TYPE          = "LUCY_UNIT_TYPE";
LUCY_UNIT_TYPE_STATIC   = "LUCY_UNIT_STATIC";
LUCY_UNIT_TYPE_MOVE     = "LUCY_UNIT_MOVE";

//LUCY_CIVILIAN_STATE             = "LUCY_CIVILIAN_STATE";
//LUCY_CIVILIAN_STATE_IDLE        = "LUCY_CIVILIAN_STATE_IDLE";
//LUCY_CIVILIAN_STATE_WAITING     = "LUCY_CIVILIAN_STATE_WAITING";
//LUCY_CIVILIAN_STATE_MOVE        = "LUCY_CIVILIAN_STATE_MOVE";
//LUCY_CIVILIAN_STATE_GOTO_COVER  = "LUCY_CIVILIAN_STATE_GOTO_COVER";
//LUCY_CIVILIAN_STATE_IS_COVERED  = "LUCY_CIVILIAN_STATE_IS_COVERED";

//LUCY_CIVILIAN_RANDOM_ACTION_WAIT                    = 1;
//LUCY_CIVILIAN_RANDOM_ACTION_VISIT_BUILDING          = 0;
//LUCY_CIVILIAN_RANDOM_ACTION_GOTO_RANDOM_POSITION    = 1;
//LUCY_CIVILIAN_RANDOM_ACTION_NUMBER                  = 2;

// Variables
LUCY_SCAN_IN_PROGRESS = False;
LUCY_SPAWN_INF_IN_PROGRESS = False;
LUCY_SPAWN_VEH_IN_PROGRESS = False;
//LUCY_NUM_CIVILIAN_KILLED = 0;
//LUCY_LIST_POI_WEST = [];
//LUCY_LIST_POI_EAST = [];
//LUCY_LIST_POI_INDEPENDENT = [];
//LUCY_LIST_POI_CIVILIAN = [];

// Everything is configured, 
LUCY_INIT = TRUE;
