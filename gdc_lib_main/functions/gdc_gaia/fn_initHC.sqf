
if !(isMultiplayer) then {
  if (isServer) then {
    // If singleplayer and server => local test
    MCC_GAIA_HC = false; // TODO: Check if could be removed
    _this spawn GDC_GAIA_FNC_internalInit;
  };
} else {
  if !(hasInterface or isServer) then {
    // HC 
    MCC_GAIA_HC = true; // TODO: Check if could be removed
    _this spawn GDC_GAIA_FNC_internalInit;

    // IF HC these scripts doesn't work
    /*
      fn_ambientCombatServer
    */
  };
};

