local function getPropVal(keyString)
	local file = io.open("../addons/tooltiphelper/tooltiphelper.properties", "r")
	for line in file:lines() do
    	local key, value = string.match(line,"(%w+)=(%w+)")
		if key == keyString then
			return value;
		end
    end
end

local config = {
    showCollectionCustomTooltips = assert(loadstring("return " .. getPropVal("showCollectionCustomTooltips")))(),
    showCompletedCollections	 = assert(loadstring("return " .. getPropVal("showCompletedCollections")))(),
    showRecipeCustomTooltips	 = assert(loadstring("return " .. getPropVal("showRecipeCustomTooltips")))(),
    showItemLevel				 = assert(loadstring("return " .. getPropVal("showItemLevel")))(),
    showRepairRecommendation	 = assert(loadstring("return " .. getPropVal("showRepairRecommendation")))(),
	squireRepairPerKit			 = assert(loadstring("return " .. getPropVal("squireRepairPerKit")))() -- 160 is the minimum for the Squire to break even
}

local function contains(table, val)
    for k, v in ipairs(table) do
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
    if string.len(str) > 28 then
        str = string.sub(str, 12)
    end
    
    return str
end

local labelColor = "{#9D8C70}"
local completeColor = "{#00FF00}"
local commonColor = "{#E1E1E1}"
local uncommonColor = "{#108CFF}"
local rareColor = "{#9F30FF}"
local legendaryColor = "{#FF4F00}"
local npcColor = "{#FF4040}"
local squireColor = "{#40FF40}"

local function toIMCTemplate(text, color)
    return "{ol}{ds}" .. color .. text .. "{/}{/}{/}"    
end

function ITEM_TOOLTIP_BOSSCARD_HOOKED(tooltipFrame, invItem, strArg)
    _G["ITEM_TOOLTIP_BOSSCARD_OLD"](tooltipFrame, invItem, strArg);
    
    local mainFrameName = 'bosscard'
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg);
end

function ITEM_TOOLTIP_EQUIP_HOOKED(tooltipFrame, invItem, strArg, useSubFrame)
    _G["ITEM_TOOLTIP_EQUIP_OLD"](tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'equip_main'
    
    if useSubFrame == "usesubframe" or useSubFrame == "usesubframe_recipe" then 
        mainFrameName = 'equip_sub'
    end
    
    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
end

function ITEM_TOOLTIP_ETC_HOOKED(tooltipFrame, invItem, strArg, useSubFrame)
    _G["ITEM_TOOLTIP_ETC_OLD"](tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'etc'
    
    if useSubFrame == "usesubframe" or useSubFrame == "usesubframe_recipe" then
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
            
            if item == "None" or item == nil or item.NotExist == 'YES' then
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
                
                text = toIMCTemplate(applyEllipsis(collName) .. " " .. collCount .. "/" .. neededCount .. " ", labelColor)

                if isCompleted then
                    if config.showCompletedCollections then
                        text = text .. toIMCTemplate("Completed!", completeColor)
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

local function colorByItemGrade(itemGrade)
    if itemGrade == 1 then return commonColor
    elseif itemGrade == 2 then return uncommonColor
    elseif itemGrade == 3 then return rareColor
    elseif itemGrade == 4 then return legendaryColor
    else return labelColor end
end

local function concatenateRecipeText(table, index)
    local recipeLabelText = toIMCTemplate("Recipe: ", labelColor)
    local recipeDetails = toIMCTemplate(table[index][2] .. " ", colorByItemGrade(table[index][1]))
    return recipeLabelText .. recipeDetails
end

function RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
    local partOfRecipe = {};
    local foundMatch = false;
    local unSortedTable = {};
    local clsList, cnt = GetClassList("Recipe");
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        
        for j = 1 , 5 do
            local item = GetClass("Item", cls["Item_" .. j .. "_1"]);
            local isRegistered = "";
            local isCrafted = "";
            if item == "None" or item == nil or item.NotExist == 'YES' then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                local resultItem = GetClass("Item", cls.TargetItem);
                if resultItem.ItemType ~= "UNUSED" and resultItem ~= nil then
                    local grade = resultItem.ItemGrade;
                    if grade == 'None' or grade == nil then
                        grade = 0;
                    end
                    
                    local result = dictionary.ReplaceDicIDInCompStr(resultItem.Name) .. " "
                    local recipeWiki = GetWiki(cls.ClassID);
                    if recipeWiki ~= nil then
                        local teachPoint = GetWikiIntProp(recipeWiki, "TeachPoint");
                        local makeCount = GetWikiIntProp(recipeWiki, "MakeCount");
                        if teachPoint >= 0 then
                            result = result .. toIMCTemplate("Registered! ", completeColor)
                        end
                        if makeCount > 0 then
                            result = result .. toIMCTemplate("Crafted!", completeColor)
                        end
                    end
                    
                    table.insert(unSortedTable, {grade, result});
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
    local text = ""
    
    --Show trade count when trade window is visible 
    if ui.GetFrame('exchange'):IsVisible() == 1 then
		local tradeCount = GetMyAccountObj().TradeCount
	    if tradeCount > 0 then
	    	text = toIMCTemplate(tradeCount .. " trades left!", completeColor)
	    	table.insert(stringBuffer, text)
	    end
    end
     
    --iLvl
    local itemLevelLabel = ""
    if config.showItemLevel then
        if invItem.ItemType == "Equip" then
            itemLevelLabel = toIMCTemplate("Item Level: ", labelColor) .. toIMCTemplate(invItem.ItemLv .. " ", colorByItemGrade(invItem.ItemGrade))
        end
    end
    
    --Repair Recommendation
    local repairRecommendationLabel = ""
    if config.showRepairRecommendation then
        if invItem.ItemType == "Equip" and invItem.Reinforce_Type == 'Moru' then
            local _, squireResult = ITEMBUFF_NEEDITEM_Squire_Repair(nil, invItem)
            if invItem.Dur < invItem.MaxDur then
                repairRecommendationLabel = toIMCTemplate("Repair at: ", labelColor)
                if squireResult * config.squireRepairPerKit < GET_REPAIR_PRICE(invItem, 0) then
                    repairRecommendationLabel = repairRecommendationLabel .. toIMCTemplate("Squire ", squireColor)
                else
                    repairRecommendationLabel = repairRecommendationLabel .. toIMCTemplate("NPC ", npcColor)
                end
            end
        end
    end
    
    local usedInLabel =  toIMCTemplate("Used in:", labelColor)
    local headText = itemLevelLabel .. repairRecommendationLabel .. usedInLabel
    table.insert(stringBuffer,headText);
    
    --Collection
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
    
    if #stringBuffer == 1 and invItem.ItemType == "Equip" then
        text = itemLevelLabel .. repairRecommendationLabel
    else
        text = table.concat(stringBuffer,"{nl}")
    end
    
    if text == usedInLabel then
        text = ""
    end
    
    ctrl:SetText(text);
    ctrl:SetMargin(20,gBox:GetHeight() - 10,0,0)
    
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