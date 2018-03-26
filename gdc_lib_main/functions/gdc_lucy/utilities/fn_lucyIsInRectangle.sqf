/*
	Author: extracted from GAIA

	Description:
	Check if a position is in a rectangle marker

	Parameter(s):
		0 : ARRAY - position
		1 : OBJECT - rectangle marker

	Returns:
	True/False
*/

private ["_pos","_area","_return"];
_pos = _this select 0;
_area = _this select 1;
_return = False;

private ["_mPos", "_mPosX", "_mPosY", "_mSize","_mSizeX","_mSizeY", "_mAngle"];
_mPos = getMarkerPos _area;
_mPosX = _mPos select 0;
_mPosY = _mPos select 1;
_mSize  = getMarkerSize _area;
_mSizeX = _mSize select 0;
_mSizeY = _mSize select 1;
_mAngle = markerDir _area;
_mAngle = _mAngle % 360;

private ["_posX","_posY", "_newPos", "_newPosX", "_newPosY"];
_posX = _pos select 0;
_posY = _pos select 1;

// If marker is not axis-aligned, rotate the dot position.
if (_mAngle % 360 != 0) then {
  private ["_orgX","_orgY","_shiftedX","_shiftedY"];
  _orgX = _pos select 0;
  _orgY = _pos select 1;
  _shiftedX = _orgX - _mPosX;
  _shiftedY = _orgY - _mPosY;
  _pos = [[_shiftedX,_shiftedY], _mAngle] call GDC_fnc_lucyRotatePosition;
  _pos set [0,(_pos select 0) + _mPosX];
  _pos set [1,(_pos select 1) + _mPosY];
};

_newPosX = _pos select 0;
_newPosY = _pos select 1;

if (_newPosX > (_mPosX - _mSizeX) && _newPosX < (_mPosX + _mSizeX) && _newPosY > (_mPosY - _mSizeY) && _newPosY < (_mPosY + _mSizeY)) then {
    _return = True;
};


_return
