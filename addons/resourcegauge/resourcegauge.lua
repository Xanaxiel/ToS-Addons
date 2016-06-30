local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
ResourceGauge = _G["ADDONS"]["RESOURCEGAUGE"] or {};

function RESOURCEGAUGE_ON_INIT(addon, frame)
    ResourceGauge.addon = addon;
	ResourceGauge.frame = frame;
	
	RESOURCEGAUGE_INIT();
end

local function getDeadPartsCount()
	local myEtcPc = GetMyEtcObject();
	return myEtcPc.Necro_DeadPartsCnt, 300;
end

local function getPetStamina()
	local petInfo = session.pet.GetSummonedPet();
	if petInfo ~= nil then
		local petObj = GetIES(petInfo:GetObject());
		return petObj.Stamina, petObj.MaxStamina
	end
	return 0, 0
end

local function canMount()
	local pc = GetMyPCObject();
    local hasRidingAttribute = GetAbility(pc, "CompanionRide");
    if hasRidingAttribute ~= nil then
    	return true
    end
    return false
end

local function isMounted()
	local myActor = GetMyActor();
	if myActor:GetVehicleState() then
		return true
	end
	return false
end

local function hasNecronomicon()
	local frame = ui.GetFrame("sysmenu");
	local necronomicon = GET_CHILD(frame, "necronomicon", "ui::CButton");
	if necronomicon ~= nil then
		return true
	end
	return false
end

local function hasPoisonPot()
	local frame = ui.GetFrame("sysmenu");
	local poisonpot = GET_CHILD(frame, "poisonpot", "ui::CButton");
	if poisonpot ~= nil then
		return true
	end
	return false
end

local function getPoisonCount()
	local myEtcPc = GetMyEtcObject();
	local poisonAmount = myEtcPc['Wugushi_PoisonAmount']
	local poisonMaxAmount = myEtcPc['Wugushi_PoisonMaxAmount']
	return poisonAmount, poisonMaxAmount
end

local staminaSkin = "pcinfo_gauge_sta2"
local resourceSkin = "gauge_itemtooltip_poten"
local petStaminaGauge = "petStaminaGauge"
local corpseGauge = "corpseGauge"
local poisonPotGauge = "poisonPotGauge"

function DRAW_RESOURCEGAUGE(frame, gaugeType, minMaxFunc, skin)
	local resourceGauge = frame:CreateOrGetControl("gauge", gaugeType, 0, 0, 104, 10);
    tolua.cast(resourceGauge, "ui::CGauge");
    resourceGauge:SetPoint(minMaxFunc())
    resourceGauge:SetGravity(ui.CENTER_HORZ, ui.TOP)
    resourceGauge:SetSkinName(skin)
    resourceGauge:Resize(resourceGauge:GetWidth(), resourceGauge:GetHeight())
    resourceGauge:Invalidate();
end
	
function GAUGE_FACTORY(gaugeType)
	local frame = ui.GetFrame("charbaseinfo1_my");
	if gaugeType == petStaminaGauge then
		if not ShowPetStamina then
			if canMount() then
				if isMounted() then
					DRAW_RESOURCEGAUGE(frame, gaugeType, getPetStamina, staminaSkin)
				else
					frame:RemoveChild(petStaminaGauge)
				end
			end
		end
	elseif gaugeType == corpseGauge then
		if hasNecronomicon() then
			DRAW_RESOURCEGAUGE(frame, gaugeType, getDeadPartsCount, resourceSkin)
		end
	elseif gaugeType == poisonPotGauge then
		if hasPoisonPot() then
			DRAW_RESOURCEGAUGE(frame, gaugeType, getPoisonCount, resourceSkin)
		end
	end
	frame:Invalidate();
end

function MOUNTED_PET_STAMINA_GAUGE()
	GAUGE_FACTORY(petStaminaGauge)
end

function NECROMANCER_CORPSE_GAUGE()
	GAUGE_FACTORY(corpseGauge)
end

function WUGUSHI_POISON_POT_GAUGE()
	GAUGE_FACTORY(poisonPotGauge)
end

function RESOURCEGAUGE_INIT()
	acutil.setupEvent(ResourceGauge.addon, "ON_RIDING_VEHICLE", "MOUNTED_PET_STAMINA_GAUGE")
	acutil.setupEvent(ResourceGauge.addon, "UPDATE_COMPANION_TITLE", "MOUNTED_PET_STAMINA_GAUGE")
	
	acutil.setupEvent(ResourceGauge.addon, "FPS_UPDATE", "NECROMANCER_CORPSE_GAUGE")
	acutil.setupEvent(ResourceGauge.addon, "FPS_UPDATE", "WUGUSHI_POISON_POT_GAUGE")
	
	ui.SysMsg("Resource gauge loaded!")
end