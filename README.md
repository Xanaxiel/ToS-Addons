*For those asking:* 
 * *Yes, my reddit handle is /u/lkamikazel (an old account, too lazy to make a new one)*
 * *Yes, I play on [SEA]Telsiai*

# Tooltip Helper

A simple tooltip helper to indicate which items are:
* Collection Items
 * Shows which you have already completed
* Recipes
 * Shows registered status - some recipes need to be manually registered before being able to craft, as well as others which should     automatically be registered when you obtain them, when in fact they aren't
 * Shows crafted status - crafted the item at least once
* Equipment
 * Shows item level - helpful info for item awakening/feeding equipment to gems
 * Recommends where to get repairs - whether it's more cost-effective to repair via Squire to take advantage of bonus durability which scales   on Squire's Repair skill level (as well as how they price their repair kits, by default it is set to a minimal profit threshold),    but much more expensive the more durability is lost; or via NPC wherein the price is constant regardless of how much durability is   lost

![image](https://cloud.githubusercontent.com/assets/19189593/15440047/dae36714-1f05-11e6-9434-f024056c4edf.png)

# Show Pet Stamina (Mounted) 

Shows pet stamina when mounted on your pet

![image](https://cloud.githubusercontent.com/assets/19189593/15264239/cac6b1c2-19a3-11e6-925b-cbf3643842ae.png)
![image](https://cloud.githubusercontent.com/assets/19189593/15264233/c41c43aa-19a3-11e6-8a83-a9e619339f31.png)

# Configuration

* Tooltip Helper properties - found in `../TreeOfSavior/addons/tooltiphelper/tooltiphelper.properties`
```javascript
local config = {
    showCollectionCustomTooltips=true, //Show collection on item tooltips
    showCompletedCollections=true, //Show completed collections on item tooltips
    showRecipeCustomTooltips=true, //Show recipes on item tooltips
    showItemLevel=true, //Show item level for equipment
    showRepairRecommendation = true, //Show repair recommendation
    squireRepairPerKit = 200 //Set price threshold for repair kits -- 160 is the minimum for the Squire to break even
}
```

# Installation
__\*Don't use the source files unless you know how to use them\*__

* Download the latest release from the [releases tab](https://github.com/Xanaxiel/ToS-Addons/releases/latest) and extract the contents of the archive into your `../path/to/TreeOfSavior` folder (G:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior)

# What addons do your addons conflict with?

100% guaranteed compatible with the following

* https://github.com/Excrulon/Tree-of-Savior-Lua-Mods
* https://github.com/fiote/treeofsavior-addons
* https://github.com/Miei/TOS-lua
* https://github.com/MizukiBelhi/ExtendedUI
* https://github.com/MrJul/ToS-EnhancedCollection
* https://github.com/TehSeph/tos-addons
* https://github.com/WillTheDoggy/Doggy-ToS-Addons

If you still have questions or concerns, join our [ToS Addon Discord server](https://discord.gg/0yyOKTr8o3OdJTxa)
