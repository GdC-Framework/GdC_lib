/**
 * @brief Function drawing 3D icons on BFT devices for concerned unit. This
 * function has to be executed on the player's computer.
 *
 * @param {array} _bftObjects, Objects appearing on BFT.
 *
 * @return {array}, array with 3DBFT event handlers
 * @author: Migoyan
 */
params['_bftObjects'];
private[
	'_appearing3DBFTDevices', '_event_index', '_marker', '_markerColor',
	'_markerText', '_markerType', '_texture', '_objVehicle'
];

_appearing3DBFTDevices = [];

{
	_markerText = _x getVariable [
		"gdc_bft_markertext",
		if (_x isKindOf "Man") then {
			groupId (group _x)
		} else {
			getText (
				configfile >> "CfgVehicles" >> (typeOf _x) >> "displayname"
			)
		}
	];

	// Player inside BFT vehicles are skipped
	_objVehicle = vehicle _x;
	if (
		_objVehicle isNotEqualTo _x
		and _objVehicle in gdc_bftOtherObjects
	) then {
		continue;
	};

	if (_x in gdc_bftOtherObjects) then {
		{
			_markerText = _markerText + " + "
			+ (_x getVariable [
				"gdc_bft_markertext",
				if (_x isKindOf "Man") then {
					groupId (group _x)
				} else {
					gettext (
						configfile >> "CfgVehicles" >>
						(typeOf _x) >> "displayname"
					)
				}
			]);
		} forEach (
			(crew _x) arrayIntersect (
				_bftObjects select {(vehicle _x) isNotEqualTo _x}
			)
		);
	};

	// ace_common_fnc_getMarkerType give us a good marker in case no marker is
	// defined
	_markerType = (
		_x getVariable [
			"gdc_bft_markertype",
			[([group _x] call ace_common_fnc_getMarkerType), 0]
		]
	)#0;

	_markerColor = (
		_x getVariable ["gdc_bft_markercolor",["colorBLUFOR",0]]
	)#0;

	_marker = createMarkerLocal [
		format ["gdc_bft_%1", _x],
		getPos _x
	];
	_marker setMarkerTextLocal _markerText;
	_marker setMarkerTypeLocal _markerType;
	_marker setMarkerColorLocal _markerColor;

	if (gdc_3DBFT) then {
		_texture = getText (
			ConfigFile >> 'CfgMarkers' >> _markerType >> 'icon'
		);
		_colour = getArray (
			ConfigFile >> 'CfgMarkerColors' >> _markerColor >> 'color'
		) call BIS_fnc_colorConfigToRGBA;
		_appearing3DBFTDevices pushBack addMissionEventHandler [
			"Draw3D",
			{
				drawIcon3D [
					_thisArgs#1,
					_thisArgs#3,
					_thisArgs#0 modelToWorldVisual [0, 0, 1.5],
					1,
					1,
					0
				];
			},
			[_x, _texture, _markerText, _colour]
		];
	};

} forEach _bftObjects;

_appearing3DBFTDevices
