/**
 * @brief Return the list of object that should appear on bft devices
 *
 * @param {String} [_itemCondition = "itemMap"] BFT device className
 * @param {Array} [_otherObjects = []] objects that should appear on bft
 * devices.
 *
 * @return {Array} list of objects
 *
 * @author: Migoyan, based on Sparfell & Morbakos work.
 */
params[["_itemCondition", "itemMap", [""]], ["_otherObjects", [], [[]]]];

private _playerObjects = (playableUnits + switchableUnits) select {
	(items _x) findIf {
		_x isKindOf [_itemCondition, (configFile >> "CfgWeapons")]
		|| {_x isKindOf _itemCondition}
	} isNotEqualTo -1
	&& (_x getvariable ["gdc_bft_activated",false])
	&& !(_x in _otherobjects)
};

_playerObjects + _otherObjects
