local function showMountedStamina()
    local pc = GetMyPCObject();
    local ridingAttributeCheck = GetAbility(pc, "CompanionRide");
    local petInfo = session.pet.GetSummonedPet();
    local obj = GetIES(petInfo:GetObject());
    local myActor = GetMyActor();
    local charBaseFrame = ui.GetFrame("charbaseinfo1_my");
        
    if ridingAttributeCheck ~= nil then
        if myActor:GetVehicleState() then
            local staminaGauge = charBaseFrame:CreateOrGetControl("gauge", "mountedStaminaGauge", 0, 0, 104, 10);
            tolua.cast(staminaGauge, "ui::CGauge");
    
            staminaGauge:SetPoint(obj.Stamina, obj.MaxStamina);
            staminaGauge:SetGravity(ui.CENTER_HORZ, ui.TOP)
            staminaGauge:SetSkinName('pcinfo_gauge_sta2');
            staminaGauge:Resize(staminaGauge:GetWidth(), staminaGauge:GetHeight())
            staminaGauge:Invalidate();
        else
            charBaseFrame:RemoveChild('mountedStaminaGauge');
        end
        
        charBaseFrame:Invalidate();
    end
end

function UPDATE_COMPANION_TITLE_HOOKED(frame, handle)
    _G["UPDATE_COMPANION_TITLE_OLD"](frame, handle);
    showMountedStamina();
end

function ON_RIDING_VEHICLE_HOOKED(onoff)
    _G["ON_RIDING_VEHICLE_OLD"](onoff)
    showMountedStamina();
end

-- Adapter for addonloaders

if cwAPI then
    _G['UPDATE_COMPANION_TITLE_OLD'] = _G['UPDATE_COMPANION_TITLE'];
    _G['ON_RIDING_VEHICLE_OLD'] = _G['ON_RIDING_VEHICLE'];
    
    _G['ADDON_LOADER']['showpetstamina'] = function()
        cwAPI.events.on('UPDATE_COMPANION_TITLE',UPDATE_COMPANION_TITLE_HOOKED,1);
        cwAPI.events.on('ON_RIDING_VEHICLE',ON_RIDING_VEHICLE_HOOKED,1);
        
        return true;
    end
else
    SETUP_HOOK(UPDATE_COMPANION_TITLE_HOOKED, "UPDATE_COMPANION_TITLE")
    SETUP_HOOK(ON_RIDING_VEHICLE_HOOKED, "ON_RIDING_VEHICLE")
end

ui.SysMsg("Showing pet stamina when mounted!")