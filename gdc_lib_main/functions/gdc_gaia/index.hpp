class GDC_GAIA
{
    tag = "GDC_gaia";

    class init
    {
        file = "gdc_lib_main\functions\gdc_gaia";

        class init {}; // TODO: To be review to be executed like => call compile preprocessfile "gaia\gaia_init.sqf";
    };

    class ambient
    {
        file = "gdc_lib_main\functions\gdc_gaia\ambient";

        class ambientCombat {};
        class ambientCombatServer {};
        class ambientCombatClient {};
        class getPlayers {};
        class isInMarker {};
        class getsideratio {};
        class SpawnGroup {};
        class ShowLocationOwner {};

    };
    class Cache
    {
        file = "gdc_lib_main\functions\gdc_gaia\cache";

        class cache {};
        class cacheFar {};
        class cacheOriginalGroup {};
        class isNearPlayer {};
        class startGaiaCache {};
        class syncCachedGroup {};
        class uncache {};
        class uncacheFar {};
        class uncacheOriginalGroup {};
    };
    class General
    {
        file = "gdc_lib_main\functions\gdc_gaia\general";

        class controlGroup {};
        class findClosestPosition {};
        class getDirectionalOffsetPosition {};
        class hideGaiaMarker {};
        class startGaia {};
    };
    class Control
    {
        file = "gdc_lib_main\functions\gdc_gaia\control";

        class addAttackWaypoint {};
        class addWaypoint {};
        class analyzeForces {};
        class analyzeTargets {};
        class analyzeTerrain {};
        class calculateOptimalPosition {};
        class classifySide {};
        class doTask {};
        class event {};
        class fireFlare {};
        class generateBuildingPatrolWaypoints {};
        class generateWaypoints {};
        class getConflictAreaCost {};
        class getConflictAreas {};
        class getDistanceToClosestZone {};
        class getTurretWeapons {};
        class getUnitAssets {};
        class getUnitTypeAmounts {};
        class getUnitsClassification {};
        class getZoneIntendOfGroup {};
        class getZoneStatusBehavior {};
        class hasLineOfSight {};
        class isBlacklisted {};
        class isCleared {};
        class issueOrders {};
        class occupy {};
        class removeWaypoints {};

    };
    class Orders
    {
        file = "gdc_lib_main\functions\gdc_gaia\control\orders";

        class doArtillery {};
        class doAttack {};
        class doAttackCar {};
        class doAttackHelicopter {};
        class doAttackInfantry {};
        class doAttackMechanizedInfantry {};
        class doAttackMotorizeInfantry {};
        class doAttackMotorizedRecon {};
        class doAttackRecon {};
        class doAttackShip {};
        class doAttackTank {};
        class doClear {};
        class doClearInfantry {};
        class doClearRecon {};
        class doFortify {};
        class doHide {};
        class doMortar {};
        class doPark {};
        class doPatrol {};
        class doPatrolCar {};
        class doPatrolHelicopter {};
        class doPatrolInfantry {};
        class doPatrolMechanizedInfantry {};
        class doPatrolMotorizedInfantry {};
        class doPatrolMotorizedRecon {};
        class doPatrolRecon {};
        class doPatrolShip {};
        class doSupport {};
        class doTransport {};
        class doTransportAttack {};
        class doTransportCar {};
        class doTransportHelicopter {};
        class doTransportTank {};
        class doWait {};
    };
    class Fortify
    {
        file = "gdc_lib_main\functions\gdc_gaia\control\fortify";

        class taskDefend {};
    };
};
