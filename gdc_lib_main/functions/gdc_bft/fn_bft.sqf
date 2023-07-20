/**
 * @brief Initialize BFT on current machine.
 *
 * @param {String} [_itemcondition = itemMap] Item giving access to BFT.
 * @param {Array} [_otherObjects = []] objects that should appear on BFT
 * devices.
 * @param {Number} [_interval = 5] BFT refresh interval.
 * @param {Boolean} [_3DBFT = false] Activate 3D BFT.
 *
 * @return true on completed
 *
 * @author: Migoyan, based on Sparfell & Morbakos work.
 */
params [
	['_itemcondition',"itemMap",[""]],
	['_otherobjects',[],[[]]],
	['_interval',5,[5]],
	['_3DBFT', false, [true]]
];

gdc_bftItemCondition = _itemcondition;
gdc_bftOtherObjects = _otherObjects;
gdc_bftInterval = _interval;
gdc_3DBFT = _3DBFT;

// We want to avoid erasing possible other Draw3D defined events
// If you have a better solution to store index of missionEventHandlers, please
// share it
gdc_appearing3DBFTDevices = [];

private _action = [
	"gdc_bft_action",
	"BFT",
	"a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",
	{
		if (!dialog) then {createDialog "gdc_bft_display";};
	},
	{
		params ["_target","_player","_params"];

		(items _player) findIf {
			_x isKindOf [_params#0, (configFile >> "CfgWeapons")]
			|| {_x isKindOf _params#0}
		} isNotEqualTo -1;
	},
	{},
	[_itemcondition]
] call ace_interact_menu_fnc_createAction;

[
	"CAManBase",
	1,
	["ACE_SelfActions"],
	_action,
	true
] call ace_interact_menu_fnc_addActionToClass;

private _text = format [
"<font size='20'>Blue Force Tracker :</font><br/><br/>

Les joueurs qui possèdent un <font color='#FF0000'>%1</font> peuvent
 ajouter un marqueur BFT au moyen de l'action disponible dans le menu
 d'interaction sur soi de ACE.<br/><br/>

Seuls les joueurs qui disposent d'un <font color='#FF0000'>%1</font>
 peuvent voir les marqueurs BFT.<br/><br/>

<font size='15'>Légende :</font>",
	(getText (configfile >> "CfgWeapons" >> _itemcondition >> "displayname"))
];
{
	_text = _text + format [
		"<br/><img image='%1' width='32' height='32'/> %2",
		(getText (configfile >> "CfgMarkers" >> _x >> "icon")),
		(getText (configfile >> "CfgMarkers" >> _x >> "name"))
	];
} forEach [
	"b_inf","b_motor_inf","b_armor","b_mech_inf","b_air","b_plane","b_uav",
	"b_art","b_naval","b_hq","b_med"
];
player createDiarySubject ["gdc_bft","BFT"];
player createDiaryRecord ["gdc_bft", ["Instructions",_text]];

[
	{
		(_this#0) params['_player', '_itemcondition'];

		{
			deleteMarkerLocal _x;
		} forEach (allMapMarkers select {"gdc_bft_" in _x});

		{
			removeMissionEventHandler ['Draw3D', _x];
		} forEach gdc_appearing3DBFTDevices;

		if ((items _player) findIf {
			_x isKindOf [_itemCondition, (configFile >> "CfgWeapons")]
			|| {_x isKindOf _itemCondition}
		} isNotEqualTo -1) then {
			private _activatedBFTDevices = [
				_itemCondition, gdc_bftOtherObjects
			] call gdc_fnc_bftUpdateList;

			gdc_appearing3DBFTDevices = [
				_activatedBFTDevices
			] call gdc_fnc_bftDrawMarkers;
		};
	},
	_interval,
	[player, _itemcondition]
] call CBA_fnc_addPerFrameHandler;

true
