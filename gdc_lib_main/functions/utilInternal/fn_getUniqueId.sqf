/*
	Author: Shinriel

	Description:
		Extract the unique identifier from an object.

	Parameter(s):
		0 : OBJECT - Object that we have to extract the uid

	Returns:
		string: return the variable name of the object if there is one, else return the unique id when the object were generated.
*/

private ["_obj", "_id", "_find"];

_obj = str(param[0,objNull]);
_id = ""; 

_find = (_obj find "#");
if (_find > 1) then {
	// format: "1ba2bed4100# 8: office_chair.p3d"
	// => UID#Eden ID: object model
    _id = _obj select [0, _find];
};

if(count _id == 0) then {
	// If there is a variableName for this object
    _id = str _obj;
};

_id
