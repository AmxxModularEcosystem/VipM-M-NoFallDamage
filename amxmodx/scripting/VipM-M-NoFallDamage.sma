#include <amxmodx>
#include <reapi>
#include <VipModular>

new const MODULE_NAME[] = "NoFallDamage";

public VipM_OnInitModules() {
    register_plugin("[VipM-M] No Fall Damage", "1.0.0", "ArKaNeMaN");

    VipM_Modules_Register(MODULE_NAME);
    VipM_Modules_AddParams(MODULE_NAME,
        "Multiplier", ptFloat, false
    );
    VipM_Modules_RegisterEvent(MODULE_NAME, Module_OnActivated, "@OnModuleActivated");
}

@OnModuleActivated() {
    RegisterHookChain(RG_CSGameRules_FlPlayerFallDamage, "@OnPlayerFallDamage", .post = false);
}

@OnPlayerFallDamage(const playerIndex) {
    new Float:dmg = GetHookChainReturn(ATYPE_FLOAT);

    if (!VipM_Modules_HasModule(MODULE_NAME, playerIndex)) {
        return HC_CONTINUE;
    }

    new Float:multiplier = 0.0;
    TrieGetCell(VipM_Modules_GetParams(MODULE_NAME, playerIndex), "Multiplier", multiplier);

    SetHookChainReturn(ATYPE_FLOAT, dmg * multiplier);
    return HC_SUPERCEDE;
}