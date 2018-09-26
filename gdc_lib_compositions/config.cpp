/*
Exporter une composition :
1 - sélectionnez les objets de la composition dans 3DEN
2 - ouvrez la console de debug dans 3DEN
3 - exécutez la commande ci dessous :
[(screenToWorld [0.5,0.5]),(get3DENSelected "object")] call BIS_fnc_exportCfgGroups;
Le premier paramètre correspond au centre de la compositions. La position des objets est calculée en fonction de ce centre. Ce centre correspond à la position du pointeur souris au moment où vous cliquez pour créer la composition.
Dans le cas ci-dessus, le centre choisi est le centre de votre écran.
4 - collez le contenu qui du presse papier au bon endroit dans la config.
*/


class CfgPatches
{
	class gdc_lib_compositions
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"gdc_lib_main"};
	};
};

class CfgGroups
{
	class Empty
	{
		class GDC
		{
			name = "GDC";
			class test // Catégorie de classement (possible d'en ajouter d'autres)
			{
				name = "cat compo test"; // Nom de la catégorie
				class test_compo // Nouvelle composition
				{
					name = "compo test"; // Nom de la composition
					side = 8;
					icon = "\a3\Ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa";
					// Ci-dessous le contenu exporté depuis 3DEN
					class Object0	{side = 8; vehicle = "Land_CampingChair_V2_F"; rank = ""; position[] = {-0.337891,-0.137695,0}; dir = 188.097;};
					class Object1	{side = 8; vehicle = "Land_CampingTable_F"; rank = ""; position[] = {0.169434,0.325928,0}; dir = 0;};
					class Object2	{side = 8; vehicle = "Land_Noticeboard_F"; rank = ""; position[] = {1.6416,0.371338,0}; dir = 88.376;};
				};
			};
		};
		
		class GDC
		{
			name = "GDC";
			class test // Catégorie de classement (possible d'en ajouter d'autres)
			{
				name = "cat compo test"; // Nom de la catégorie
				class test_compo // Nouvelle composition
				{
					name = "Tente fortifiée"; // Nom de la composition
					side = 8;
					icon = "\a3\Ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa";
					// Ci-dessous le contenu exporté depuis 3DEN
					class Object0	{side = 8; vehicle = ""Land_MedicalTent_01_MTP_closed_F""; rank = """"; position[] = {-6.61426,3.90125,0}; dir = 0;};
					class Object1	{side = 8; vehicle = ""Land_MedicalTent_01_floor_light_F""; rank = """"; position[] = {-6.62811,3.84851,0}; dir = 0;};
					class Object2	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-0.735413,-1.22253,0}; dir = 270;};
					class Object3	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-0.735413,4.40247,0}; dir = 270;};
					class Object4	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-0.627258,-1.32349,1.08273}; dir = 270;};
					class Object5	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-0.627258,4.30151,1.08273}; dir = 270;};
					class Object6	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.7354,-1.34753,0}; dir = 270;};
					class Object7	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.7354,4.27747,0}; dir = 270;};
					class Object8	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.6273,-1.44849,0.957733}; dir = 270;};
					class Object9	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.6273,4.17651,0.957733}; dir = 270;};
					class Object10	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-4.98798,10.2723,0}; dir = 0;};
					class Object11	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-5.08899,10.1642,0.957733}; dir = 0;};
					class Object12	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.863,10.2723,0}; dir = 0;};
					class Object13	{side = 8; vehicle = ""Land_HBarrier_5_F""; rank = """"; position[] = {-12.964,10.1642,0.957733}; dir = 0;};
				};
			};
		};
	};
};