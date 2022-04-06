/*
	Author: Mystery

	Description:
	Init function for gdc_lucy, a library of functions to simplify edition life

	Parameter(s):
		0 (optional) : NUMBER - delay between spawn of each unit (default: 1.0)
        1 (optional) : STRING - name of a marker to initialize spawn of static units (default: "mkr_spawn_static_unit")
        2 (optional) : BOOL - enable/disable cleaning of dead units (default: True)
        3 (optional) : NUMBER - timer to clean bodies of dead units (default: 3600.0)
        4 (optional) : BOOL - enable/disable cleaning of destroyed vehicles (default: False)
        5 (optional) : NUMBER - timer to clean destroyed vehicles (default: 3600.0)
        6 (optional) : BOOL - enable/disable fatigue of IA (default: True)
        7 (optional) : BOOL - enable/disable cleaning of vehicle's inventories (default: True)
        8 (optional) : STRING - rank of group's leaders (default: "COLONEL")
        9 (optional) : BOOL - remove empty groups (default: False)

	Returns:
	nothing
*/

params [["_ia_spawn_delay", 1.0, [0]],
        ["_ia_spawn_pos_static_unit", "mkr_spawn_static_unit", ["",[]]],
        ["_ia_clean_bodies", true, [true]], 
        ["_ia_clean_bodies_timer", 3600.0, [0]], 
        ["_ia_clean_dead_vehicles", false, [true]],
        ["_ia_clean_dead_vehicles_timer", 3600.0, [0]],
        ["_ia_fatigue_disabled", true, [true]],
        ["_ia_vehicles_remove_inventory", true, [true]],
        ["_ia_rank_leader", "COLONEL", [""]],
        ["_ia_remove_empty_groups", false, [true]]
];
LUCY_INIT = FALSE;

// Load default configuration
// *** LUCY IA CONFIGURATION ***
// Spawn delay between each unit
LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT = _ia_spawn_delay;
LUCY_IA_DELAY_BETWEEN_SPAWN_UNIT_REFRESH = 1 min _ia_spawn_delay;
// Position to temporary spawn static units before move to their position
if (_ia_spawn_pos_static_unit isEqualType "") then {
    if (getMarkerType _ia_spawn_pos_static_unit == "") then {
        // When the marker doesn't exist Arma return [0,0,0] for the marker position, so we spawn the unit 500 meters above the water
        _ia_spawn_pos_static_unit = getMarkerPos _ia_spawn_pos_static_unit;
        _ia_spawn_pos_static_unit set [2, 500];
    } else {
        // If the player has defined the marker, he's responsible of its own ****
        _ia_spawn_pos_static_unit = getMarkerPos _ia_spawn_pos_static_unit;
    };
};
LUCY_IA_STATIC_UNIT_SPAWN_POS = _ia_spawn_pos_static_unit;
LUCY_IA_MARKER_SPAWN_STATIC_UNIT_NAME = _ia_spawn_pos_static_unit; //legacy
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
// Rank of IAs groups leaders
LUCY_IA_RANK_LEADER = _ia_rank_leader;
// Remove Empty Groups 
LUCY_IA_REMOVE_EMPTY_GROUPS = _ia_remove_empty_groups;

// Maximum waiting time before waypoint completion for random patrols in area
LUCY_RANDOM_PATROL_MAX_TIMEOUT = 1;


// Configure if we are a HC !
LUCY_LOCAL_SPAWN_UNIT = nil;
if !(isMultiplayer) then {
    if (isServer) then {
        // Editing mode, enable spawn units
        LUCY_LOCAL_SPAWN_UNIT = true;
    };
} else {
    if !(hasInterface or isServer) then {
        // HC, spawn units 
        LUCY_LOCAL_SPAWN_UNIT = true;
    }
    else {
        // Not HC, don't spawn units
        LUCY_LOCAL_SPAWN_UNIT = false;
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
LUCY_SCAN_IN_PROGRESS = false;
LUCY_SPAWN_INF_IN_PROGRESS = false;
LUCY_SPAWN_VEH_IN_PROGRESS = false;
//LUCY_NUM_CIVILIAN_KILLED = 0;
//LUCY_LIST_POI_WEST = [];
//LUCY_LIST_POI_EAST = [];
//LUCY_LIST_POI_INDEPENDENT = [];
//LUCY_LIST_POI_CIVILIAN = [];

// Script to configure IA loadouts
LUCY_SCRIPT_CONFIG_LOADOUT_IA_ENABLED = false;
LUCY_SCRIPT_CONFIG_LOADOUT_IA = objNull;

// Everything is configured, 
LUCY_INIT = true;
