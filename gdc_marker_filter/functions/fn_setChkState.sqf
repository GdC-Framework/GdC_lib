params ["_tbChk","_state"];

private _chk = objNull;

{
	_chk = uiNameSpace getVariable _x;
	_chk cbSetChecked _state
} forEach _tbChk;
