// Remove dead body after death with timer

params [["_vehicle", nil]];

if(!isNil "_vehicle") then {

	switch (true) do {
		// Boat, so we want only water
		case ((vehicle _vehicle) iskindof "ship"): {
			["ground"];
		};
		// Air could go everywhere... 
		case ((vehicle _vehicle) iskindof "Air"): {
			[];
		};
		default {
			// If already on water, for example diver could go on water, but exclude else
			if(surfaceIsWater (getpos _vehicle)) then {
				[];
			} else {
				["water"];
			};
		};
	};

} else {
	[];
};

