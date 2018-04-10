-- Original addon created by https://github.com/huenato
local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
WarmodeEX4L = _G["ADDONS"]["WARMODEEX4L"] or {};

local defaultSettings={}
local effectSwitch = 1;
local guiSwitch = 1;
local model3dFlag = 1;
local minimalEffectsFlag = 1;

function WARMODEEX4L_ON_INIT(addon, frame)
	if not WarmodeEX4L.isLoaded then
		SAVE_DEFAULTS();
		WarmodeEX4L.isLoaded = true
		acutil.slashCommand("/war3d",TOGGLE_3D)
		acutil.slashCommand("/warmisc",TOGGLE_MINIMAL_EFFECTS)
		acutil.log("WarmodeEx4Laptop loaded!")
	end

    frame:ShowWindow(1);
    frame:RunUpdateScript("WARMODEEX4L_UPDATE", 0, 0, 0, 1);
end

function WARMODEEX_UPDATE(frame)

    if keyboard.IsKeyDown("MINUS") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        WARMODE(0)
    elseif keyboard.IsKeyDown("PLUS") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        WARMODE(1)
    elseif keyboard.IsKeyDown("OPEN BRACKET") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        WARMODE_UI(0)
    elseif keyboard.IsKeyDown("CLOSE BRACKET") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        WARMODE_UI(1)
    elseif keyboard.IsKeyDown("COLON") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        TOGGLE_3D()
	elseif keyboard.IsKeyDown("QUOTE") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
        TOGGLE_MINIMAL_EFFECTS()
    elseif keyboard.IsKeyDown("PIPE") == 1 and keyboard.IsKeyPressed("LALT") == 1 then
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