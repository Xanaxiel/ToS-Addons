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
		acutil.log("WarmodeEx loaded!")
	end
	
    frame:ShowWindow(1);
    frame:RunUpdateScript("WARMODEEX_UPDATE", 0, 0, 0, 1);
end

function WARMODEEX_UPDATE(frame)

    if keyboard.IsKeyPressed("LALT") == 1 then
        if keyboard.IsKeyPressed("NUMPAD0") == 1 then
            WARMODE(0)
        elseif keyboard.IsKeyPressed("NUMPAD1") == 1 then
            WARMODE(1)
        elseif keyboard.IsKeyPressed("NUMPAD2") == 1 then
            WARMODE_UI(0)
        elseif keyboard.IsKeyPressed("NUMPAD3") == 1 then
            WARMODE_UI(1)
        elseif keyboard.IsKeyPressed("NUMPAD4") == 1 then
        	model3dFlag = (model3dFlag == 1 and 0 or 1)
            TOGGLE_3D(model3dFlag)
		elseif keyboard.IsKeyPressed("NUMPAD5") == 1 then
        	minimalEffectsFlag = (minimalEffectsFlag == 1 and 0 or 1)
            TOGGLE_MINIMAL_EFFECTS(minimalEffectsFlag)
        elseif keyboard.IsKeyPressed("NUMPAD6") == 1 then
        	RESTORE_DEFAULTS()
        end
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

function TOGGLE_3D(flag)
	imcperfOnOff.Enable3DModel(flag)
	local flagValue = (flag == 1 and "enabled" or "disabled")
	acutil.log("3D models "..flagValue)
end

function TOGGLE_MINIMAL_EFFECTS(flag)
	imcperfOnOff.EnableWater(flag)
    imcperfOnOff.EnableDeadParts(flag);
	imcperfOnOff.EnableParticleEffectModel(flag)
	imcperfOnOff.EnableSky(flag)
	imcperfOnOff.EnableBloomObject(flag)
	imcperfOnOff.EnableDepth(flag)
	imcperfOnOff.EnableGrass(flag)
	imcperfOnOff.EnableFog(flag)
	imcperfOnOff.EnablePlaneLight(flag)
	imcperfOnOff.EnableLight(flag)
	imcperfOnOff.EnableMRT(flag)
	
	local flagValue = (flag == 1 and "enabled" or "disabled")
	acutil.log("Other rendering effects "..flagValue)
end
