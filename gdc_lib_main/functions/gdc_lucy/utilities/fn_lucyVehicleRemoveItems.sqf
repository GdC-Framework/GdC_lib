// Nettoyage du contenu d'un vehicule

if (! isServer) exitWith {};

_current_vehicle = _this select 0;

clearMagazineCargoGlobal _current_vehicle;
clearWeaponCargoGlobal _current_vehicle;
clearItemCargoGlobal _current_vehicle;
clearBackpackCargoGlobal _current_vehicle;
