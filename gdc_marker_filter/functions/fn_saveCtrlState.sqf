params ["_tbCtrl"];
GDC_tbCtrlStateA = [];
{
	_ctrl = uiNameSpace getVariable _x;
	_ctrlState = cbChecked _ctrl;
	GDC_tbCtrlStateA pushBack [_x, _ctrlState];
} forEach _tbCtrl;

//save BtnMrkFilter state
_btn = uiNamespace getVariable "BtnMrkFilter";
_btnTextColor = ctrlTextColor _btn;
uiNamespace setVariable ["BtnState", _btnTextColor];
