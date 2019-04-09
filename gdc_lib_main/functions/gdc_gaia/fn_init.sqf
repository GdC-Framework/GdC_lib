// Init for server
if (!isServer) exitWith {};

MCC_GAIA_HC = false; // TODO: Check if could be removed
_this spawn GDC_GAIA_FNC_internalInit;
