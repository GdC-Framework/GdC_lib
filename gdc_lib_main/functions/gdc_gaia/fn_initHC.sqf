
if !(isMultiplayer) then {
  if (isServer) then {
    // If singleplayer and server => local test
    _this spawn GDC_GAIA_FNC_internalInit;
  };
} else {
  if !(hasInterface or isServer) then {
    // HC
    _this spawn GDC_GAIA_FNC_internalInit;
  };
};
