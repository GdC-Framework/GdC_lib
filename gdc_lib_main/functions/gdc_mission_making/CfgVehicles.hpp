
class Logic;
class Module_F: Logic
{
	class AttributesBase
	{
		class Checkbox; // Default checkbox (returned value is Bool)
	};
	class ModuleDescription;
};
class GDC_ModuleGdc: Module_F
{
	// Standard object definitions
	scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
	scopeCurator = 0; // Hide to zeus

	displayName = "Module d'initialisation GDC"; // Name displayed in the menu
	// icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
	category = "GDC_moduleGdc";

	// Name of function triggered once conditions are met
	function = "GDC_fnc_moduleGdc";
	// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
	functionPriority = 1;
	// 0 for server only execution, 1 for global execution, 2 for persistent global execution
	isGlobal = 1;
	// 1 for module waiting until all synced triggers are activated
	isTriggerActivated = 0;
	// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
	isDisposable = 1;
	// // 1 to run init function in Eden Editor as well
	is3DEN = 0;
	isSingular = 1;

	// Menu displayed when the module is placed or double-clicked on by Zeus
	curatorInfoType = "RscDisplayAttributeModuleGdc";


	// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
	class Attributes: AttributesBase
	{
		class Inventory: Checkbox {
			property = "GDC_fnc_moduleGdc_inventory"
			displayName = "Inventaire";
			tooltip = "Afficher l'inventaire lors du briefing";
			typeName = "BOOL";
			defaultValue = 1;
		};
		class Roster: Checkbox {
			property = "GDC_fnc_moduleGdc_roster"
			displayName = "Roster";
			tooltip = "Afficher la composition des équipes lors du briefing";
			typeName = "BOOL";
			defaultValue = 1;
		};
		class AcreSpectator: Checkbox {
			property = "GDC_fnc_moduleGdc_acrespectator"
			displayName = "Acre spectateur";
			tooltip = "Permet aux spectateurs d'écouter les autres joueurs via acre";
			typeName = "BOOL";
			defaultValue = 1;
		};
		class DeleteSeagull: Checkbox {
			property = "GDC_fnc_moduleGdc_deleteSeagull"
			displayName = "Suppression de la mouette";
			tooltip = "Supprime la mouette créée quand un joueur devient spectateur";
			typeName = "BOOL";
			defaultValue = 1;
		};
	};
	
	class ModuleDescription: ModuleDescription {
		description = "Initialise les scripts de base pour une mission canard proof !";
		sync[] = {};
	};
};
