local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
TooltipHelper = _G["ADDONS"]["TOOLTIPHELPER"] or {};

TooltipHelper.configFile = '../addons/tooltiphelper/tooltiphelper.json'

TooltipHelper.config = {
    showCollectionCustomTooltips = true,
    showCompletedCollections	 = true,
    showRecipeCustomTooltips	 = true,
    showItemLevel				 = true,
    showJournalStats			 = true,
    showRepairRecommendation	 = true,
	squireRepairPerKit			 = 200 -- 160 is the minimum for the Squire to break even
}

TooltipHelper.config = (
	function ()
		local file, err = acutil.loadJSON(TooltipHelper.configFile, TooltipHelper.config);
		if err then 
		    acutil.saveJSON(TooltipHelper.configFile, TooltipHelper.config);
		else 
		    TooltipHelper.config = file; 
		end
		return TooltipHelper.config
	end
)()

function TOOLTIPHELPER_ON_INIT(addon, frame)
    TooltipHelper.addon = addon;
	TooltipHelper.frame = frame;
	
	TOOLTIPHELPER_INIT();
end

local function contains(table, val)
    for k, v in ipairs(table) do
        if v == val then
            return true
        end
    end
    return false
end

local function compare(a, b)
    if a.grade < b.grade then
        return true
    elseif a.grade > b.grade then
        return false
    else
        return a.resultItemName < b.resultItemName
    end
end

local labelColor = "9D8C70"
local completeColor = "00FF00"
local commonColor = "FFFFFF"
local npcColor = "FF4040"
local squireColor = "40FF40"
local unregisteredColor = "7B7B7B"
local collectionIcon = "icon_item_box"
local recipeIcon = "icon_item_Scroll1"
local craftedIcon = "icon_item_anvil"

local function toIMCTemplate(text, colorHex)
    return "{ol}{ds}{#" .. colorHex .. "}".. text .. "{/}{/}{/}"    
end

local function addIcon(text, iconName)
	return "{img " .. iconName .. " 24 24}" .. text .. "{/}"
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

function JOURNAL_STATS_CUSTOM_TOOLTIP_TEXT(invItem)
	local text = ""
	local type = "Item"
	if invItem.ItemType == "Recipe" then type = "Recipe" end
	
	local clsList = GetClassList(type);        
	local wikiList = GetClassList("Wiki");
    local list = GetWikiListByCategory(type);
    if list ~= nil then
    	for i = 1 , #list do
			local wiki = list[i];
			local wikiType = GetWikiType(wiki);
			local cls = GetClassByTypeFromList(wikiList, wikiType);
			local itemCls = GetClassByNameFromList(clsList, cls.ClassName);
			if itemCls.ClassName == invItem.ClassName then
				local cls = GetClass("Item", itemCls.ClassName);
				local score = GET_ITEM_WIKI_PTS(cls, wiki);
		        local totalCount = GetWikiIntProp(wiki, "Total");
		        local maxPts = GET_ITEM_MAX_WIKI_PTS(cls, wiki);
        
		        if score ~= nil and maxPts ~= nil then
		        	text = "Journal Points Acquired: (" .. math.floor(score) .. "/" .. maxPts .. "){nl}"
		        	if score == maxPts then 
						text = "Journal Points Acquired: " .. maxPts .. "{nl}"			        		
		        	end
		        end
		        
		        --Journal doesn't log recipe count
		        if totalCount ~= nil and type ~= "Recipe" then
		        	text = text .. "Total Obtained: " .. totalCount .. "{nl}"
		        end
				break;
			end
		end
    end
    return toIMCTemplate(text, labelColor)
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
                local neededCount = manuallyCount(cls, item);
                local collCount = 0;
                local collName = string.gsub(dictionary.ReplaceDicIDInCompStr(cls.Name), "Collection: ", "")
				
                if hasRegisteredCollection then
                    local info = geCollectionTable.Get(cls.ClassID)
                    collCount = coll:GetItemCountByType(item.ClassID);
                    neededCount = info:GetNeedItemCount(item.ClassID);
                end
                
                text = addIcon(collName .. " " .. collCount .. "/" .. neededCount .. " ", collectionIcon)
                
                if isCompleted then
                    if TooltipHelper.config.showCompletedCollections then
                        text = toIMCTemplate(text, completeColor)
                    else 
                        text = ""
                    end
                elseif hasRegisteredCollection then
                	text = toIMCTemplate(text, commonColor)
               	else
               		text = toIMCTemplate(text, unregisteredColor)
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

function RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
    local partOfRecipe = {};
    local foundMatch = false;
    local unSortedTable = {};
    local clsList, cnt = GetClassList("Recipe");
    for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        
        for j = 1 , 5 do
            local item = GetClass("Item", cls["Item_" .. j .. "_1"]);
            local obj = {}
            if item == "None" or item == nil or item.NotExist == 'YES' then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
                foundMatch = true;
                obj.resultItemObj = GetClass("Item", cls.TargetItem);
                if obj.resultItemObj.ItemType ~= "UNUSED" and obj.resultItemObj ~= nil then
                    obj.grade = obj.resultItemObj.ItemGrade;
                    obj.isRegistered = false;
                    obj.isCrafted = false;
                    
                    if obj.grade == 'None' or obj.grade == nil then
                        obj.grade = 0;
                    end
                    
                    obj.resultItemName = dictionary.ReplaceDicIDInCompStr(obj.resultItemObj.Name)
                    local recipeWiki = GetWiki(cls.ClassID);
                    if recipeWiki ~= nil then
                        local teachPoint = GetWikiIntProp(recipeWiki, "TeachPoint");
                        local makeCount = GetWikiIntProp(recipeWiki, "MakeCount");
                        if teachPoint >= 0 then
							obj.isRegistered = true;
                        end
                        if makeCount > 0 then
                        	obj.isCrafted = true;
                        end
                    end
                    
                    table.insert(unSortedTable, obj);
                end
            end
        end
    end
    
    if foundMatch then
        table.sort(unSortedTable, compare);
        for k = 1, #unSortedTable do
        	local obj = unSortedTable[k];
        	local itemName = obj.resultItemName
        	local resultItem = obj.resultItemObj
        	local isRegistered = obj.isRegistered
        	local isCrafted = obj.isCrafted
        	local text = ""
        	
        	itemName = addIcon(itemName, resultItem.Icon)
        	
        	if isRegistered then
            	text = toIMCTemplate(itemName .. " ", acutil.getItemRarityColor(resultItem))
    		else
    			text = toIMCTemplate(itemName .. " ", unregisteredColor)
        	end
        	
        	if isCrafted then
        		text = text .. addIcon(" ", craftedIcon)
        	end
        	
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
    
    --Journal stats
    local journalStatsLabel = ""
    if TooltipHelper.config.showJournalStats then
		journalStatsLabel = JOURNAL_STATS_CUSTOM_TOOLTIP_TEXT(invItem)
    end
    
    --iLvl
    local itemLevelLabel = ""
    if TooltipHelper.config.showItemLevel then
        if invItem.ItemType == "Equip" then
            itemLevelLabel = toIMCTemplate("Item Level: ", labelColor) .. toIMCTemplate(invItem.ItemLv .. " ", acutil.getItemRarityColor(invItem))
        end
    end
    
    --Repair Recommendation
    local repairRecommendationLabel = ""
    if TooltipHelper.config.showRepairRecommendation then
        if invItem.ItemType == "Equip" and invItem.Reinforce_Type == 'Moru' then
            local _, squireResult = ITEMBUFF_NEEDITEM_Squire_Repair(nil, invItem)
            if invItem.Dur < invItem.MaxDur then
                local repairRecommendation = toIMCTemplate("NPC ", npcColor)
                if squireResult * tonumber(TooltipHelper.config.squireRepairPerKit) < GET_REPAIR_PRICE(invItem, 0) then
                    repairRecommendation = toIMCTemplate("Squire ", squireColor)
                end
                repairRecommendationLabel = toIMCTemplate("Repair at: ", labelColor) .. repairRecommendation
            end
        end
    end
    
    local usedInLabel =  toIMCTemplate("Used in:", labelColor)
    local headText = journalStatsLabel .. itemLevelLabel .. repairRecommendationLabel .. usedInLabel
    table.insert(stringBuffer,headText);
    
    --Collection
    if TooltipHelper.config.showCollectionCustomTooltips then
        text = COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem);
        if text ~= "" then
            table.insert(stringBuffer,text)
        end
    end
      
    --Recipe
    if TooltipHelper.config.showRecipeCustomTooltips then 
        text = RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
        if text ~= "" then
            table.insert(stringBuffer,text)    
        end
    end
    
    if #stringBuffer == 1 and invItem.ItemType == "Equip" then
        text = journalStatsLabel .. itemLevelLabel .. repairRecommendationLabel
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



function TOOLTIPHELPER_INIT()
	if not TooltipHelper.isLoaded then
		acutil.setupHook(ITEM_TOOLTIP_EQUIP_HOOKED, "ITEM_TOOLTIP_EQUIP");
		acutil.setupHook(ITEM_TOOLTIP_ETC_HOOKED, "ITEM_TOOLTIP_ETC");
		acutil.setupHook(ITEM_TOOLTIP_BOSSCARD_HOOKED, "ITEM_TOOLTIP_BOSSCARD");
		acutil.setupHook(ITEM_TOOLTIP_GEM_HOOKED, "ITEM_TOOLTIP_GEM");
		
		TooltipHelper.isLoaded = true
		
		ui.SysMsg("Tooltip helper loaded!")
	end
end