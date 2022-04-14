_isFilterActive = false;
{
	_ctrl = uiNamespace getVariable _x;
	if !(cbChecked _ctrl) exitWith {
		_isFilterActive = true;
	};
} forEach tbAllCtrl;

_btn = uiNamespace getVariable "BtnMrkFilter";
if (_isFilterActive) then {
	_btn ctrlSetTextColor [1,0.2,0.2,1];
} else {
	_btn ctrlSetTextColor [1,1,1,1];
}
