local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
ShowPetStamina = _G["ADDONS"]["SHOWPETSTAMINA"] or {};

function SHOWPETSTAMINA_ON_INIT(addon, frame)
    ShowPetStamina.addon = addon;
	ShowPetStamina.frame = frame;
	
	SHOWPETSTAMINA_INIT();
end

function SHOW_MOUNTED_STAMINA()
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

function SHOWPETSTAMINA_INIT()
	acutil.setupEvent(ShowPetStamina.addon, "ON_RIDING_VEHICLE", "SHOW_MOUNTED_STAMINA")
	acutil.setupEvent(ShowPetStamina.addon, "UPDATE_COMPANION_TITLE", "SHOW_MOUNTED_STAMINA")
end

ui.SysMsg("Showing pet stamina when mounted!")