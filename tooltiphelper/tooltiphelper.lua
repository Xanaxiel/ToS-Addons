local config = {
    showCollectionCustomTooltips = true,
    showCompletedCollections = true,
    showRecipeCustomTooltips = true
}

local function CONTAINS(table, val)
    for k, v in ipairs (table) do
        if v == val then
            return true
        end
    end
    return false
end

local function APPLY_ELLIPSIS(str)
    if string.len(str) > 40 then
        str = string.sub(str, 1, 40) .. "..."
    end
    
    return str
end

function ITEM_TOOLTIP_BOSSCARD_HOOKED(tooltipFrame, invItem, strArg)
    _G["ITEM_TOOLTIP_BOSSCARD_OLD"](tooltipFrame, invItem, strArg);
    
    local mainFrameName = 'bosscard'
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg);
end

function ITEM_TOOLTIP_EQUIP_HOOKED(tooltipFrame, invItem, strArg, useSubFrame)
    _G["ITEM_TOOLTIP_EQUIP_OLD"](tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'equip_main'
    local addInfoFrameName = 'equip_main_addinfo'
    local drawNowEquip = 'true'
    
    if useSubFrame == "usesubframe" then
        mainFrameName = 'equip_sub'
        addInfoFrameName = 'equip_sub_addinfo'
    elseif useSubFrame == "usesubframe_recipe" then
        mainFrameName = 'equip_sub'
        addInfoFrameName = 'equip_sub_addinfo'
        drawNowEquip = 'false'
    end
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
end

function ITEM_TOOLTIP_ETC_HOOKED(tooltipFrame, invItem, strArg, useSubFrame)
    _G["ITEM_TOOLTIP_ETC_OLD"](tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'etc'
    
    if useSubFrame == "usesubframe" then
      mainFrameName = "etc_sub"
    elseif useSubFrame == "usesubframe_recipe" then
      mainFrameName = "etc_sub"
    end
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);  
end

function ITEM_TOOLTIP_GEM_HOOKED(tooltipFrame, invItem, strArg)
    _G["ITEM_TOOLTIP_GEM_OLD"](tooltipFrame, invItem, strArg);
    
    local mainFrameName = 'gem'
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg);
end

function COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem, config)
    local pc = session.GetMySession();
    local partOfCollection = {};
    local myColls = pc:GetCollection();
    local etcObj = GetMyEtcObject();
    local foundMatch = false;
    
    local clsList, cnt = GetClassList("Collection");
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        local coll = myColls:Get(cls.ClassID);
        local curCount, maxCount = -1 , 0;
        local isCompleted = false;
        
        if coll ~= nil then
            curCount, maxCount = GET_COLLECTION_COUNT(coll.type, coll);
            if curCount >= maxCount then
                isCompleted = true;
            end
        end
        
        for j = 1 , 9 do
            local item = GetClass("Item", cls["ItemName_" .. j]);
            local text = "";
            
            if item == "None" or item == nil then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                local collName = dictionary.ReplaceDicIDInCompStr(cls.Name);
                
                if isCompleted then
                    if config.showCompletedCollections then
                        text = text .. "{@st66}" .. collName
                        text = APPLY_ELLIPSIS(text) .. " {ol}{#FF0000}Completed!{/}{/}{nl}";
                    end
                else
                    text = text .. "{@st66}" .. collName .. "{/}{nl}"
                end
                if not CONTAINS(partOfCollection, text) then
                    table.insert(partOfCollection, text);
                end                  
            end
        end
    end
    
    if not foundMatch then
        partOfCollection = {};    
    end
    
    return table.concat(partOfCollection,"{nl}")
end

function RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem, config)
    local partOfRecipe = {};
    local foundMatch = false;
    local clsList, cnt = GetClassList("Recipe");
    
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        
        for j = 1 , 5 do
            local item = GetClass("Item", cls["Item_" .. j .. "_1"]);
            local text = ""
            if item == "None" or item == nil then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                local resultItem = GetClass("Item", cls.TargetItem);
                if resultItem.ItemType ~= "UNUSED" then
                    local grade = resultItem.ItemGrade;
                    local result = dictionary.ReplaceDicIDInCompStr(resultItem.Name);
                    if grade == 1 then
                        result = "{ol}{#E1E1E1}" .. result .. "{/}"
                    elseif grade == 2 then
                        result = "{ol}{#108CFF}" .. result .. "{/}"
                    elseif grade == 3 then
                        result = "{ol}{#9F30FF}" .. result .. "{/}"
                    elseif grade == 4 then
                        result = "{ol}{#FF4F00}" .. result .. "{/}"
                    end
                    text = text .. "{@st66}Recipe: " .. result .. "{/}{nl}"
  
                    if not CONTAINS(partOfRecipe, text) then
                        table.insert(partOfRecipe, text);
                    end
                end
            end
        end
    end
    
    if not foundMatch then
        partOfRecipe = {};    
    end
    
    return table.concat(partOfRecipe, "{nl}")
end

function CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame)
    local gBox = GET_CHILD(tooltipFrame, mainFrameName,'ui::CGroupBox');
    
    local yPos = gBox:GetY() + gBox:GetHeight();
    
    local ctrl = gBox:CreateOrGetControl("richtext", 'text', 0, yPos, 410, 30);
    tolua.cast(ctrl, "ui::CRichText");
    
    local stringBuffer = {};
    
    local headText = "{@st66}Used in:{/}{nl}"
    local text = ""
    
    table.insert(stringBuffer,headText);
    
    --Tooltip
    if config.showCollectionCustomTooltips then
        text = COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem, config);
        if text ~= "" then
            table.insert(stringBuffer,text)
        end
    end
      
    --Recipe
    if config.showRecipeCustomTooltips then 
        text = RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem, config)
        if text ~= "" then
            table.insert(stringBuffer,text)    
        end
    end
    
    if #stringBuffer == 1 then
        text = ""
    else
        text = table.concat(stringBuffer,"{nl}")
    end
    
    ctrl:SetText(text);
    ctrl:SetMargin(20,gBox:GetHeight() - 10,0,0)
    
    local BOTTOM_MARGIN = tooltipFrame:GetUserConfig("BOTTOM_MARGIN");
    gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + ctrl:GetHeight())
    
    return ctrl:GetHeight() + ctrl:GetY();
end

function COLLECTION_ON_INIT_HOOKED(addon, frame)
    USE_COLLECTION_SHOW_ALL = 1;
    _G["COLLECTION_ON_INIT"](addon, frame);
end

SETUP_HOOK(ITEM_TOOLTIP_EQUIP_HOOKED, "ITEM_TOOLTIP_EQUIP");
SETUP_HOOK(ITEM_TOOLTIP_ETC_HOOKED, "ITEM_TOOLTIP_ETC");
SETUP_HOOK(ITEM_TOOLTIP_BOSSCARD_HOOKED, "ITEM_TOOLTIP_BOSSCARD");
SETUP_HOOK(ITEM_TOOLTIP_GEM_HOOKED, "ITEM_TOOLTIP_GEM");

ui.SysMsg("Tooltip helper loaded!");