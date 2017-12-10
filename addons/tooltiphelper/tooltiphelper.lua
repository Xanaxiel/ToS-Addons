local acutil = require('acutil');

_G['ADDONS'] = _G['ADDONS'] or {};
TooltipHelper = _G["ADDONS"]["TOOLTIPHELPER"] or {};

TooltipHelper.configFile = '../addons/tooltiphelper/tooltiphelper.json'
TooltipHelper.recipeFile = "../addons/tooltiphelper/recipe_puzzle.xml";

TooltipHelper.config = {
    showCollectionCustomTooltips = true,
    showCompletedCollections	 = true,
    showRecipeCustomTooltips	 = true,
    showRecipeHaveNeedCount		 = true,
    showMagnumOpus				 = true,
    showItemLevel				 = true,
    showJournalStats			 = true,
    showRepairRecommendation	 = true,
	squireRepairPerKit			 = 200, -- 160 is the minimum for the Squire to break even
	showItemDrop				 = true
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

TooltipHelper.magnumOpusRecipes = {
	["misc_0139"] = {
		{ name = "misc_0132", row = 0, col = 0 },
		{ name = "misc_0132", row = 0, col = 1 },
		{ name = "misc_0132", row = 0, col = 2 },
		{ name = "misc_0132", row = 1, col = 0 },
		{ name = "misc_0132", row = 1, col = 2 },
		{ name = "misc_0132", row = 2, col = 0 },
		{ name = "misc_0132", row = 2, col = 1 },
		{ name = "misc_0132", row = 2, col = 2 }
	},
	["misc_icepiece"] = {
		{ name = "Drug_holywater", row = 0, col = 0 },
		{ name = "Drug_holywater", row = 0, col = 1 },
		{ name = "Drug_holywater", row = 1, col = 0 },
		{ name = "Drug_holywater", row = 1, col = 1 }
	},
	["misc_Spector_Gh"] = {
		{ name = "misc_Corylus", row = 0, col = 0 },
		{ name = "misc_Corylus", row = 0, col = 1 },
		{ name = "misc_Corylus", row = 1, col = 0 },
		{ name = "misc_Corylus", row = 1, col = 1 }
	},
	["misc_0064"] = {
		{ name = "misc_0105", row = 0, col = 0 },
		{ name = "misc_0105", row = 0, col = 1 },
		{ name = "misc_0105", row = 1, col = 0 },
		{ name = "misc_0105", row = 1, col = 1 }
	},
	["misc_goblin"] = {
		{ name = "misc_Bume_Goblin", row = 0, col = 0 },
		{ name = "misc_Bume_Goblin", row = 0, col = 1 },
		{ name = "misc_Bume_Goblin", row = 1, col = 0 },
		{ name = "misc_Bume_Goblin", row = 1, col = 1 },
		{ name = "misc_Bume_Goblin", row = 2, col = 0 },
		{ name = "misc_Bume_Goblin", row = 2, col = 1 }
	},
	["misc_Rubabos"] = {
		{ name = "misc_0137", row = 0, col = 0 },
		{ name = "misc_0137", row = 0, col = 1 },
		{ name = "misc_0137", row = 1, col = 0 },
		{ name = "misc_0137", row = 1, col = 1 }
	},
	["misc_Caro"] = {
		{ name = "misc_maize", row = 0, col = 0 },
		{ name = "misc_maize", row = 0, col = 1 },
		{ name = "misc_maize", row = 1, col = 0 },
		{ name = "misc_maize", row = 1, col = 1 }
	},
	["misc_zigri"] = {
		{ name = "misc_puragi", row = 0, col = 0 },
		{ name = "misc_puragi", row = 0, col = 1 },
		{ name = "misc_puragi", row = 1, col = 0 },
		{ name = "misc_puragi", row = 1, col = 1 }
	},
	["misc_yekubite3"] = {
		{ name = "misc_yekubite2", row = 0, col = 0 },
		{ name = "misc_yekubite2", row = 0, col = 1 },
		{ name = "misc_yekubite2", row = 2, col = 1 },
		{ name = "misc_yekubite2", row = 3, col = 1 },
		{ name = "misc_yekubite2", row = 3, col = 2 },
		{ name = "misc_yekubite2", row = 4, col = 1 }
	},
	["misc_chromadog"] = {
		{ name = "misc_0129", row = 0, col = 0 },
		{ name = "misc_0129", row = 0, col = 1 },
		{ name = "misc_0129", row = 1, col = 0 },
		{ name = "misc_0129", row = 1, col = 1 }
	},
	["misc_0026"] = {
		{ name = "misc_zigri", row = 0, col = 0 },
		{ name = "misc_zigri", row = 0, col = 1 },
		{ name = "misc_zigri", row = 1, col = 0 },
		{ name = "misc_zigri", row = 1, col = 1 }
	},
	["misc_Rambear"] = {
		{ name = "misc_0179", row = 0, col = 0 },
		{ name = "misc_0179", row = 0, col = 1 },
		{ name = "misc_0179", row = 1, col = 0 },
		{ name = "misc_0179", row = 1, col = 1 }
	},
	["misc_0103"] = {
		{ name = "misc_0055", row = 0, col = 0 },
		{ name = "misc_0055", row = 1, col = 1 },
		{ name = "misc_0055", row = 1, col = 3 },
		{ name = "misc_0055", row = 2, col = 2 },
		{ name = "misc_0055", row = 2, col = 3 },
		{ name = "misc_0055", row = 3, col = 2 }
	},
	["misc_0166"] = {
		{ name = "misc_0144", row = 0, col = 0 },
		{ name = "misc_0144", row = 0, col = 1 },
		{ name = "misc_0144", row = 1, col = 2 },
		{ name = "misc_0144", row = 2, col = 1 },
		{ name = "misc_0144", row = 3, col = 1 }
	},
	["misc_0119"] = {
		{ name = "misc_0109", row = 0, col = 0 },
		{ name = "misc_0109", row = 0, col = 3 },
		{ name = "misc_0109", row = 1, col = 1 },
		{ name = "misc_0109", row = 1, col = 2 },
		{ name = "misc_0109", row = 2, col = 0 },
		{ name = "misc_0109", row = 2, col = 3 }
	},
	["misc_0184"] = {
		{ name = "misc_Infroholder", row = 0, col = 0 },
		{ name = "misc_Infroholder", row = 0, col = 1 },
		{ name = "misc_Infroholder", row = 1, col = 0 },
		{ name = "misc_Infroholder", row = 1, col = 1 }
	},
	["misc_0060"] = {
		{ name = "misc_Dumaro", row = 0, col = 0 },
		{ name = "misc_Dumaro", row = 0, col = 1 },
		{ name = "misc_Dumaro", row = 1, col = 0 },
		{ name = "misc_Dumaro", row = 1, col = 1 }
	},
	["misc_0061"] = {
		{ name = "misc_Ticen", row = 0, col = 0 },
		{ name = "misc_Ticen", row = 0, col = 1 },
		{ name = "misc_Ticen", row = 1, col = 0 },
		{ name = "misc_Ticen", row = 1, col = 1 },
		{ name = "misc_Ticen", row = 2, col = 0 },
		{ name = "misc_Ticen", row = 2, col = 1 }
	},
	["misc_0134"] = {
		{ name = "misc_0131", row = 0, col = 0 },
		{ name = "misc_0131", row = 1, col = 1 },
		{ name = "misc_0131", row = 1, col = 3 },
		{ name = "misc_0131", row = 2, col = 2 },
		{ name = "misc_0131", row = 2, col = 3 },
		{ name = "misc_0131", row = 3, col = 2 }
	},
	["misc_0244"] = {
		{ name = "misc_0196", row = 0, col = 0 },
		{ name = "misc_0196", row = 0, col = 2 },
		{ name = "misc_0196", row = 1, col = 3 },
		{ name = "misc_0196", row = 2, col = 4 },
		{ name = "misc_0196", row = 3, col = 3 },
		{ name = "misc_0196", row = 4, col = 1 }
	},
	["misc_0056"] = {
		{ name = "misc_Ammon", row = 0, col = 0 },
		{ name = "misc_Ammon", row = 0, col = 1 },
		{ name = "misc_Ammon", row = 1, col = 0 },
		{ name = "misc_Ammon", row = 1, col = 1 }
	},
	["misc_Bume_Goblin"] = {
		{ name = "misc_0013", row = 0, col = 0 },
		{ name = "misc_0013", row = 0, col = 1 },
		{ name = "misc_0013", row = 1, col = 0 },
		{ name = "misc_0013", row = 1, col = 1 },
		{ name = "misc_0013", row = 2, col = 0 },
		{ name = "misc_0013", row = 2, col = 1 }
	},
	["misc_0094"] = {
		{ name = "misc_0065", row = 0, col = 0 },
		{ name = "misc_0065", row = 0, col = 1 },
		{ name = "misc_0065", row = 1, col = 0 },
		{ name = "misc_0065", row = 1, col = 1 }
	},
	["TSF02_105"] = {
		{ name = "misc_ore09", row = 0, col = 0 },
		{ name = "misc_ore09", row = 1, col = 0 },
		{ name = "misc_ore09", row = 2, col = 0 },
		{ name = "misc_ore09", row = 3, col = 0 },
		{ name = "misc_ore09", row = 4, col = 0 },
		{ name = "misc_ore09", row = 5, col = 0 }
	},
	["misc_Ticen"] = {
		{ name = "misc_0058", row = 0, col = 0 },
		{ name = "misc_0058", row = 0, col = 1 },
		{ name = "misc_0058", row = 1, col = 0 },
		{ name = "misc_0058", row = 1, col = 1 }
	},
	["misc_humming_bud"] = {
		{ name = "misc_leafly", row = 0, col = 0 },
		{ name = "misc_leafly", row = 0, col = 1 },
		{ name = "misc_leafly", row = 0, col = 3 },
		{ name = "misc_leafly", row = 1, col = 0 },
		{ name = "misc_leafly", row = 1, col = 1 },
		{ name = "misc_leafly", row = 1, col = 3 }
	},
	["misc_Ammon"] = {
		{ name = "misc_0102", row = 0, col = 0 },
		{ name = "misc_0102", row = 0, col = 1 },
		{ name = "misc_0102", row = 1, col = 0 },
		{ name = "misc_0102", row = 1, col = 1 }
	},
	["misc_ellomago"] = {
		{ name = "misc_Bushspider_purple", row = 0, col = 0 },
		{ name = "misc_Bushspider_purple", row = 0, col = 1 },
		{ name = "misc_Bushspider_purple", row = 1, col = 0 },
		{ name = "misc_Bushspider_purple", row = 1, col = 1 }
	},
	["misc_Haming2"] = {
		{ name = "misc_Tontulia", row = 0, col = 0 },
		{ name = "misc_Tontulia", row = 0, col = 1 },
		{ name = "misc_Tontulia", row = 1, col = 0 }
	},
	["misc_0133"] = {
		{ name = "misc_minivern", row = 0, col = 0 },
		{ name = "misc_minivern", row = 0, col = 1 },
		{ name = "misc_minivern", row = 1, col = 0 },
		{ name = "misc_minivern", row = 1, col = 1 }
	},
	["misc_0140"] = {
		{ name = "misc_Repusbunny", row = 0, col = 0 },
		{ name = "misc_Repusbunny", row = 0, col = 1 },
		{ name = "misc_Repusbunny", row = 1, col = 0 },
		{ name = "misc_Repusbunny", row = 1, col = 1 }
	},
	["misc_Fire_Dragon2"] = {
		{ name = "misc_0079", row = 0, col = 0 },
		{ name = "misc_0079", row = 0, col = 1 },
		{ name = "misc_0079", row = 2, col = 1 },
		{ name = "misc_0079", row = 3, col = 1 },
		{ name = "misc_0079", row = 3, col = 2 },
		{ name = "misc_0079", row = 3, col = 5 }
	},
	["misc_0011"] = {
		{ name = "OnionPiece_Red", row = 0, col = 0 },
		{ name = "OnionPiece_Red", row = 0, col = 2 },
		{ name = "OnionPiece_Red", row = 1, col = 1 },
		{ name = "OnionPiece_Red", row = 2, col = 0 },
		{ name = "OnionPiece_Red", row = 2, col = 2 }
	},
	["misc_Corylus"] = {
		{ name = "misc_Caro", row = 0, col = 0 },
		{ name = "misc_Caro", row = 1, col = 0 },
		{ name = "misc_Caro", row = 2, col = 0 },
		{ name = "misc_Caro", row = 3, col = 0 }
	},
	["misc_0025"] = {
		{ name = "misc_0026", row = 0, col = 0 },
		{ name = "misc_0026", row = 0, col = 1 },
		{ name = "misc_0026", row = 1, col = 0 },
		{ name = "misc_0026", row = 1, col = 1 }
	},
	["misc_0112"] = {
		{ name = "misc_seedmia", row = 0, col = 0 },
		{ name = "misc_seedmia", row = 1, col = 0 },
		{ name = "misc_seedmia", row = 2, col = 0 }
	},
	["misc_0019"] = {
		{ name = "misc_0015", row = 0, col = 0 },
		{ name = "misc_0015", row = 0, col = 1 },
		{ name = "misc_0015", row = 1, col = 0 },
		{ name = "misc_0015", row = 1, col = 1 }
	},
	["misc_glizardon"] = {
		{ name = "misc_0018", row = 0, col = 0 },
		{ name = "misc_0018", row = 0, col = 1 },
		{ name = "misc_0018", row = 1, col = 0 },
		{ name = "misc_0018", row = 1, col = 1 },
		{ name = "misc_0018", row = 2, col = 0 },
		{ name = "misc_0018", row = 2, col = 1 }
	},
	["misc_0155"] = {
		{ name = "misc_0152", row = 0, col = 0 },
		{ name = "misc_0152", row = 1, col = 1 },
		{ name = "misc_0152", row = 1, col = 3 },
		{ name = "misc_0152", row = 2, col = 2 },
		{ name = "misc_0152", row = 2, col = 3 },
		{ name = "misc_0152", row = 3, col = 2 }
	},
	["misc_0144"] = {
		{ name = "misc_0080", row = 0, col = 0 },
		{ name = "misc_0080", row = 0, col = 1 },
		{ name = "misc_0080", row = 1, col = 2 },
		{ name = "misc_0080", row = 2, col = 1 },
		{ name = "misc_0080", row = 3, col = 1 }
	},
	["misc_0086"] = {
		{ name = "misc_chromadog", row = 0, col = 0 },
		{ name = "misc_chromadog", row = 0, col = 1 },
		{ name = "misc_chromadog", row = 1, col = 0 },
		{ name = "misc_chromadog", row = 1, col = 1 }
	},
	["misc_0162"] = {
		{ name = "misc_0141", row = 0, col = 0 },
		{ name = "misc_0141", row = 0, col = 1 },
		{ name = "misc_0141", row = 0, col = 2 },
		{ name = "misc_0141", row = 1, col = 0 },
		{ name = "misc_0141", row = 1, col = 2 },
		{ name = "misc_0141", row = 2, col = 0 },
		{ name = "misc_0141", row = 2, col = 1 },
		{ name = "misc_0141", row = 2, col = 2 }
	},
	["misc_0136"] = {
		{ name = "misc_0086", row = 0, col = 0 },
		{ name = "misc_0086", row = 1, col = 0 },
		{ name = "misc_0086", row = 1, col = 1 },
		{ name = "misc_0086", row = 2, col = 0 }
	},
	["misc_0058"] = {
		{ name = "misc_0135", row = 0, col = 0 },
		{ name = "misc_0135", row = 0, col = 1 },
		{ name = "misc_0135", row = 1, col = 0 },
		{ name = "misc_0135", row = 1, col = 1 },
		{ name = "misc_0135", row = 2, col = 0 }
	},
	["misc_0275"] = {
		{ name = "misc_0269", row = 0, col = 0 },
		{ name = "misc_0269", row = 1, col = 1 },
		{ name = "misc_0269", row = 1, col = 3 },
		{ name = "misc_0269", row = 2, col = 2 },
		{ name = "misc_0269", row = 2, col = 3 },
		{ name = "misc_0269", row = 3, col = 2 }
	},
	["misc_0055"] = {
		{ name = "misc_0047", row = 0, col = 0 },
		{ name = "misc_0047", row = 1, col = 1 },
		{ name = "misc_0047", row = 1, col = 3 },
		{ name = "misc_0047", row = 2, col = 2 },
		{ name = "misc_0047", row = 2, col = 3 },
		{ name = "misc_0047", row = 3, col = 2 }
	},
	["misc_0106"] = {
		{ name = "misc_0005", row = 0, col = 0 },
		{ name = "misc_0005", row = 1, col = 0 },
		{ name = "misc_0005", row = 2, col = 0 },
		{ name = "misc_0005", row = 3, col = 0 }
	},
	["misc_Karas"] = {
		{ name = "misc_Dumaro", row = 0, col = 0 },
		{ name = "misc_Dumaro", row = 0, col = 1 },
		{ name = "misc_Dumaro", row = 1, col = 0 },
		{ name = "misc_Dumaro", row = 1, col = 1 },
		{ name = "misc_Dumaro", row = 2, col = 0 },
		{ name = "misc_Dumaro", row = 2, col = 1 }
	},
	["misc_whip_vine_ra2"] = {
		{ name = "misc_popolion3", row = 0, col = 0 },
		{ name = "misc_popolion3", row = 0, col = 1 },
		{ name = "misc_popolion3", row = 0, col = 2 },
		{ name = "misc_popolion3", row = 0, col = 3 }
	},
	["misc_0237"] = {
		{ name = "misc_0236", row = 0, col = 0 },
		{ name = "misc_0236", row = 0, col = 1 },
		{ name = "misc_0236", row = 0, col = 3 },
		{ name = "misc_0236", row = 1, col = 2 },
		{ name = "misc_0236", row = 2, col = 1 },
		{ name = "misc_0236", row = 2, col = 3 },
		{ name = "misc_0236", row = 3, col = 1 },
		{ name = "misc_0236", row = 3, col = 2 }
	},
	["misc_shtayim"] = {
		{ name = "misc_0064", row = 0, col = 0 },
		{ name = "misc_0064", row = 0, col = 1 },
		{ name = "misc_0064", row = 1, col = 0 },
		{ name = "misc_0064", row = 1, col = 1 }
	},
	["misc_0234"] = {
		{ name = "misc_0231", row = 0, col = 0 },
		{ name = "misc_0231", row = 0, col = 1 },
		{ name = "misc_0231", row = 2, col = 1 },
		{ name = "misc_0231", row = 3, col = 1 },
		{ name = "misc_0231", row = 3, col = 2 },
		{ name = "misc_0231", row = 4, col = 1 }
	},
	["misc_0014"] = {
		{ name = "misc_0119", row = 0, col = 0 },
		{ name = "misc_0119", row = 0, col = 1 },
		{ name = "misc_0119", row = 1, col = 0 },
		{ name = "misc_0119", row = 1, col = 1 }
	},
	["misc_0129"] = {
		{ name = "misc_0127", row = 0, col = 0 },
		{ name = "misc_0127", row = 1, col = 0 },
		{ name = "misc_0127", row = 2, col = 0 },
		{ name = "misc_0127", row = 3, col = 0 }
	},
	["misc_banshee"] = {
		{ name = "misc_0018", row = 0, col = 0 },
		{ name = "misc_0018", row = 0, col = 1 },
		{ name = "misc_0018", row = 1, col = 0 },
		{ name = "misc_0018", row = 1, col = 1 }
	},
	["misc_0074"] = {
		{ name = "misc_0139", row = 0, col = 0 },
		{ name = "misc_0139", row = 0, col = 1 },
		{ name = "misc_0139", row = 1, col = 0 },
		{ name = "misc_0139", row = 1, col = 1 }
	},
	["food_Popolion"] = {
		{ name = "misc_0001", row = 0, col = 0 },
		{ name = "misc_0001", row = 0, col = 1 },
		{ name = "misc_0001", row = 1, col = 0 },
		{ name = "misc_0001", row = 1, col = 1 }
	},
	["misc_0006"] = {
		{ name = "misc_0002", row = 0, col = 0 },
		{ name = "misc_0002", row = 0, col = 1 },
		{ name = "misc_0002", row = 1, col = 0 },
		{ name = "misc_0002", row = 1, col = 1 }
	},
	["misc_0072"] = {
		{ name = "misc_0054", row = 0, col = 0 },
		{ name = "misc_0054", row = 0, col = 1 },
		{ name = "misc_0054", row = 1, col = 2 },
		{ name = "misc_0054", row = 2, col = 1 },
		{ name = "misc_0054", row = 3, col = 1 }
	},
	["rsc_2_1"] = {
		{ name = "misc_mud", row = 0, col = 0 },
		{ name = "misc_mud", row = 1, col = 1 },
		{ name = "misc_mud", row = 2, col = 0 },
		{ name = "misc_mud", row = 2, col = 1 },
		{ name = "misc_mud", row = 2, col = 2 }
	},
	["misc_0225"] = {
		{ name = "misc_0162", row = 0, col = 0 },
		{ name = "misc_0162", row = 0, col = 1 },
		{ name = "misc_0162", row = 0, col = 2 },
		{ name = "misc_0162", row = 1, col = 0 },
		{ name = "misc_0162", row = 1, col = 2 },
		{ name = "misc_0162", row = 2, col = 0 },
		{ name = "misc_0162", row = 2, col = 1 },
		{ name = "misc_0162", row = 2, col = 2 }
	},
	["misc_Rudas_loxodon"] = {
		{ name = "misc_mallardu", row = 0, col = 0 },
		{ name = "misc_mallardu", row = 0, col = 1 },
		{ name = "misc_mallardu", row = 1, col = 0 },
		{ name = "misc_mallardu", row = 1, col = 1 }
	},
	["misc_mallardu"] = {
		{ name = "food_Popolion", row = 0, col = 0 },
		{ name = "food_Popolion", row = 0, col = 1 },
		{ name = "food_Popolion", row = 0, col = 3 },
		{ name = "food_Popolion", row = 1, col = 0 },
		{ name = "food_Popolion", row = 1, col = 1 },
		{ name = "food_Popolion", row = 1, col = 3 }
	},
	["misc_0097"] = {
		{ name = "misc_0093", row = 0, col = 0 },
		{ name = "misc_0093", row = 1, col = 0 },
		{ name = "misc_0093", row = 2, col = 0 },
		{ name = "misc_0093", row = 2, col = 1 }
	},
	["misc_liena_pants_1"] = {
		{ name = "misc_0135", row = 0, col = 0 },
		{ name = "misc_0135", row = 0, col = 1 },
		{ name = "misc_0135", row = 1, col = 1 },
		{ name = "misc_0135", row = 2, col = 1 },
		{ name = "misc_0135", row = 3, col = 0 },
		{ name = "misc_0135", row = 3, col = 2 }
	},
	["misc_0137"] = {
		{ name = "misc_minivern", row = 0, col = 0 },
		{ name = "misc_minivern", row = 0, col = 1 },
		{ name = "misc_minivern", row = 1, col = 0 },
		{ name = "misc_minivern", row = 1, col = 1 },
		{ name = "misc_minivern", row = 2, col = 0 },
		{ name = "misc_minivern", row = 2, col = 1 }
	},
	["misc_schlesien_darkmage"] = {
		{ name = "misc_0104", row = 0, col = 0 },
		{ name = "misc_0104", row = 0, col = 1 },
		{ name = "misc_0104", row = 1, col = 0 },
		{ name = "misc_0104", row = 1, col = 1 }
	},
	["misc_seedOil"] = {
		{ name = "misc_seedmia", row = 0, col = 0 },
		{ name = "misc_seedmia", row = 1, col = 1 },
		{ name = "misc_seedmia", row = 2, col = 2 }
	},
	["misc_minivern"] = {
		{ name = "misc_0080", row = 0, col = 0 },
		{ name = "misc_0080", row = 0, col = 1 },
		{ name = "misc_0080", row = 1, col = 0 },
		{ name = "misc_0080", row = 1, col = 1 }
	},
	["misc_talt"] = {
		{ name = "misc_goldbar", row = 0, col = 0 },
		{ name = "misc_goldbar", row = 3, col = 3 }
	},
	["STF02_107"] = {
		{ name = "misc_ore09", row = 0, col = 0 },
		{ name = "misc_ore09", row = 0, col = 1 },
		{ name = "misc_ore09", row = 1, col = 1 },
		{ name = "misc_ore09", row = 2, col = 1 },
		{ name = "misc_ore09", row = 3, col = 1 }
	},
	["misc_goldbar"] = {
		{ name = "misc_talt", row = 0, col = 0 },
		{ name = "misc_talt", row = 0, col = 1 },
		{ name = "misc_talt", row = 1, col = 0 },
		{ name = "misc_talt", row = 1, col = 1 },
		{ name = "misc_talt", row = 2, col = 0 },
		{ name = "misc_talt", row = 2, col = 1 },
		{ name = "misc_talt", row = 3, col = 0 },
		{ name = "misc_talt", row = 3, col = 1 },
		{ name = "misc_talt", row = 4, col = 0 },
		{ name = "misc_talt", row = 4, col = 1 }
	},
	["misc_0201"] = {
		{ name = "misc_0028", row = 0, col = 0 },
		{ name = "misc_0028", row = 0, col = 1 },
		{ name = "misc_0028", row = 1, col = 2 },
		{ name = "misc_0028", row = 2, col = 1 },
		{ name = "misc_0028", row = 3, col = 1 }
	},
	["misc_0232"] = {
		{ name = "misc_0229", row = 0, col = 0 },
		{ name = "misc_0229", row = 0, col = 1 },
		{ name = "misc_0229", row = 0, col = 3 },
		{ name = "misc_0229", row = 1, col = 2 },
		{ name = "misc_0229", row = 2, col = 1 },
		{ name = "misc_0229", row = 2, col = 3 },
		{ name = "misc_0229", row = 3, col = 1 },
		{ name = "misc_0229", row = 3, col = 2 }
	},
	["egg_008"] = {
		{ name = "misc_quicksilver", row = 0, col = 0 },
		{ name = "misc_0011", row = 0, col = 1 },
		{ name = "misc_0236", row = 0, col = 2 },
		{ name = "misc_whip_vine_ra2", row = 1, col = 2 },
		{ name = "misc_0244", row = 1, col = 3 },
		{ name = "misc_yekubite3", row = 1, col = 4 },
		{ name = "misc_Fire_Dragon2", row = 2, col = 3 },
		{ name = "misc_goldbar", row = 3, col = 3 },
		{ name = "misc_talt", row = 4, col = 2 },
		{ name = "misc_seedOil", row = 4, col = 3 },
		{ name = "misc_hanaming2", row = 4, col = 4 },
		{ name = "misc_Dumaro", row = 6, col = 1 },
		{ name = "misc_liena_pants_1", row = 6, col = 3 },
		{ name = "rsc_2_1", row = 6, col = 5 },
		{ name = "misc_icepiece", row = 6, col = 7 }
	},
	["misc_0113"] = {
		{ name = "misc_banshee", row = 0, col = 0 },
		{ name = "misc_banshee", row = 0, col = 1 },
		{ name = "misc_banshee", row = 1, col = 0 },
		{ name = "misc_banshee", row = 1, col = 1 }
	},
	["misc_0271"] = {
		{ name = "misc_0268", row = 0, col = 0 },
		{ name = "misc_0268", row = 0, col = 1 },
		{ name = "misc_0268", row = 2, col = 1 },
		{ name = "misc_0268", row = 3, col = 1 },
		{ name = "misc_0268", row = 3, col = 2 },
		{ name = "misc_0268", row = 4, col = 1 }
	},
	["misc_0163"] = {
		{ name = "misc_0168", row = 0, col = 0 },
		{ name = "misc_0168", row = 0, col = 1 },
		{ name = "misc_0168", row = 1, col = 0 },
		{ name = "misc_0168", row = 1, col = 1 }
	},
	["misc_0268"] = {
		{ name = "misc_0247", row = 0, col = 0 },
		{ name = "misc_0247", row = 0, col = 1 },
		{ name = "misc_0247", row = 2, col = 1 },
		{ name = "misc_0247", row = 3, col = 1 },
		{ name = "misc_0247", row = 3, col = 2 },
		{ name = "misc_0247", row = 4, col = 1 }
	},
	["misc_0247"] = {
		{ name = "misc_0246", row = 0, col = 0 },
		{ name = "misc_0246", row = 0, col = 1 },
		{ name = "misc_0246", row = 2, col = 1 },
		{ name = "misc_0246", row = 3, col = 1 },
		{ name = "misc_0246", row = 3, col = 2 },
		{ name = "misc_0246", row = 4, col = 1 }
	},
	["misc_0246"] = {
		{ name = "misc_0234", row = 0, col = 0 },
		{ name = "misc_0234", row = 0, col = 1 },
		{ name = "misc_0234", row = 2, col = 1 },
		{ name = "misc_0234", row = 3, col = 1 },
		{ name = "misc_0234", row = 3, col = 2 },
		{ name = "misc_0234", row = 4, col = 1 }
	},
	["misc_0135"] = {
		{ name = "misc_Ammon", row = 0, col = 0 },
		{ name = "misc_Ammon", row = 0, col = 1 },
		{ name = "misc_Ammon", row = 1, col = 0 },
		{ name = "misc_Ammon", row = 1, col = 1 },
		{ name = "misc_Ammon", row = 2, col = 0 },
		{ name = "misc_Ammon", row = 2, col = 1 }
	},
	["misc_0173"] = {
		{ name = "misc_0148", row = 0, col = 0 },
		{ name = "misc_0148", row = 0, col = 1 },
		{ name = "misc_0148", row = 0, col = 2 },
		{ name = "misc_0148", row = 1, col = 0 },
		{ name = "misc_0148", row = 1, col = 1 },
		{ name = "misc_0148", row = 1, col = 2 }
	},
	["misc_0054"] = {
		{ name = "misc_0027", row = 0, col = 0 },
		{ name = "misc_0027", row = 0, col = 1 },
		{ name = "misc_0027", row = 1, col = 2 },
		{ name = "misc_0027", row = 2, col = 1 },
		{ name = "misc_0027", row = 3, col = 1 }
	},
	["misc_0045"] = {
		{ name = "misc_0122", row = 0, col = 0 },
		{ name = "misc_0122", row = 0, col = 1 },
		{ name = "misc_0122", row = 1, col = 0 },
		{ name = "misc_0122", row = 1, col = 1 }
	},
	["misc_0235"] = {
		{ name = "misc_0221", row = 0, col = 0 },
		{ name = "misc_0221", row = 0, col = 3 },
		{ name = "misc_0221", row = 1, col = 1 },
		{ name = "misc_0221", row = 1, col = 2 },
		{ name = "misc_0221", row = 2, col = 0 },
		{ name = "misc_0221", row = 2, col = 3 }
	},
	["misc_0231"] = {
		{ name = "misc_0218", row = 0, col = 0 },
		{ name = "misc_0218", row = 0, col = 1 },
		{ name = "misc_0218", row = 2, col = 1 },
		{ name = "misc_0218", row = 3, col = 1 },
		{ name = "misc_0218", row = 3, col = 2 },
		{ name = "misc_0218", row = 4, col = 1 }
	},
	["misc_0127"] = {
		{ name = "misc_0074", row = 0, col = 0 },
		{ name = "misc_0074", row = 0, col = 1 },
		{ name = "misc_0074", row = 1, col = 0 },
		{ name = "misc_0074", row = 1, col = 1 }
	},
	["tree_root_mole1"] = {
		{ name = "misc_0165", row = 0, col = 0 },
		{ name = "misc_0165", row = 0, col = 1 },
		{ name = "misc_0165", row = 1, col = 0 },
		{ name = "misc_0165", row = 1, col = 1 }
	},
	["misc_0210"] = {
		{ name = "misc_0192", row = 0, col = 0 },
		{ name = "misc_0192", row = 0, col = 1 },
		{ name = "misc_0192", row = 2, col = 1 },
		{ name = "misc_0192", row = 3, col = 1 },
		{ name = "misc_0192", row = 3, col = 2 },
		{ name = "misc_0192", row = 4, col = 1 }
	},
	["misc_0176"] = {
		{ name = "misc_0166", row = 0, col = 0 },
		{ name = "misc_0166", row = 0, col = 1 },
		{ name = "misc_0166", row = 1, col = 2 },
		{ name = "misc_0166", row = 2, col = 1 },
		{ name = "misc_0166", row = 3, col = 1 }
	},
	["misc_Bushspider_purple"] = {
		{ name = "misc_Cockatries", row = 0, col = 0 },
		{ name = "misc_Cockatries", row = 0, col = 1 },
		{ name = "misc_Cockatries", row = 1, col = 0 },
		{ name = "misc_Cockatries", row = 1, col = 1 }
	},
	["misc_0192"] = {
		{ name = "misc_0159", row = 0, col = 0 },
		{ name = "misc_0159", row = 0, col = 1 },
		{ name = "misc_0159", row = 2, col = 1 },
		{ name = "misc_0159", row = 3, col = 1 },
		{ name = "misc_0159", row = 3, col = 2 },
		{ name = "misc_0159", row = 4, col = 1 }
	},
	["misc_maize"] = {
		{ name = "misc_0113", row = 0, col = 0 },
		{ name = "misc_0113", row = 0, col = 1 },
		{ name = "misc_0113", row = 1, col = 0 },
		{ name = "misc_0113", row = 1, col = 1 }
	},
	["misc_leafly"] = {
		{ name = "misc_0119", row = 0, col = 0 },
		{ name = "misc_0119", row = 0, col = 1 },
		{ name = "misc_0119", row = 0, col = 2 },
		{ name = "misc_0119", row = 1, col = 0 }
	},
	["misc_0159"] = {
		{ name = "misc_0102", row = 0, col = 0 },
		{ name = "misc_0102", row = 0, col = 1 },
		{ name = "misc_0102", row = 2, col = 1 },
		{ name = "misc_0102", row = 3, col = 1 },
		{ name = "misc_0102", row = 3, col = 2 },
		{ name = "misc_0102", row = 4, col = 1 }
	},
	["misc_Repusbunny"] = {
		{ name = "misc_0153", row = 0, col = 0 },
		{ name = "misc_0153", row = 0, col = 1 },
		{ name = "misc_0153", row = 1, col = 0 },
		{ name = "misc_0153", row = 1, col = 1 }
	},
	["misc_Velwriggler"] = {
		{ name = "misc_Spector_Gh", row = 0, col = 0 },
		{ name = "misc_Spector_Gh", row = 1, col = 0 },
		{ name = "misc_Spector_Gh", row = 2, col = 0 },
		{ name = "misc_Spector_Gh", row = 3, col = 0 }
	},
	["misc_Infroholder"] = {
		{ name = "misc_chromadog", row = 0, col = 0 },
		{ name = "misc_chromadog", row = 1, col = 0 },
		{ name = "misc_chromadog", row = 2, col = 0 },
		{ name = "misc_chromadog", row = 3, col = 0 }
	},
	["misc_0040"] = {
		{ name = "misc_0035", row = 0, col = 0 },
		{ name = "misc_0035", row = 0, col = 1 },
		{ name = "misc_0035", row = 1, col = 0 },
		{ name = "misc_0035", row = 1, col = 1 }
	},
	["misc_0046"] = {
		{ name = "misc_0025", row = 0, col = 0 },
		{ name = "misc_0025", row = 0, col = 1 },
		{ name = "misc_0025", row = 0, col = 2 },
		{ name = "misc_0025", row = 1, col = 0 },
		{ name = "misc_0025", row = 1, col = 1 },
		{ name = "misc_0025", row = 1, col = 2 }
	},
	["Hat_628047"] = {
		{ name = "misc_goldbar", row = 0, col = 1 },
		{ name = "misc_goldbar", row = 0, col = 2 },
		{ name = "misc_goldbar", row = 1, col = 0 },
		{ name = "misc_goldbar", row = 1, col = 1 },
		{ name = "misc_goldbar", row = 1, col = 2 },
		{ name = "misc_goldbar", row = 1, col = 3 }
	},
	["misc_0208"] = {
		{ name = "misc_0177", row = 0, col = 0 },
		{ name = "misc_0177", row = 0, col = 1 },
		{ name = "misc_0177", row = 1, col = 2 },
		{ name = "misc_0177", row = 2, col = 1 },
		{ name = "misc_0177", row = 3, col = 1 }
	},
	["misc_0177"] = {
		{ name = "misc_0175", row = 0, col = 0 },
		{ name = "misc_0175", row = 0, col = 1 },
		{ name = "misc_0175", row = 1, col = 2 },
		{ name = "misc_0175", row = 2, col = 1 },
		{ name = "misc_0175", row = 3, col = 1 }
	},
	["misc_0218"] = {
		{ name = "misc_0215", row = 0, col = 0 },
		{ name = "misc_0215", row = 0, col = 1 },
		{ name = "misc_0215", row = 2, col = 1 },
		{ name = "misc_0215", row = 3, col = 1 },
		{ name = "misc_0215", row = 3, col = 2 },
		{ name = "misc_0215", row = 4, col = 1 }
	},
	["misc_0028"] = {
		{ name = "misc_0022", row = 0, col = 0 },
		{ name = "misc_0022", row = 0, col = 1 },
		{ name = "misc_0022", row = 1, col = 2 },
		{ name = "misc_0022", row = 2, col = 1 },
		{ name = "misc_0022", row = 3, col = 1 }
	},
	["misc_Dumaro"] = {
		{ name = "misc_0046", row = 0, col = 0 },
		{ name = "misc_0046", row = 0, col = 1 },
		{ name = "misc_0046", row = 0, col = 2 },
		{ name = "misc_0046", row = 1, col = 0 },
		{ name = "misc_0046", row = 1, col = 1 },
		{ name = "misc_0046", row = 1, col = 2 }
	},
	["misc_0270"] = {
		{ name = "misc_0266", row = 0, col = 0 },
		{ name = "misc_0266", row = 0, col = 1 },
		{ name = "misc_0266", row = 1, col = 2 },
		{ name = "misc_0266", row = 2, col = 1 },
		{ name = "misc_0266", row = 3, col = 1 }
	},
	["misc_0266"] = {
		{ name = "misc_0216", row = 0, col = 0 },
		{ name = "misc_0216", row = 0, col = 1 },
		{ name = "misc_0216", row = 1, col = 2 },
		{ name = "misc_0216", row = 2, col = 1 },
		{ name = "misc_0216", row = 3, col = 1 }
	},
	["misc_0070"] = {
		{ name = "misc_0093", row = 0, col = 0 },
		{ name = "misc_0093", row = 0, col = 1 },
		{ name = "misc_0093", row = 1, col = 0 },
		{ name = "misc_0093", row = 1, col = 1 }
	},
	["misc_0131"] = {
		{ name = "misc_0128", row = 0, col = 0 },
		{ name = "misc_0128", row = 1, col = 1 },
		{ name = "misc_0128", row = 1, col = 3 },
		{ name = "misc_0128", row = 2, col = 2 },
		{ name = "misc_0128", row = 2, col = 3 },
		{ name = "misc_0128", row = 3, col = 2 }
	},
	["misc_0076"] = {
		{ name = "misc_0075", row = 0, col = 0 },
		{ name = "misc_0075", row = 0, col = 1 },
		{ name = "misc_0075", row = 1, col = 0 },
		{ name = "misc_0075", row = 1, col = 1 }
	},
	["misc_0088"] = {
		{ name = "misc_0081", row = 0, col = 0 },
		{ name = "misc_0081", row = 0, col = 1 },
		{ name = "misc_0081", row = 1, col = 0 },
		{ name = "misc_0081", row = 1, col = 1 }
	},
	["misc_0132"] = {
		{ name = "misc_0083", row = 0, col = 0 },
		{ name = "misc_0083", row = 0, col = 1 },
		{ name = "misc_0083", row = 1, col = 0 },
		{ name = "misc_0083", row = 1, col = 1 }
	},
	["misc_0267"] = {
		{ name = "misc_0263", row = 0, col = 0 },
		{ name = "misc_0263", row = 0, col = 1 },
		{ name = "misc_0263", row = 0, col = 2 },
		{ name = "misc_0263", row = 1, col = 0 },
		{ name = "misc_0263", row = 1, col = 2 },
		{ name = "misc_0263", row = 2, col = 0 },
		{ name = "misc_0263", row = 2, col = 1 },
		{ name = "misc_0263", row = 2, col = 2 }
	},
	["misc_seedmia"] = {
		{ name = "misc_0022", row = 0, col = 0 },
		{ name = "misc_0022", row = 0, col = 1 },
		{ name = "misc_0022", row = 1, col = 0 },
		{ name = "misc_0022", row = 1, col = 1 }
	},
	["misc_0027"] = {
		{ name = "misc_0012", row = 0, col = 0 },
		{ name = "misc_0012", row = 0, col = 1 },
		{ name = "misc_0012", row = 1, col = 2 },
		{ name = "misc_0012", row = 2, col = 1 },
		{ name = "misc_0012", row = 3, col = 1 }
	},
	["misc_0278"] = {
		{ name = "misc_0260", row = 0, col = 0 },
		{ name = "misc_0260", row = 0, col = 1 },
		{ name = "misc_0260", row = 0, col = 3 },
		{ name = "misc_0260", row = 1, col = 2 },
		{ name = "misc_0260", row = 2, col = 1 },
		{ name = "misc_0260", row = 2, col = 3 },
		{ name = "misc_0260", row = 3, col = 1 },
		{ name = "misc_0260", row = 3, col = 2 }
	},
	["misc_0260"] = {
		{ name = "misc_0237", row = 0, col = 0 },
		{ name = "misc_0237", row = 0, col = 1 },
		{ name = "misc_0237", row = 0, col = 3 },
		{ name = "misc_0237", row = 1, col = 2 },
		{ name = "misc_0237", row = 2, col = 1 },
		{ name = "misc_0237", row = 2, col = 3 },
		{ name = "misc_0237", row = 3, col = 1 },
		{ name = "misc_0237", row = 3, col = 2 }
	},
	["misc_0236"] = {
		{ name = "misc_0232", row = 0, col = 0 },
		{ name = "misc_0232", row = 0, col = 1 },
		{ name = "misc_0232", row = 0, col = 3 },
		{ name = "misc_0232", row = 1, col = 2 },
		{ name = "misc_0232", row = 2, col = 1 },
		{ name = "misc_0232", row = 2, col = 3 },
		{ name = "misc_0232", row = 3, col = 1 },
		{ name = "misc_0232", row = 3, col = 2 }
	},
	["misc_quicksilver"] = {
		{ name = "misc_silverbar", row = 0, col = 0 },
		{ name = "misc_silverbar", row = 0, col = 1 },
		{ name = "misc_silverbar", row = 1, col = 0 },
		{ name = "misc_silverbar", row = 3, col = 1 },
		{ name = "misc_silverbar", row = 2, col = 2 }
	},
	["misc_0009"] = {
		{ name = "misc_0004", row = 0, col = 0 },
		{ name = "misc_0004", row = 0, col = 1 },
		{ name = "misc_0004", row = 1, col = 0 },
		{ name = "misc_0004", row = 1, col = 1 }
	},
	["misc_0221"] = {
		{ name = "misc_0138", row = 0, col = 0 },
		{ name = "misc_0138", row = 0, col = 3 },
		{ name = "misc_0138", row = 1, col = 1 },
		{ name = "misc_0138", row = 1, col = 2 },
		{ name = "misc_0138", row = 2, col = 0 },
		{ name = "misc_0138", row = 2, col = 3 }
	},
	["misc_0222"] = {
		{ name = "misc_0149", row = 0, col = 0 },
		{ name = "misc_0149", row = 0, col = 1 },
		{ name = "misc_0149", row = 0, col = 3 },
		{ name = "misc_0149", row = 1, col = 2 },
		{ name = "misc_0149", row = 2, col = 1 },
		{ name = "misc_0149", row = 2, col = 3 },
		{ name = "misc_0149", row = 3, col = 1 },
		{ name = "misc_0149", row = 3, col = 2 }
	},
	["misc_0063"] = {
		{ name = "misc_Tontulia", row = 0, col = 0 },
		{ name = "misc_Tontulia", row = 0, col = 1 },
		{ name = "misc_Tontulia", row = 1, col = 0 },
		{ name = "misc_Tontulia", row = 1, col = 1 }
	},
	["misc_0229"] = {
		{ name = "misc_0222", row = 0, col = 0 },
		{ name = "misc_0222", row = 0, col = 1 },
		{ name = "misc_0222", row = 0, col = 3 },
		{ name = "misc_0222", row = 1, col = 2 },
		{ name = "misc_0222", row = 2, col = 1 },
		{ name = "misc_0222", row = 2, col = 3 },
		{ name = "misc_0222", row = 3, col = 1 },
		{ name = "misc_0222", row = 3, col = 2 }
	},
	["misc_0170"] = {
		{ name = "misc_0152", row = 0, col = 0 },
		{ name = "misc_0152", row = 0, col = 2 },
		{ name = "misc_0152", row = 1, col = 0 },
		{ name = "misc_0152", row = 1, col = 1 },
		{ name = "misc_0152", row = 1, col = 2 },
		{ name = "misc_0152", row = 2, col = 0 },
		{ name = "misc_0152", row = 2, col = 2 }
	},
	["misc_0263"] = {
		{ name = "misc_0225", row = 0, col = 0 },
		{ name = "misc_0225", row = 0, col = 1 },
		{ name = "misc_0225", row = 0, col = 2 },
		{ name = "misc_0225", row = 1, col = 0 },
		{ name = "misc_0225", row = 1, col = 2 },
		{ name = "misc_0225", row = 2, col = 0 },
		{ name = "misc_0225", row = 2, col = 1 },
		{ name = "misc_0225", row = 2, col = 2 }
	},
	["misc_0269"] = {
		{ name = "misc_0226", row = 0, col = 0 },
		{ name = "misc_0226", row = 1, col = 1 },
		{ name = "misc_0226", row = 1, col = 3 },
		{ name = "misc_0226", row = 2, col = 2 },
		{ name = "misc_0226", row = 2, col = 3 },
		{ name = "misc_0226", row = 3, col = 2 }
	},
	["misc_0013"] = {
		{ name = "misc_0008", row = 0, col = 0 },
		{ name = "misc_0008", row = 0, col = 1 },
		{ name = "misc_0008", row = 1, col = 0 },
		{ name = "misc_0008", row = 1, col = 1 }
	},
	["misc_0022"] = {
		{ name = "misc_leafly", row = 0, col = 0 },
		{ name = "misc_leafly", row = 0, col = 1 },
		{ name = "misc_leafly", row = 0, col = 2 },
		{ name = "misc_leafly", row = 1, col = 0 },
		{ name = "misc_leafly", row = 1, col = 1 },
		{ name = "misc_leafly", row = 1, col = 2 },
		{ name = "misc_leafly", row = 2, col = 0 },
		{ name = "misc_leafly", row = 2, col = 1 },
		{ name = "misc_leafly", row = 2, col = 2 }
	},
	["misc_0171"] = {
		{ name = "misc_Mushroom_boy", row = 0, col = 0 },
		{ name = "misc_Mushroom_boy", row = 0, col = 1 },
		{ name = "misc_Mushroom_boy", row = 1, col = 0 },
		{ name = "misc_Mushroom_boy", row = 1, col = 1 }
	},
	["misc_jore15"] = {
		{ name = "misc_jore13", row = 0, col = 0 },
		{ name = "misc_jore13", row = 0, col = 1 },
		{ name = "misc_jore13", row = 1, col = 0 },
		{ name = "misc_jore13", row = 1, col = 1 }
	},
	["misc_0215"] = {
		{ name = "misc_0210", row = 0, col = 0 },
		{ name = "misc_0210", row = 0, col = 1 },
		{ name = "misc_0210", row = 2, col = 1 },
		{ name = "misc_0210", row = 3, col = 1 },
		{ name = "misc_0210", row = 3, col = 2 },
		{ name = "misc_0210", row = 4, col = 1 }
	},
	["misc_0034"] = {
		{ name = "misc_0019", row = 0, col = 0 },
		{ name = "misc_0019", row = 0, col = 1 },
		{ name = "misc_0019", row = 0, col = 2 },
		{ name = "misc_0019", row = 1, col = 0 },
		{ name = "misc_0019", row = 1, col = 1 },
		{ name = "misc_0019", row = 2, col = 0 }
	},
	["misc_Lemuria"] = {
		{ name = "misc_0092", row = 0, col = 0 },
		{ name = "misc_0092", row = 0, col = 1 },
		{ name = "misc_0092", row = 1, col = 0 },
		{ name = "misc_0092", row = 1, col = 1 }
	},
	["misc_Hallowventor"] = {
		{ name = "misc_0061", row = 0, col = 0 },
		{ name = "misc_0061", row = 0, col = 1 },
		{ name = "misc_0061", row = 1, col = 0 },
		{ name = "misc_0061", row = 1, col = 1 }
	},
	["misc_0062"] = {
		{ name = "misc_0128", row = 0, col = 0 },
		{ name = "misc_0128", row = 0, col = 1 },
		{ name = "misc_0128", row = 1, col = 0 },
		{ name = "misc_0128", row = 1, col = 1 }
	},
	["misc_glyquare"] = {
		{ name = "misc_anchor", row = 0, col = 0 },
		{ name = "misc_anchor", row = 0, col = 1 },
		{ name = "misc_anchor", row = 1, col = 0 },
		{ name = "misc_anchor", row = 1, col = 1 }
	},
	["misc_velffigy"] = {
		{ name = "misc_0181", row = 0, col = 0 },
		{ name = "misc_0181", row = 0, col = 1 },
		{ name = "misc_0181", row = 1, col = 0 },
		{ name = "misc_0181", row = 1, col = 1 }
	},
	["Hat_628042"] = {
		{ name = "wood_01", row = 0, col = 0 },
		{ name = "wood_01", row = 0, col = 1 },
		{ name = "wood_01", row = 0, col = 3 },
		{ name = "wood_01", row = 0, col = 4 },
		{ name = "misc_ore09", row = 1, col = 0 },
		{ name = "misc_Echad3", row = 1, col = 1 },
		{ name = "wood_01", row = 1, col = 2 },
		{ name = "misc_shtayim3", row = 1, col = 3 },
		{ name = "misc_ore09", row = 1, col = 4 },
		{ name = "wood_01", row = 2, col = 0 },
		{ name = "wood_01", row = 2, col = 1 },
		{ name = "wood_01", row = 2, col = 3 },
		{ name = "wood_01", row = 2, col = 4 }
	},
	["misc_Tontulia"] = {
		{ name = "misc_Tucen", row = 0, col = 0 },
		{ name = "misc_Tucen", row = 0, col = 1 },
		{ name = "misc_Tucen", row = 1, col = 0 },
		{ name = "misc_Tucen", row = 1, col = 1 }
	},
	["misc_0122"] = {
		{ name = "misc_0103", row = 0, col = 0 },
		{ name = "misc_0103", row = 1, col = 1 },
		{ name = "misc_0103", row = 1, col = 3 },
		{ name = "misc_0103", row = 2, col = 2 },
		{ name = "misc_0103", row = 2, col = 3 },
		{ name = "misc_0103", row = 3, col = 2 }
	},
	["misc_jore14"] = {
		{ name = "misc_jore12", row = 0, col = 0 }
	},
	["misc_0102"] = {
		{ name = "misc_0100", row = 0, col = 0 },
		{ name = "misc_0100", row = 0, col = 1 },
		{ name = "misc_0100", row = 2, col = 1 },
		{ name = "misc_0100", row = 3, col = 1 },
		{ name = "misc_0100", row = 3, col = 2 },
		{ name = "misc_0100", row = 4, col = 1 }
	},
	["misc_Fisherman"] = {
		{ name = "misc_Minos1", row = 0, col = 0 },
		{ name = "misc_Minos1", row = 1, col = 0 },
		{ name = "misc_Minos1", row = 2, col = 0 },
		{ name = "misc_Minos1", row = 3, col = 0 }
	},
	["misc_0093"] = {
		{ name = "misc_shtayim", row = 0, col = 0 },
		{ name = "misc_shtayim", row = 0, col = 1 },
		{ name = "misc_shtayim", row = 1, col = 0 },
		{ name = "misc_shtayim", row = 1, col = 1 }
	},
	["misc_0181"] = {
		{ name = "misc_0175", row = 0, col = 0 },
		{ name = "misc_0175", row = 0, col = 1 },
		{ name = "misc_0175", row = 1, col = 0 },
		{ name = "misc_0175", row = 1, col = 1 }
	},
	["misc_0164"] = {
		{ name = "misc_0162", row = 0, col = 0 },
		{ name = "misc_0162", row = 0, col = 1 },
		{ name = "misc_0162", row = 1, col = 0 },
		{ name = "misc_0162", row = 1, col = 1 }
	},
	["Drug_HP3"] = {
		{ name = "Drug_HP1", row = 0, col = 0 },
		{ name = "Drug_HP1", row = 1, col = 0 },
		{ name = "Drug_HP2", row = 0, col = 1 }
	},
	["misc_mushroom_ent"] = {
		{ name = "misc_Mushroom_boy", row = 0, col = 0 },
		{ name = "misc_Mushroom_boy", row = 0, col = 1 },
		{ name = "misc_Mushroom_boy", row = 1, col = 0 },
		{ name = "misc_Mushroom_boy", row = 1, col = 1 },
		{ name = "misc_Mushroom_boy", row = 2, col = 0 },
		{ name = "misc_Mushroom_boy", row = 2, col = 1 }
	},
	["misc_0035"] = {
		{ name = "misc_0112", row = 0, col = 0 },
		{ name = "misc_0112", row = 1, col = 0 },
		{ name = "misc_0112", row = 2, col = 0 }
	},
	["misc_0141"] = {
		{ name = "misc_0139", row = 0, col = 0 },
		{ name = "misc_0139", row = 0, col = 1 },
		{ name = "misc_0139", row = 0, col = 2 },
		{ name = "misc_0139", row = 1, col = 0 },
		{ name = "misc_0139", row = 1, col = 2 },
		{ name = "misc_0139", row = 2, col = 0 },
		{ name = "misc_0139", row = 2, col = 1 },
		{ name = "misc_0139", row = 2, col = 2 }
	},
	["misc_0008"] = {
		{ name = "misc_0005", row = 0, col = 0 },
		{ name = "misc_0005", row = 0, col = 1 },
		{ name = "misc_0005", row = 1, col = 0 },
		{ name = "misc_0005", row = 1, col = 1 }
	},
	["misc_0178"] = {
		{ name = "misc_kowak", row = 0, col = 0 },
		{ name = "misc_kowak", row = 0, col = 1 },
		{ name = "misc_kowak", row = 1, col = 0 },
		{ name = "misc_kowak", row = 1, col = 1 }
	},
	["misc_0043"] = {
		{ name = "misc_Corylus", row = 0, col = 0 },
		{ name = "misc_Corylus", row = 1, col = 0 },
		{ name = "misc_Corylus", row = 2, col = 0 }
	},
	["misc_0187"] = {
		{ name = "misc_0155", row = 0, col = 0 },
		{ name = "misc_0155", row = 1, col = 1 },
		{ name = "misc_0155", row = 1, col = 3 },
		{ name = "misc_0155", row = 2, col = 2 },
		{ name = "misc_0155", row = 2, col = 3 },
		{ name = "misc_0155", row = 3, col = 2 }
	},
	["misc_0138"] = {
		{ name = "misc_0119", row = 0, col = 0 },
		{ name = "misc_0119", row = 0, col = 3 },
		{ name = "misc_0119", row = 1, col = 1 },
		{ name = "misc_0119", row = 1, col = 2 },
		{ name = "misc_0119", row = 2, col = 0 },
		{ name = "misc_0119", row = 2, col = 3 }
	},
	["misc_0174"] = {
		{ name = "misc_0172", row = 0, col = 0 },
		{ name = "misc_0172", row = 0, col = 1 },
		{ name = "misc_0172", row = 1, col = 0 },
		{ name = "misc_0172", row = 1, col = 1 }
	},
	["misc_0157"] = {
		{ name = "misc_0088", row = 0, col = 0 },
		{ name = "misc_0088", row = 0, col = 1 },
		{ name = "misc_0088", row = 1, col = 0 },
		{ name = "misc_0088", row = 1, col = 1 }
	},
	["misc_0168"] = {
		{ name = "misc_0149", row = 0, col = 0 },
		{ name = "misc_0149", row = 0, col = 1 },
		{ name = "misc_0149", row = 1, col = 0 },
		{ name = "misc_0149", row = 1, col = 1 }
	},
	["misc_0223"] = {
		{ name = "misc_0187", row = 0, col = 0 },
		{ name = "misc_0187", row = 1, col = 1 },
		{ name = "misc_0187", row = 1, col = 3 },
		{ name = "misc_0187", row = 2, col = 2 },
		{ name = "misc_0187", row = 2, col = 3 },
		{ name = "misc_0187", row = 3, col = 2 }
	},
	["misc_0161"] = {
		{ name = "misc_0158", row = 0, col = 0 },
		{ name = "misc_0158", row = 0, col = 1 },
		{ name = "misc_0158", row = 1, col = 0 },
		{ name = "misc_0158", row = 1, col = 1 }
	},
	["misc_Mushroom_boy"] = {
		{ name = "misc_0131", row = 0, col = 0 },
		{ name = "misc_0131", row = 0, col = 1 },
		{ name = "misc_0131", row = 0, col = 2 },
		{ name = "misc_0131", row = 1, col = 0 },
		{ name = "misc_0131", row = 1, col = 1 },
		{ name = "misc_0131", row = 1, col = 2 }
	},
	["misc_0147"] = {
		{ name = "tree_root_mole1", row = 0, col = 0 },
		{ name = "tree_root_mole1", row = 0, col = 1 },
		{ name = "tree_root_mole1", row = 1, col = 0 },
		{ name = "tree_root_mole1", row = 1, col = 1 }
	},
	["misc_0158"] = {
		{ name = "misc_0157", row = 0, col = 0 },
		{ name = "misc_0157", row = 0, col = 1 },
		{ name = "misc_0157", row = 0, col = 2 },
		{ name = "misc_0157", row = 1, col = 0 },
		{ name = "misc_0157", row = 1, col = 1 },
		{ name = "misc_0157", row = 1, col = 2 },
		{ name = "misc_0157", row = 2, col = 0 },
		{ name = "misc_0157", row = 2, col = 1 },
		{ name = "misc_0157", row = 2, col = 2 }
	},
	["misc_0165"] = {
		{ name = "misc_0143", row = 0, col = 0 },
		{ name = "misc_0143", row = 0, col = 1 },
		{ name = "misc_0143", row = 1, col = 0 },
		{ name = "misc_0143", row = 1, col = 1 }
	},
	["misc_puragi"] = {
		{ name = "misc_0018", row = 0, col = 0 },
		{ name = "misc_0018", row = 1, col = 0 },
		{ name = "misc_0018", row = 2, col = 0 }
	},
	["misc_0149"] = {
		{ name = "misc_0147", row = 0, col = 0 },
		{ name = "misc_0147", row = 0, col = 1 },
		{ name = "misc_0147", row = 0, col = 3 },
		{ name = "misc_0147", row = 1, col = 2 },
		{ name = "misc_0147", row = 2, col = 1 },
		{ name = "misc_0147", row = 2, col = 3 },
		{ name = "misc_0147", row = 3, col = 1 },
		{ name = "misc_0147", row = 3, col = 2 }
	},
	["misc_0080"] = {
		{ name = "misc_0072", row = 0, col = 0 },
		{ name = "misc_0072", row = 0, col = 1 },
		{ name = "misc_0072", row = 1, col = 2 },
		{ name = "misc_0072", row = 2, col = 1 },
		{ name = "misc_0072", row = 3, col = 1 }
	},
	["misc_0041"] = {
		{ name = "misc_0020", row = 0, col = 0 },
		{ name = "misc_0020", row = 0, col = 3 },
		{ name = "misc_0020", row = 1, col = 1 },
		{ name = "misc_0020", row = 1, col = 2 },
		{ name = "misc_0020", row = 2, col = 0 },
		{ name = "misc_0020", row = 2, col = 3 }
	},
	["misc_0079"] = {
		{ name = "misc_arburn_pokubu_blue2", row = 0, col = 0 },
		{ name = "misc_arburn_pokubu_blue2", row = 0, col = 1 },
		{ name = "misc_arburn_pokubu_blue2", row = 1, col = 0 },
		{ name = "misc_arburn_pokubu_blue2", row = 1, col = 1 }
	},
	["misc_0205"] = {
		{ name = "misc_0201", row = 0, col = 0 },
		{ name = "misc_0201", row = 0, col = 1 },
		{ name = "misc_0201", row = 1, col = 2 },
		{ name = "misc_0201", row = 2, col = 1 },
		{ name = "misc_0201", row = 3, col = 1 }
	},
	["misc_0172"] = {
		{ name = "misc_0163", row = 0, col = 0 },
		{ name = "misc_0163", row = 0, col = 1 },
		{ name = "misc_0163", row = 1, col = 0 },
		{ name = "misc_0163", row = 1, col = 1 }
	},
	["misc_0156"] = {
		{ name = "misc_0166", row = 0, col = 0 },
		{ name = "misc_0166", row = 0, col = 1 },
		{ name = "misc_0166", row = 1, col = 0 },
		{ name = "misc_0166", row = 1, col = 1 }
	},
	["misc_0049"] = {
		{ name = "misc_0041", row = 0, col = 0 },
		{ name = "misc_0041", row = 0, col = 3 },
		{ name = "misc_0041", row = 1, col = 1 },
		{ name = "misc_0041", row = 1, col = 2 },
		{ name = "misc_0041", row = 2, col = 0 },
		{ name = "misc_0041", row = 2, col = 3 }
	},
	["misc_0010"] = {
		{ name = "misc_0006", row = 0, col = 0 },
		{ name = "misc_0006", row = 0, col = 1 },
		{ name = "misc_0006", row = 1, col = 0 },
		{ name = "misc_0006", row = 1, col = 1 }
	},
	["misc_arburn_pokubu_blue2"] = {
		{ name = "misc_Stoulet", row = 0, col = 0 },
		{ name = "misc_Stoulet", row = 0, col = 1 },
		{ name = "misc_Stoulet", row = 1, col = 0 },
		{ name = "misc_Stoulet", row = 1, col = 1 }
	},
	["misc_0083"] = {
		{ name = "misc_0018", row = 0, col = 0 },
		{ name = "misc_0018", row = 0, col = 1 },
		{ name = "misc_0018", row = 2, col = 1 },
		{ name = "misc_0018", row = 3, col = 1 },
		{ name = "misc_0018", row = 3, col = 2 },
		{ name = "misc_0018", row = 4, col = 1 }
	},
	["misc_0128"] = {
		{ name = "misc_0122", row = 0, col = 0 },
		{ name = "misc_0122", row = 1, col = 1 },
		{ name = "misc_0122", row = 1, col = 3 },
		{ name = "misc_0122", row = 2, col = 2 },
		{ name = "misc_0122", row = 2, col = 3 },
		{ name = "misc_0122", row = 3, col = 2 }
	},
	["misc_0216"] = {
		{ name = "misc_0212", row = 0, col = 0 },
		{ name = "misc_0212", row = 0, col = 1 },
		{ name = "misc_0212", row = 1, col = 2 },
		{ name = "misc_0212", row = 2, col = 1 },
		{ name = "misc_0212", row = 3, col = 1 }
	},
	["misc_0109"] = {
		{ name = "misc_0049", row = 0, col = 0 },
		{ name = "misc_0049", row = 0, col = 3 },
		{ name = "misc_0049", row = 1, col = 1 },
		{ name = "misc_0049", row = 1, col = 2 },
		{ name = "misc_0049", row = 2, col = 0 },
		{ name = "misc_0049", row = 2, col = 3 }
	},
	["misc_0100"] = {
		{ name = "misc_0083", row = 0, col = 0 },
		{ name = "misc_0083", row = 0, col = 1 },
		{ name = "misc_0083", row = 2, col = 1 },
		{ name = "misc_0083", row = 3, col = 1 },
		{ name = "misc_0083", row = 3, col = 2 },
		{ name = "misc_0083", row = 4, col = 1 }
	},
	["misc_galok"] = {
		{ name = "misc_Mentiwood", row = 0, col = 0 },
		{ name = "misc_Mentiwood", row = 0, col = 1 },
		{ name = "misc_Mentiwood", row = 1, col = 0 },
		{ name = "misc_Mentiwood", row = 1, col = 1 }
	},
	["misc_0143"] = {
		{ name = "misc_0134", row = 0, col = 0 },
		{ name = "misc_0134", row = 0, col = 1 },
		{ name = "misc_0134", row = 1, col = 0 },
		{ name = "misc_0134", row = 1, col = 1 }
	},
	["misc_Armory"] = {
		{ name = "misc_rublem", row = 0, col = 0 },
		{ name = "misc_rublem", row = 0, col = 1 },
		{ name = "misc_rublem", row = 1, col = 0 },
		{ name = "misc_rublem", row = 1, col = 1 }
	},
	["misc_Minos1"] = {
		{ name = "misc_Lizardman", row = 0, col = 0 },
		{ name = "misc_Lizardman", row = 0, col = 1 },
		{ name = "misc_Lizardman", row = 1, col = 0 },
		{ name = "misc_Lizardman", row = 1, col = 1 }
	},
	["misc_0175"] = {
		{ name = "misc_0130", row = 0, col = 0 },
		{ name = "misc_0130", row = 0, col = 1 },
		{ name = "misc_0130", row = 1, col = 2 },
		{ name = "misc_0130", row = 2, col = 1 },
		{ name = "misc_0130", row = 3, col = 1 }
	},
	["misc_hanaming2"] = {
		{ name = "leaf_hanaming", row = 0, col = 0 },
		{ name = "leaf_hanaming", row = 0, col = 4 },
		{ name = "leaf_hanaming", row = 1, col = 1 },
		{ name = "leaf_hanaming", row = 1, col = 3 },
		{ name = "leaf_hanaming", row = 2, col = 2 }
	},
	["misc_0018"] = {
		{ name = "misc_0014", row = 0, col = 0 },
		{ name = "misc_0014", row = 0, col = 1 },
		{ name = "misc_0014", row = 1, col = 0 },
		{ name = "misc_0014", row = 1, col = 1 },
		{ name = "misc_0014", row = 2, col = 0 },
		{ name = "misc_0014", row = 2, col = 1 }
	},
	["misc_0059"] = {
		{ name = "misc_0025", row = 0, col = 0 },
		{ name = "misc_0025", row = 0, col = 1 },
		{ name = "misc_0025", row = 1, col = 0 },
		{ name = "misc_0025", row = 1, col = 1 }
	},
	["misc_0152"] = {
		{ name = "misc_0134", row = 0, col = 0 },
		{ name = "misc_0134", row = 1, col = 1 },
		{ name = "misc_0134", row = 1, col = 3 },
		{ name = "misc_0134", row = 2, col = 2 },
		{ name = "misc_0134", row = 2, col = 3 },
		{ name = "misc_0134", row = 3, col = 2 }
	},
	["misc_0081"] = {
		{ name = "misc_0100", row = 0, col = 0 },
		{ name = "misc_0100", row = 0, col = 1 },
		{ name = "misc_0100", row = 1, col = 0 },
		{ name = "misc_0100", row = 1, col = 1 }
	},
	["misc_Mentiwood"] = {
		{ name = "misc_0040", row = 0, col = 0 },
		{ name = "misc_0040", row = 0, col = 1 },
		{ name = "misc_0040", row = 1, col = 0 },
		{ name = "misc_0040", row = 1, col = 1 }
	},
	["misc_0212"] = {
		{ name = "misc_0176", row = 0, col = 0 },
		{ name = "misc_0176", row = 0, col = 1 },
		{ name = "misc_0176", row = 1, col = 2 },
		{ name = "misc_0176", row = 2, col = 1 },
		{ name = "misc_0176", row = 3, col = 1 }
	},
	["misc_0104"] = {
		{ name = "misc_0062", row = 0, col = 0 },
		{ name = "misc_0062", row = 0, col = 1 },
		{ name = "misc_0062", row = 1, col = 0 },
		{ name = "misc_0062", row = 1, col = 1 }
	},
	["misc_0153"] = {
		{ name = "misc_0055", row = 0, col = 0 },
		{ name = "misc_0055", row = 0, col = 1 },
		{ name = "misc_0055", row = 1, col = 0 },
		{ name = "misc_0055", row = 1, col = 1 }
	},
	["misc_0092"] = {
		{ name = "misc_0178", row = 0, col = 0 },
		{ name = "misc_0178", row = 0, col = 1 },
		{ name = "misc_0178", row = 1, col = 0 },
		{ name = "misc_0178", row = 1, col = 1 }
	},
	["misc_0037"] = {
		{ name = "misc_humming_bud", row = 0, col = 0 },
		{ name = "misc_humming_bud", row = 0, col = 1 },
		{ name = "misc_humming_bud", row = 1, col = 0 },
		{ name = "misc_humming_bud", row = 1, col = 1 }
	},
	["misc_0044"] = {
		{ name = "misc_0043", row = 0, col = 0 },
		{ name = "misc_0043", row = 0, col = 1 },
		{ name = "misc_0043", row = 1, col = 0 },
		{ name = "misc_0043", row = 1, col = 1 }
	},
	["misc_0016"] = {
		{ name = "misc_0008", row = 0, col = 0 },
		{ name = "misc_0008", row = 0, col = 1 },
		{ name = "misc_0008", row = 1, col = 0 },
		{ name = "misc_0008", row = 1, col = 1 },
		{ name = "misc_0008", row = 2, col = 0 },
		{ name = "misc_0008", row = 2, col = 1 }
	},
	["misc_Cockatries"] = {
		{ name = "misc_0140", row = 0, col = 0 },
		{ name = "misc_0140", row = 0, col = 1 },
		{ name = "misc_0140", row = 1, col = 0 },
		{ name = "misc_0140", row = 1, col = 1 }
	},
	["misc_rublem"] = {
		{ name = "misc_Bume_Goblin", row = 0, col = 0 },
		{ name = "misc_Bume_Goblin", row = 0, col = 1 },
		{ name = "misc_Bume_Goblin", row = 1, col = 0 },
		{ name = "misc_Bume_Goblin", row = 1, col = 1 }
	},
	["misc_Sakmoli"] = {
		{ name = "misc_0047", row = 0, col = 0 },
		{ name = "misc_0047", row = 0, col = 1 },
		{ name = "misc_0047", row = 1, col = 0 },
		{ name = "misc_0047", row = 1, col = 1 },
		{ name = "misc_0047", row = 2, col = 0 },
		{ name = "misc_0047", row = 2, col = 1 }
	},
	["misc_0047"] = {
		{ name = "misc_0034", row = 0, col = 0 },
		{ name = "misc_0034", row = 1, col = 1 },
		{ name = "misc_0034", row = 1, col = 3 },
		{ name = "misc_0034", row = 2, col = 2 },
		{ name = "misc_0034", row = 2, col = 3 },
		{ name = "misc_0034", row = 3, col = 2 }
	},
	["misc_Grummer"] = {
		{ name = "misc_0010", row = 0, col = 0 },
		{ name = "misc_0010", row = 0, col = 1 },
		{ name = "misc_0019", row = 1, col = 0 },
		{ name = "misc_0019", row = 1, col = 1 }
	},
	["misc_Stoulet"] = {
		{ name = "misc_0155", row = 0, col = 0 },
		{ name = "misc_0155", row = 0, col = 1 },
		{ name = "misc_0155", row = 1, col = 0 },
		{ name = "misc_0155", row = 1, col = 1 }
	},
	["misc_0226"] = {
		{ name = "misc_0223", row = 0, col = 0 },
		{ name = "misc_0223", row = 1, col = 1 },
		{ name = "misc_0223", row = 1, col = 3 },
		{ name = "misc_0223", row = 2, col = 2 },
		{ name = "misc_0223", row = 2, col = 3 },
		{ name = "misc_0223", row = 3, col = 2 }
	},
	["misc_Lizardman"] = {
		{ name = "misc_0070", row = 0, col = 0 },
		{ name = "misc_0070", row = 1, col = 0 },
		{ name = "misc_0070", row = 2, col = 0 }
	},
	["misc_Tucen"] = {
		{ name = "misc_0056", row = 0, col = 0 },
		{ name = "misc_0056", row = 0, col = 1 },
		{ name = "misc_0056", row = 1, col = 0 },
		{ name = "misc_0056", row = 1, col = 1 }
	},
	["misc_0065"] = {
		{ name = "misc_Karas", row = 0, col = 0 },
		{ name = "misc_Karas", row = 0, col = 1 },
		{ name = "misc_Karas", row = 1, col = 0 },
		{ name = "misc_Karas", row = 1, col = 1 }
	},
	["misc_0105"] = {
		{ name = "misc_Hallowventor", row = 0, col = 0 },
		{ name = "misc_Hallowventor", row = 0, col = 1 },
		{ name = "misc_Hallowventor", row = 1, col = 0 },
		{ name = "misc_Hallowventor", row = 1, col = 1 }
	},
	["misc_0015"] = {
		{ name = "misc_0016", row = 0, col = 0 },
		{ name = "misc_0016", row = 0, col = 1 },
		{ name = "misc_0016", row = 1, col = 0 },
		{ name = "misc_0016", row = 1, col = 1 }
	},
	["misc_0179"] = {
		{ name = "misc_0176", row = 0, col = 0 },
		{ name = "misc_0176", row = 1, col = 0 },
		{ name = "misc_0176", row = 2, col = 0 },
		{ name = "misc_0176", row = 3, col = 0 }
	},
	["misc_anchor"] = {
		{ name = "misc_0173", row = 0, col = 0 },
		{ name = "misc_0173", row = 0, col = 1 },
		{ name = "misc_0173", row = 1, col = 0 },
		{ name = "misc_0173", row = 1, col = 1 }
	},
	["misc_0075"] = {
		{ name = "misc_0070", row = 0, col = 0 },
		{ name = "misc_0070", row = 0, col = 1 },
		{ name = "misc_0070", row = 1, col = 0 },
		{ name = "misc_0070", row = 1, col = 1}
	}
}

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
TooltipHelper.indexTbl = {};

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

local function TOOLTIPHELPER_BUILD_COLLECTION_LIST()
	TooltipHelper.indexTbl["Collection"] = {};
	local typeTbl = TooltipHelper.indexTbl["Collection"];
	local clsList, cnt = GetClassList("Collection");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local countingTbl = {};
		local j = 0;
		while true do
			j = j + 1;
			local itemName = TryGetProp(cls,"ItemName_" .. j);

			if itemName == nil or itemName == "None" then
				break
			end

			if typeTbl[itemName] == nil then
				typeTbl[itemName] = {};
			end

			if not contains(countingTbl, itemName) then
				table.insert(countingTbl, itemName);
				table.insert(typeTbl[itemName], {idx = i});
			end
		end
	end
end

local function TOOLTIPHELPER_BUILD_RECIPE_LIST()
	TooltipHelper.indexTbl["Recipe"] = {types = {"Recipe", "Recipe_ItemCraft", "ItemTradeShop"}};
	local typeTbl = TooltipHelper.indexTbl["Recipe"];
	for _, classType in ipairs(typeTbl["types"]) do
		local clsList, cnt = GetClassList(classType);
		for i = 0 , cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local resultItem = GetClass("Item", cls.TargetItem);
			if resultItem ~= nil and resultItem.NotExist ~= 'YES' and resultItem.ItemType ~= 'Unused' then
				local countingTbl = {};
				for j = 1, 5 do
					local item = GetClass("Item", cls["Item_" .. j .. "_1"]);

					if item == "None" or item == nil or item.NotExist == 'YES' or item.ItemType == 'Unused' or item.GroupName == 'Unused' then
						break;
					end

					local itemName = item.ClassName;

					if typeTbl[itemName] == nil then
						typeTbl[itemName] = {};
					end

					if not contains(countingTbl, itemName) then
						local grade = resultItem.ItemGrade;
						if grade == 'None' or grade == nil then
							grade = 0;
						end
						table.insert(countingTbl, itemName);
						table.insert(typeTbl[itemName], {idx = i,
						                                 pos = j,
						                                 grade = grade,
						                                 classType = classType,
						                                 resultItemName = dictionary.ReplaceDicIDInCompStr(resultItem.Name)
						                                 });
					end
				end
			end
		end
	end
	for k, t in pairs(typeTbl) do
		if k ~= "types" then
			table.sort(t, compare);
		end
	end
end

local function TOOLTIPHELPER_BUILD_DROP_LIST()
	local function chanceCompare(a, b)
		if a.chnc ~= b.chnc then
			return a.chnc < b.chnc
		else
			return a.name < b.name
		end
	end

	TooltipHelper.indexTbl["Drops"] = {};
	local typeTbl = TooltipHelper.indexTbl["Drops"];
	local clsList, cnt = GetClassList("Monster");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.GroupName ~= "Item" then
			local dropID = cls.DropItemList;
			if dropID ~= nil and dropID ~= "None" then
				dropID = "MonsterDropItemList_" .. dropID;
				local monName = dictionary.ReplaceDicIDInCompStr(cls.Name);
				for j = 0, GetClassCount(dropID) - 1 do
					local dropIES = GetClassByIndex(dropID, j)
					local itemName = dropIES.ItemClassName;
					local chnc = dropIES.DropRatio;
					local newMob = true;

					if typeTbl[itemName] == nil then
						typeTbl[itemName] = {};
					end

					for k = 1, #typeTbl[itemName] do
						if typeTbl[itemName][k]["name"] == monName and typeTbl[itemName][k]["chnc"] == chnc then
							newMob = false;
							break
						end
					end

					if newMob then
						table.insert(typeTbl[itemName], {name = monName, chnc = chnc})
					end
				end
			end
		end
	end
	for _, t in pairs(typeTbl) do
		table.sort(t, chanceCompare);
	end
end

function JOURNAL_STATS_CUSTOM_TOOLTIP_TEXT(invItem)
	local text = ""
	if invItem.Journal then
		local itemObtainCount = GetItemObtainCount(pc, invItem.ClassID);
		local curScore, maxScore, curLv, curPoint, maxPoint = 0, 0, 0, 0, 0;
		curScore, maxScore = _GET_ADVENTURE_BOOK_POINT_ITEM(invItem.ItemType == 'Equip', itemObtainCount);
		curLv, curPoint, maxPoint = GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO(invItem.ItemType == 'Equip', itemObtainCount);
		text = "Journal Points: (" .. curScore .. "/" .. maxScore .. "){nl}";
		if curScore >= maxPoint then 
			text = "Journal Points Acquired: " .. maxScore .. "{nl}";
		end
		text = text .. "Total Obtained: " .. itemObtainCount .. "{nl}";
	end
    return toIMCTemplate(text, labelColor)
end

function COLLECTION_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
	if TooltipHelper.indexTbl["Collection"] == nil then
		TOOLTIPHELPER_BUILD_COLLECTION_LIST();
	end

	local subTbl = TooltipHelper.indexTbl["Collection"][invItem.ClassName];
	if subTbl == nil then
		return ""
	end

	local partOfCollections = {};
	local myColls = session.GetMySession():GetCollection();
	local clsList, cnt = GetClassList("Collection");
	local item = GetClass("Item", invItem.ClassName);

	for i = 1, #subTbl do
		local cls = GetClassByIndexFromList(clsList, subTbl[i]["idx"]);
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

		local text = "";
		local neededCount = manuallyCount(cls, item);
		local collCount = 0;
		local collName = string.gsub(dictionary.ReplaceDicIDInCompStr(cls.Name), "Collection: ", "")

		if hasRegisteredCollection then
			local info = geCollectionTable.Get(cls.ClassID);
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

	return table.concat(partOfCollections,"{nl}")
end

function RECIPE_ADD_CUSTOM_TOOLTIP_TEXT(invItem)
	if TooltipHelper.indexTbl["Recipe"] == nil then
		TOOLTIPHELPER_BUILD_RECIPE_LIST()
	end

	local subTbl = TooltipHelper.indexTbl["Recipe"][invItem.ClassName];
	if subTbl == nil then
		return ""
	end

	local partOfRecipe = {};
	local superClsList = {};

	for _, classType in ipairs(TooltipHelper.indexTbl["Recipe"]["types"]) do
		superClsList[classType] = GetClassList(classType);
	end

	for _, recipeTbl in ipairs(subTbl) do
		local cls = GetClassByIndexFromList(superClsList[recipeTbl["classType"]], recipeTbl["idx"]);
		local resultItem = GetClass("Item", cls.TargetItem);
		local itemName = dictionary.ReplaceDicIDInCompStr(resultItem.Name);
		local recipeIcon = cls.Icon;

		local recipeItem = GetClass("Item", cls["Item_1_1"]);
		local recipeClassID = recipeItem.ClassID;
		local needCount, haveCount = 1, 0;

		if IS_RECIPE_ITEM(invItem) ~= 0 then
			needCount, haveCount = 1, 1;
		else
			needCount, haveCount = GET_RECIPE_MATERIAL_INFO(cls, recipeTbl["pos"]);
		end

		local isRegistered = false;
		local curScore, maxScore = _GET_ADVENTURE_BOOK_CRAFT_POINT(GetCraftCount(pc, resultItem.ClassID));
		local isCrafted = (curScore >= maxScore);
		local text = "";
		local materialCountText = "";
		local color = commonColor;

		if TooltipHelper.config.showRecipeHaveNeedCount then
			materialCountText = haveCount .. "/" .. needCount;
			local color = unregisteredColor;
			if not isRegistered then
				color = unregisteredColor;
			elseif (invItem.ItemType ~= "Recipe") and (haveCount >= needCount) then
				color = completeColor;
			end
			materialCountText = toIMCTemplate(materialCountText, color)
		end

		itemName = addIcon(itemName, recipeIcon);
		text = toIMCTemplate(itemName, acutil.getItemRarityColor(resultItem))

		if isCrafted then
			text = text .. addIcon("", resultItem.Icon)
		elseif not isRegistered then
			text = toIMCTemplate(itemName, unregisteredColor)
		end

		text = text .. " " .. materialCountText

		if marktioneerex ~= nil then
			local recipeData = marktioneerex.getMinimumData(recipeClassID);
			local newLine = "{nl}    ";
			if (recipeData) then 
				text = text .. newLine .. addIcon("", recipeIcon) .. " ".. toIMCTemplate(GetCommaedText(recipeData.price), labelColor);
			end
			local resultItemData = marktioneerex.getMinimumData(resultItem.ClassID);
			if (resultItemData) then 
				local resultPrice = " " .. addIcon("", resultItem.Icon) .. " ".. toIMCTemplate(GetCommaedText(resultItemData.price), labelColor);
				if (recipeData) then
					text = text .. resultPrice
				else
					text = text .. newLine .. resultPrice
				end
			end
		end
		table.insert(partOfRecipe, text);
	end
	return table.concat(partOfRecipe, "{nl}")
end

function MAGNUM_OPUS_TRANSMUTED_FROM(invItem)
	local newLine = "{nl}"
	local text = ""
	
	local invItemClassName = invItem.ClassName
	
	for k, v in pairs(TooltipHelper.magnumOpusRecipes) do
		if k == invItemClassName then
			local items = v;
			local itemQty = #v
			
			local ingredients = {}
			
			for m = 1, #v do
				local item = v[m]["name"]
				
				if ingredients[item] == nil then
					ingredients[item] = 1
				else
					local oldVal = ingredients[item]
					ingredients[item] = oldVal + 1
				end
			end
			
			--Handle targetItems with multiple ingredients
			for className, quantity in pairs(ingredients) do
				local item = GetClass("Item", className)
				local itemName = dictionary.ReplaceDicIDInCompStr(item.Name)
				text = toIMCTemplate(quantity .. "x" .. addIcon(itemName, item.Icon), labelColor) .. newLine
			end
			
			text = text .. "  "
							
			local maxRow, maxCol = 0, 0;
			for i = 1, itemQty do
				maxRow = math.max(maxRow, items[i]["row"]);
				maxCol = math.max(maxCol, items[i]["col"]);
			end
			for x = 0, maxRow + 1 do
		        for y = 0, maxCol + 1 do
		        	local icon = "{img nomalitem_tooltip_bg 24 24}{/} ";
		        	local isItemFound = false
		        	
					if x <= maxRow then
						for j = 1, itemQty do
							local rowSlot = items[j]["row"]
							local colSlot = items[j]["col"]
							local name = items[j]["name"]
							
							if rowSlot == x and colSlot == y then
								isItemFound = true
							end
							
							if isItemFound == true then
								local prereqItem = GetClass("Item", name)
								local itemIcon = prereqItem.Icon
								icon = "{img " .. prereqItem.Icon .. " 24 24}{/} "
								text = text .. icon
								break;
							end
						end
					end
		        	
		        	if not isItemFound then
		        		text = text .. icon
		        	end
			    end
	        	text = text .. newLine .. "  "
			end
			break;
		end
	end
	
	if text ~= "" then
		text = toIMCTemplate("Transmuted From:{nl} ", labelColor) .. text
	end
	
	return text;
end

function MAGNUM_OPUS_TRANSMUTES_INTO(invItem)
	local text = ""
	
	local targetItems = {}
	local invItemClassName = invItem.ClassName
	
	for k, v in pairs(TooltipHelper.magnumOpusRecipes) do
		local targetItemClassName = k;
		local items = v
		
		for i = 1, #items do
			local itemClass = items[i]["name"]
			
			if itemClass == invItemClassName then
				if targetItems[targetItemClassName] == nil then
					targetItems[targetItemClassName] = 1
				else
					local oldVal = targetItems[targetItemClassName]
					targetItems[targetItemClassName] = oldVal + 1
				end
			end
		end
	end
	
	
	for k, v in pairs(targetItems) do
		local className = k
		local qty = v
		local result = GetClass("Item", className)
		local itemName = dictionary.ReplaceDicIDInCompStr(result.Name)
		text = text .. toIMCTemplate("  " .. qty .. "x", labelColor) 
					.. toIMCTemplate(addIcon("= 1 ", invItem.Icon), labelColor) 
					.. toIMCTemplate(addIcon(itemName, result.Icon) .. "{nl}", labelColor)
	end
	
	if text ~= "" then
		text = toIMCTemplate("Magnum Opus{nl} Transmutes Into:{nl}", labelColor) .. text .. "{nl}";
	end
	
	return text;
end

function RENDER_MAGNUM_OPUS_SECTION(invItem)
	local transmuteInto = MAGNUM_OPUS_TRANSMUTES_INTO(invItem);
	local transmuteFrom = MAGNUM_OPUS_TRANSMUTED_FROM(invItem);
	return transmuteInto .. transmuteFrom; 
end

function RENDER_ITEM_DROP_SECTION(invItem)
	if TooltipHelper.indexTbl["Drops"] == nil then
		TOOLTIPHELPER_BUILD_DROP_LIST();
	end

	local subTbl = TooltipHelper.indexTbl["Drops"][invItem.ClassName];
	if subTbl == nil then
		return ""
	end

	local text = "Drops From:";
	for i = 1, #subTbl do
		text = text .. string.format("{nl}%s: %.2f%%", subTbl[i]["name"], subTbl[i]["chnc"]/100);
	end

	return toIMCTemplate(text, labelColor)
end

function RENDER_CUBE_REROLL_PRICE(tooltipFrame, buffer, invItem)
	if invItem.GroupName == "Cube" then
		local rerollPrice = TryGet(invItem, "NumberArg1")
		if rerollPrice > 0 then
			table.insert(buffer, addIcon("", invItem.Icon) .. toIMCTemplate("Reroll Price: " .. GetCommaedText(rerollPrice), labelColor))
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
			itemLevelLabel = toIMCTemplate("Item Stars: ", labelColor) .. toIMCTemplate(invItem.ItemStar .. " ", acutil.getItemRarityColor(invItem))
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

function RENDER_MAGNUM_OPUS(tooltipFrame, buffer, invItem, text)
	if TooltipHelper.config.showMagnumOpus then 
        text = RENDER_MAGNUM_OPUS_SECTION(invItem)
        if text ~= "" then
            table.insert(buffer,text)    
        end
    end
end

function RENDER_ITEM_DROP(tooltipFrame, buffer, invItem, text)
	if TooltipHelper.config.showItemDrop then
		text = RENDER_ITEM_DROP_SECTION(invItem);
		if text ~= "" then
			table.insert(buffer,text);
		end
	end
end

function CUSTOM_TOOLTIP_PROPS(tooltipFrame, mainFrameName, invItem, strArg, useSubFrame)
    local gBox = GET_CHILD(tooltipFrame, mainFrameName,'ui::CGroupBox');
    
    local yPos = gBox:GetY() + gBox:GetHeight();
    
    local leftTextCtrl = gBox:CreateOrGetControl("richtext", 'text', 0, yPos, 410, 30);
    tolua.cast(leftTextCtrl, "ui::CRichText");
    
	local main_addinfo = tooltipFrame:GetChild("equip_main_addinfo");
	main_addinfo:SetOffset(main_addinfo:GetX(),tooltipFrame:GetHeight()/2);
	local sub_addinfo = tooltipFrame:GetChild("equip_sub_addinfo");
	sub_addinfo:SetOffset(sub_addinfo:GetX(),tooltipFrame:GetHeight()/2);

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
   
    local rightText = ""
    local rightBuffer = {}
    --Magnum Opus
    RENDER_MAGNUM_OPUS(tooltipFrame, rightBuffer, invItem, rightText)
    
	--Item Drop
	RENDER_ITEM_DROP(tooltipFrame, rightBuffer, invItem, rightText);

    if #buffer == 1 and invItem.ItemType == "Equip" then
        text = journalStatsLabel .. itemLevelLabel .. repairRecommendationLabel
    else
        text = table.concat(buffer,"{nl}")
        rightText = table.concat(rightBuffer,"{nl}")
    end
        
    leftTextCtrl:SetText(text);
	leftTextCtrl:SetMargin(20,gBox:GetHeight(),0,0);
    leftTextCtrl:SetGravity(ui.LEFT, ui.TOP)
    
    if rightText ~= "" then
    	local rightTextCtrl = gBox:CreateOrGetControl("richtext", 'text2', math.max(leftTextCtrl:GetWidth()+30,200), yPos, 410, 30);
	    tolua.cast(rightTextCtrl, "ui::CRichText");
	    rightTextCtrl:SetText(rightText)
		--rightTextCtrl:SetMargin(0, gBox:GetHeight(),20,0)
	    --rightTextCtrl:SetGravity(ui.RIGHT, ui.TOP)
	    
    	local width = leftTextCtrl:GetWidth() + rightTextCtrl:GetWidth() + 50;
		width = math.max(width, gBox:GetWidth());
	    if leftTextCtrl:GetHeight() > rightTextCtrl:GetHeight() then
			gBox:Resize(width, gBox:GetHeight() + leftTextCtrl:GetHeight() + 10)
	    else 
			gBox:Resize(width, gBox:GetHeight() + rightTextCtrl:GetHeight() + 10)
	    end
	    
	    local etcCommonTooltip = GET_CHILD(gBox, 'tooltip_etc_common');
	    if etcCommonTooltip ~= nil then
		    etcCommonTooltip:Resize(width, etcCommonTooltip:GetHeight())
	    end
	    
    	local etcDescTooltip = GET_CHILD(gBox, 'tooltip_etc_desc');
		if etcDescTooltip ~= nil then
		    etcDescTooltip:Resize(width, etcDescTooltip:GetHeight())
	    end	
		if string.sub(mainFrameName, #mainFrameName - 3) == "_sub" then
			local widthdif = gBox:GetWidth() - gBox:GetOriginalWidth();
			gBox:SetOffset(gBox:GetX() - widthdif, gBox:GetY());
		end
    else
	    gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + leftTextCtrl:GetHeight() + 10)
    end
    
    buffer = {}
    text = ""
    return leftTextCtrl:GetHeight() + leftTextCtrl:GetY();
end



local function MAGNUM_OPUS_RECIPE_LOADER()
	local status, xml = pcall(require, "xmlSimple");
	if not status then
		ui.SysMsg("Unable to load xmlSimple")
		return
	end

	local recipeXml = xml.newParser():loadFile(TooltipHelper.recipeFile);

	if recipeXml == nil then
		ui.SysMsg("Magnum Opus recipe file not found");
		return
	end

	TooltipHelper.magnumOpusRecipes = {};
	local recipes = recipeXml["Recipe_Puzzle"]:children();

	for i=1,#recipes do
		local recipe = recipes[i];
		local targetItemClassName = recipe["@TargetItem"];
		local ingredients = recipe:children();
		TooltipHelper.magnumOpusRecipes[targetItemClassName] = {};
		for j=1,#ingredients do
			local ingredient = ingredients[j];
			local ingredientItemClassName = ingredient["@Name"];
			local row = ingredient["@Row"];
			local column = ingredient["@Col"];
			table.insert(TooltipHelper.magnumOpusRecipes[targetItemClassName], {name = ingredientItemClassName,
			                                                                    row = tonumber(row),
			                                                                    col = tonumber(column)});
		end
	end
end

function TOOLTIPHELPER_INIT()
	if not TooltipHelper.isLoaded then
		MAGNUM_OPUS_RECIPE_LOADER();
		TOOLTIPHELPER_BUILD_COLLECTION_LIST();
		TOOLTIPHELPER_BUILD_RECIPE_LIST();
		TOOLTIPHELPER_BUILD_DROP_LIST();
		acutil.setupHook(ITEM_TOOLTIP_EQUIP_HOOKED, "ITEM_TOOLTIP_EQUIP");
		acutil.setupHook(ITEM_TOOLTIP_ETC_HOOKED, "ITEM_TOOLTIP_ETC");
		acutil.setupHook(ITEM_TOOLTIP_BOSSCARD_HOOKED, "ITEM_TOOLTIP_BOSSCARD");
		acutil.setupHook(ITEM_TOOLTIP_GEM_HOOKED, "ITEM_TOOLTIP_GEM");
		
		TooltipHelper.isLoaded = true
		
		ui.SysMsg("Tooltip helper loaded!")
	end
end
