/*
 * add Splints and remove PAK on mission start if needed.
 * 
 * Parameters
 * None
 *
 * Return : Nothing
*/
if (! isNil "GDC_disableAddSplints") exitwith {};
[
	"ACE_personalAidKit",
	["ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint","ACE_splint"]
] call ace_common_fnc_registerItemReplacement;