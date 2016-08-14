local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
TooltipHelper = _G["ADDONS"]["TOOLTIPHELPER"] or {};

TooltipHelper.configFile = '../addons/tooltiphelper/tooltiphelper.json'

TooltipHelper.config = {
    showCollectionCustomTooltips = true,
    showCompletedCollections	 = true,
    showRecipeCustomTooltips	 = true,
    showRecipeHaveNeedCount		 = true,
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
    
    if marktioneer ~= nil then
    	CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame)
    	return marktioneer.addMarketPrice(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
    else
	    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
    end
end

function ITEM_TOOLTIP_ETC_HOOKED(tooltipFrame, invItem, strArg, useSubFrame)
    _G["ITEM_TOOLTIP_ETC_OLD"](tooltipFrame, invItem, strArg, useSubFrame);
    
    local mainFrameName = 'etc'
    
    if useSubFrame == "usesubframe" or useSubFrame == "usesubframe_recipe" then
        mainFrameName = "etc_sub"
    end
    
    if marktioneer ~= nil then
    	CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
    	return marktioneer.addMarketPrice(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);
    else
	    return CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame);  
    end
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
            
            if item == "None" or item == nil or item.NotExist == 'YES' or item.ItemType == 'Unused' or item.GroupName == 'Unused' then
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
            local recipeItem = GetClass("Item", cls["Item_1_1"]);
            local obj = {}
            obj.recipeClassID = recipeItem.ClassID
            
            if item == "None" or item == nil or item.NotExist == 'YES' or item.ItemType == 'Unused' or item.GroupName == 'Unused' then
                break;
            end
            
            if item.ClassName == invItem.ClassName then
            	local needCount, haveCount = 1, 0;
            	if IS_RECIPE_ITEM(invItem) ~= 0 then
            		needCount, haveCount = 1, 1 
            	else
            		needCount, haveCount = GET_RECIPE_MATERIAL_INFO(cls, j);
            	end
                foundMatch = true;
                obj.resultItemObj = GetClass("Item", cls.TargetItem);
                local resultItem = obj.resultItemObj
                if resultItem ~= nil and resultItem.NotExist ~= 'YES' and resultItem.ItemType ~= 'Unused' and item.GroupName ~= 'Unused' then
                    obj.grade = resultItem.ItemGrade;
                    obj.isRegistered = false;
                    obj.isCrafted = false;
                    obj.recipeIcon = cls.Icon;
                    obj.needCount = needCount;
                    obj.haveCount = haveCount;
                    
                    if obj.grade == 'None' or obj.grade == nil then
                        obj.grade = 0;
                    end
                    
                    obj.resultItemName = dictionary.ReplaceDicIDInCompStr(resultItem.Name)
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
        	local recipeIcon = obj.recipeIcon
        	local needCount = obj.needCount
			local haveCount = obj.haveCount
			local recipeClsID = obj.recipeClassID
			
        	local text = ""
        	local materialCountText = ""
        	local color = commonColor
        	
        	if TooltipHelper.config.showRecipeHaveNeedCount then
        		materialCountText = haveCount .. "/" .. needCount
        		if not isRegistered then
        			color = unregisteredColor
        		else
        			if (invItem.ItemType ~= "Recipe") and (haveCount >= needCount) then
		        		color = completeColor
		        	end
        		end
	        	materialCountText = toIMCTemplate(materialCountText, color)
        	end
        	
        	itemName = addIcon(itemName, recipeIcon)
			text = toIMCTemplate(itemName, acutil.getItemRarityColor(resultItem))
			
        	if isCrafted then
        		text = text .. addIcon("", resultItem.Icon)
        	elseif isRegistered then
        		text = text
        	else
        		text = toIMCTemplate(itemName, unregisteredColor)
        	end
        	
        	text = text .. " " .. materialCountText
        	
        	if marktioneer ~= nil then
        		local recipeData = marktioneer.getMinimumData(recipeClsID);
        		local newLine = "{nl}    ";
				if (recipeData) then 
					text = text .. newLine .. addIcon("", recipeIcon) .. " ".. toIMCTemplate(GetCommaedText(recipeData.price), labelColor);
				end
				local resultItemData = marktioneer.getMinimumData(resultItem.ClassID);
				if (resultItemData) then 
					local resultPrice = " " .. addIcon("", resultItem.Icon) .. " ".. toIMCTemplate(GetCommaedText(resultItemData.price), labelColor);
					if (recipeData) then
						text = text .. resultPrice
					else
						text = text .. newLine .. resultPrice
					end
				end
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

function RENDER_CUBE_REROLL_PRICE(tooltipFrame, buffer, invItem)
	if invItem.GroupName == "Drug" then
    	local item = GetObjectByGuid(tooltipFrame:GetTooltipIESID());
		local itemName = dictionary.ReplaceDicIDInCompStr(item.Name)
		if string.find(itemName, 'Cube') then
			local rerollPrice = TryGet(item, "NumberArg1")
			if rerollPrice > 0 then
				table.insert(buffer, addIcon("", invItem.Icon) .. toIMCTemplate("Reroll Price: " .. GetCommaedText(rerollPrice), labelColor))
			end
		end
    end
end

function RENDER_JOURNAL_STATS(tooltipFrame, invItem)
	local journalStatsLabel = ""
	if TooltipHelper.config.showJournalStats then
		journalStatsLabel = JOURNAL_STATS_CUSTOM_TOOLTIP_TEXT(invItem)
    end
    return journalStatsLabel
end

function RENDER_ITEM_LEVEL(tooltipFrame, invItem)
	local itemLevelLabel = ""
	if TooltipHelper.config.showItemLevel then
        if invItem.ItemType == "Equip" then
            itemLevelLabel = toIMCTemplate("Item Level: ", labelColor) .. toIMCTemplate(invItem.ItemLv .. " ", acutil.getItemRarityColor(invItem))
        end
    end
    return itemLevelLabel
end

function RENDER_REPAIR_RECOMMENDATION(tooltipFrame, invItem)
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
    return repairRecommendationLabel
end

function RENDER_COLLECTION_DETAILS(tooltipFrame, buffer, invItem, text)
	if TooltipHelper.config.showCollectionCustomTooltips then
        text = COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem);
        if text ~= "" then
            table.insert(buffer,text)
        end
    end
end

function RENDER_RECIPE_DETAILS(tooltipFrame, buffer, invItem, text)
	if TooltipHelper.config.showRecipeCustomTooltips then 
        text = RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
        if text ~= "" then
            table.insert(buffer,text)    
        end
    end
end

function CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame)
    local gBox = GET_CHILD(tooltipFrame, mainFrameName,'ui::CGroupBox');
    
    local yPos = gBox:GetY() + gBox:GetHeight();
    
    local ctrl = gBox:CreateOrGetControl("richtext", 'text', 0, yPos, 410, 30);
    tolua.cast(ctrl, "ui::CRichText");
    
    local buffer = {};
    local text = ""
    
    --Reroll Price
    RENDER_CUBE_REROLL_PRICE(tooltipFrame, buffer, invItem);
    
    --Journal stats
    local journalStatsLabel = RENDER_JOURNAL_STATS(tooltipFrame, invItem);
    
    --iLvl
    local itemLevelLabel = RENDER_ITEM_LEVEL(tooltipFrame, invItem);
    
    --Repair Recommendation
    local repairRecommendationLabel = RENDER_REPAIR_RECOMMENDATION(tooltipFrame, invItem);
    
    local headText = journalStatsLabel .. itemLevelLabel .. repairRecommendationLabel;
    table.insert(buffer,headText);
    
    --Collection
    RENDER_COLLECTION_DETAILS(tooltipFrame, buffer, invItem, text)
      
    --Recipe
    RENDER_RECIPE_DETAILS(tooltipFrame, buffer, invItem, text)
   
    if #buffer == 1 and invItem.ItemType == "Equip" then
        text = journalStatsLabel .. itemLevelLabel .. repairRecommendationLabel
    else
        text = table.concat(buffer,"{nl}")
    end
        
    ctrl:SetText(text);
    ctrl:SetMargin(20,gBox:GetHeight() - 10,0,0)
    
    gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + ctrl:GetHeight())
    
    buffer = {}
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