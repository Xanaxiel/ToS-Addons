-- Original addon created by https://github.com/huenato
local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
WarmodeEX = _G["ADDONS"]["WARMODEEX"] or {};

local defaultSettings={}
local effectSwitch = 1;
local guiSwitch = 1;
local model3dFlag = 1;
local minimalEffectsFlag = 1;

function WARMODEEX_ON_INIT(addon, frame)
	if not WarmodeEX.isLoaded then
		SAVE_DEFAULTS();
		WarmodeEX.isLoaded = true
		acutil.slashCommand("/war3d",TOGGLE_3D)
		acutil.slashCommand("/warmisc",TOGGLE_MINIMAL_EFFECTS)
		acutil.log("WarmodeEx loaded!")
	end

    frame:ShowWindow(1);
    frame:RunUpdateScript("WARMODEEX_UPDATE", 0, 0, 0, 1);
end

function IS_PRESSED(key1, key2)
	if keyboard.IsKeyDown(key1) == 1 and keyboard.IsKeyPressed(key2) == 1 then 
		return true 
	else 
	return false end;
end

function WARMODEEX_UPDATE(frame)

    if IS_PRESSED("NUMPAD0", "LALT") or IS_PRESSED("DELETE", "LALT") then
        WARMODE(0)
    elseif IS_PRESSED("NUMPAD1", "LALT") or IS_PRESSED("END", "LALT") then
        WARMODE(1)
    elseif IS_PRESSED("NUMPAD2", "LALT") or IS_PRESSED("PGUP", "LALT") then
        WARMODE_UI(0)
    elseif IS_PRESSED("NUMPAD3", "LALT") or IS_PRESSED("PGDN", "LALT") then
        WARMODE_UI(1)
    elseif IS_PRESSED("NUMPAD4", "LALT") or IS_PRESSED("INSERT", "LALT") then
        TOGGLE_3D()
	elseif IS_PRESSED("NUMPAD5", "LALT") or IS_PRESSED("HOME", "LALT") then
        TOGGLE_MINIMAL_EFFECTS()
    elseif IS_PRESSED("NUMPAD6", "LALT") or IS_PRESSED("BACKSPACE", "LALT") then
    	RESTORE_DEFAULTS()
    end

    return 1
end

function WARMODE_UI(guiSwitch)
	imcperfOnOff.EnableUIRender(guiSwitch);
end

function WARMODE(effectSwitch)
    imcperfOnOff.EnableIMCEffect(effectSwitch);
    imcperfOnOff.EnableDeadParts(effectSwitch);
    imcperfOnOff.EnableEffect(effectSwitch);

    geScene.option.SetShadowMapSize(effectSwitch);
    geScene.option.SetUseSSAO(effectSwitch);
    geScene.option.SetSSAOMethod(effectSwitch);
    geScene.option.SetUseCharacterWaterReflection(effectSwitch);
    geScene.option.SetUseBGWaterReflection(effectSwitch);
    geScene.option.SetUseShadowMap(effectSwitch);

    graphic.ApplyGammaRamp(effectSwitch);
    graphic.EnableBloom(effectSwitch);
    graphic.EnableBlur(effectSwitch);
    graphic.EnableCharEdge(effectSwitch);
    graphic.EnableDepth(effectSwitch);
    graphic.EnableFXAA(effectSwitch);
    graphic.EnableGlow(effectSwitch);
    graphic.EnableHighTexture(effectSwitch);
    graphic.EnableSharp(effectSwitch);
    graphic.EnableSoftParticle(effectSwitch);
    graphic.EnableStencil(effectSwitch);
    graphic.EnableWater(effectSwitch);
    graphic.EnableHighTexture(effectSwitch);
    
    local flagValue = (effectSwitch == 1 and "enabled" or "disabled")
	acutil.log("Warmode "..flagValue)
end

function SAVE_DEFAULTS()
	for k, v in pairs(imcperfOnOff) do repeat
		if string.match(k, "IsEnable") == nil then break end

		if defaultSettings[k] ~= nil then break end

		if v() ~= nil then
			defaultSettings[k] = v()
		end
	until true end
end

function RESTORE_DEFAULTS()
	local prefix = "Is"
	for k, v in pairs(defaultSettings) do repeat
		if imcperfOnOff[k]() == nil then break end

		local key = string.gsub(k, prefix, "");
		imcperfOnOff[key](v)
	until true end
	acutil.log("Restoring default settings!")
end

function TOGGLE_3D()
	model3dFlag = (model3dFlag == 1 and 0 or 1)
	imcperfOnOff.Enable3DModel(model3dFlag)
	local flagValue = (model3dFlag == 1 and "enabled" or "disabled")
	acutil.log("3D models "..flagValue)
end

function TOGGLE_MINIMAL_EFFECTS()
	minimalEffectsFlag = (minimalEffectsFlag == 1 and 0 or 1)
	imcperfOnOff.EnableWater(minimalEffectsFlag)
    imcperfOnOff.EnableDeadParts(minimalEffectsFlag);
	imcperfOnOff.EnableParticleEffectModel(minimalEffectsFlag)
	imcperfOnOff.EnableSky(minimalEffectsFlag)
	imcperfOnOff.EnableBloomObject(minimalEffectsFlag)
	imcperfOnOff.EnableDepth(minimalEffectsFlag)
	imcperfOnOff.EnableGrass(minimalEffectsFlag)
	imcperfOnOff.EnableFog(minimalEffectsFlag)
	imcperfOnOff.EnablePlaneLight(minimalEffectsFlag)
	imcperfOnOff.EnableLight(minimalEffectsFlag)
	imcperfOnOff.EnableMRT(minimalEffectsFlag)

	local flagValue = (minimalEffectsFlag == 1 and "enabled" or "disabled")
	acutil.log("Other rendering effects "..flagValue)
end
