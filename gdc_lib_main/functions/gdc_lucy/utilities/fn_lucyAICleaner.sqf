// Remove dead body after death with timer

params ["_ai", "_timer"];

// Select IA
_ai = _ai select 0;
sleep _timer;
deleteVehicle _ai;
