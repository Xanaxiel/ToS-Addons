local config = {
    showCollectionCustomTooltips = true,
    showCompletedCollections = true,
    showRecipeCustomTooltips = true
}

local function contains(table, val)
    for k, v in ipairs (table) do
        if v == val then
            return true
        end
    end
    return false
end

local function compare(a, b)
    if a[1] < b[1] then
        return true
    elseif a[1] > b[1] then
        return false
    else
        return a[2] < b[2]
    end
end

local function applyEllipsis(str)
    if string.len(str) > 45 then
        str = string.sub(str, 1, 45) .. "..."
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

local function manuallyCount(cls, invItem)
    local count = 0;
    for i = 1 , 9 do
        local item = GetClass("Item", cls["ItemName_" .. i]);
            
        if item == "None" or item == nil then
            break;
        end
                
        if item.ClassName == invItem.ClassName then
            count = count + 1;
        end
    end
    return count;
end

function COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
    local pc = session.GetMySession();
    local partOfCollections = {};
    local myColls = pc:GetCollection();
    local foundMatch = false;
    
    local clsList, cnt = GetClassList("Collection");
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        local coll = myColls:Get(cls.ClassID);
        local curCount, maxCount = -1 , 0;
        local isCompleted = false;
        local hasRegisteredCollection = false;
        
        if coll ~= nil then
            curCount, maxCount = GET_COLLECTION_COUNT(coll.type, coll);
            if curCount >= maxCount then
                isCompleted = true;
            end
            hasRegisteredCollection = true
        end
        
        for j = 1 , 9 do
            local item = GetClass("Item", cls["ItemName_" .. j]);
            local text = "";
            
            if item == "None" or item == nil then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                local neededCount = 0;
                local collCount = 0;
                local collName = dictionary.ReplaceDicIDInCompStr(cls.Name);
                
                if hasRegisteredCollection then
                    local info = geCollectionTable.Get(cls.ClassID)
                    collCount = coll:GetItemCountByType(item.ClassID);
                    neededCount = info:GetNeedItemCount(item.ClassID);
                else
                    neededCount = manuallyCount(cls, item);
                end
                
                text = text .. "{ol}{ds}{#9D8C70}" .. collName
                text = applyEllipsis(text);
                text = text .. " " .. collCount .. "/" .. neededCount .. "{/}{/}{/}"

                if isCompleted then
                    if config.showCompletedCollections then
                        text = text .. " {ol}{ds}{#00FF00}Completed!{/}{/}{/}"
                    else 
                        text = ""
                    end
                end
                
                if not contains(partOfCollections, text) then
                    table.insert(partOfCollections, text);
                end                  
            end
        end
    end
    
    if not foundMatch then
        partOfCollections = {};    
    end
    
    return table.concat(partOfCollections,"{nl}")
end

local function concatenateRecipeText(table, index)
    local prefix = "{ol}{ds}{#9D8C70}Recipe:{/}{/}{/} {ol}{ds}"
    local suffix = table[index][2] .. table[index][3] .. table[index][4] .. "{/}{/}{/}"
    local color = ""
    
    if table[index][1] == 1 then
        color = "{#E1E1E1}"
    elseif table[index][1] == 2 then
        color = "{#108CFF}"
    elseif table[index][1] == 3 then
        color = "{#9F30FF}"
    elseif table[index][1] == 4 then
        color = "{#FF4F00}"
    else
        color = "{#9D8C70}"
    end
    
    return prefix .. color .. suffix
end

function RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
    local partOfRecipe = {};
    local foundMatch = false;
    local clsList, cnt = GetClassList("Recipe");
    local unSortedTable = {};
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        
        for j = 1 , 5 do
            local item = GetClass("Item", cls["Item_" .. j .. "_1"]);
            local isRegistered = "";
            local isCrafted = "";
            if item == "None" or item == nil then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                local resultItem = GetClass("Item", cls.TargetItem);
                if resultItem.ItemType ~= "UNUSED" and resultItem ~= nil then
                    local grade = resultItem.ItemGrade;
                    
                    local recipeWiki = GetWiki(cls.ClassID);
                    if recipeWiki ~= nil then
                        local teachPoint = GetWikiIntProp(recipeWiki, "TeachPoint");
                        local makeCount = GetWikiIntProp(recipeWiki, "MakeCount");
                        if teachPoint >= 0 then
                            isRegistered = " {/}{/}{/}{ol}{ds}{#00FF00}Registered!"
                        end
                        if makeCount > 0 then
                            isCrafted = " {/}{/}{/}{ol}{ds}{#00FF00}Crafted!"
                        end
                    end
                    
                    if grade == 'None' or grade == nil then
                        grade = 0;
                    end
                    
                    local result = dictionary.ReplaceDicIDInCompStr(resultItem.Name);
                    local tempObj = {grade, result, isRegistered, isCrafted}
                    table.insert(unSortedTable, tempObj);
                end
            end
        end
    end
    
    if foundMatch then
        table.sort(unSortedTable, compare);
        for k = 1, #unSortedTable do
            local text = concatenateRecipeText(unSortedTable, k) 
            if not contains(partOfRecipe, text) then
                table.insert(partOfRecipe, text);
            end
        end
    else
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
    
    local headText = "{ol}{ds}{#9D8C70}Used in:{/}{/}{/}{nl}"
    local text = ""
    
    table.insert(stringBuffer,headText);
    
    --Tooltip
    if config.showCollectionCustomTooltips then
        text = COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem);
        if text ~= "" then
            table.insert(stringBuffer,text)
        end
    end
      
    --Recipe
    if config.showRecipeCustomTooltips then 
        text = RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
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
    
    stringBuffer = {}
    text = ""
    return ctrl:GetHeight() + ctrl:GetY();
end

local function setupHook(newFunction, hookedFunctionStr)
    local storeOldFunc = hookedFunctionStr .. "_OLD";
    if _G[storeOldFunc] == nil then
        _G[storeOldFunc] = _G[hookedFunctionStr];
    end
    _G[hookedFunctionStr] = newFunction;
end

setupHook(ITEM_TOOLTIP_EQUIP_HOOKED, "ITEM_TOOLTIP_EQUIP");
setupHook(ITEM_TOOLTIP_ETC_HOOKED, "ITEM_TOOLTIP_ETC");
setupHook(ITEM_TOOLTIP_BOSSCARD_HOOKED, "ITEM_TOOLTIP_BOSSCARD");
setupHook(ITEM_TOOLTIP_GEM_HOOKED, "ITEM_TOOLTIP_GEM");

ui.SysMsg("Tooltip helper loaded!")
