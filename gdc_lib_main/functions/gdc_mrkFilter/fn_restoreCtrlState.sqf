{
	_ctrl = uiNameSpace getVariable (_x#0);
	_ctrl cbSetChecked (_x#1);
} forEach tbCtrlStateA;

//restore BtnMrkFilter state
_btn = uiNamespace getVariable "BtnMrkFilter";
_btnTextColor = uiNamespace getVariable "BtnState";
_btnTextColor = _btn ctrlSetTextColor _btnTextColor;