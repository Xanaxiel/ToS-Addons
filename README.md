**For those asking, yes my reddit handle is /u/lkamikazel (an old account, too lazy to make a new one)*
*and yes I play on [SEA]Telsiai*

# ToS-Addons
Compatible with the following addons:
* [Excrulon's Addons](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods)
* [fiote's cwAPI](https://github.com/fiote/treeofsavior-addons)



# Tooltip Helper

A simple tooltip helper to indicate which items are:
* Part of a collection
* Components for a recipe

![image](https://cloud.githubusercontent.com/assets/19189593/15276126/6aa56a58-1b11-11e6-8bc7-9a9839024c0d.png)

# Show Pet Stamina (Mounted) 
**Will be included in Excrulon's next release - only added it here as it originally served as an enhancement to Excrulon's pack (along with showing mounted bonuses) but I didn't know when he'd do a release back then*

Shows pet stamina when mounted on your pet

![image](https://cloud.githubusercontent.com/assets/19189593/15264239/cac6b1c2-19a3-11e6-925b-cbf3643842ae.png)
![image](https://cloud.githubusercontent.com/assets/19189593/15264233/c41c43aa-19a3-11e6-8a83-a9e619339f31.png)

# Configuration

```javascript
local config = {
    showCollectionCustomTooltips = true, //Show collection on item tooltips
    showCompletedCollections = true, //Show completed collections on item tooltips
    showRecipeCustomTooltips = true //Show recipes on item tooltips
}
```

# Installation

Required dependencies:
* Download latest release from **either** [Excrulon's Addons](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods) or [fiote's cwAPI](https://github.com/fiote/treeofsavior-addons)
* Download the latest release from the [releases tab](https://github.com/Xanaxiel/ToS-Addons/releases/latest) and extract the contents of the archive into your `../path/to/TreeOfSavior/addons` folder (G:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior\addons)

**Take note:** If you're using **ONLY** Excrulon's addons, don't forget to add the following lines after the last `dofile` line on `addonloader.lua`

```javascript
--[[ADDONS]]
dofile("../addons/betterquest/betterquest.lua");
dofile("../addons/blockandreport/blockandreport.lua");
dofile("../addons/channelsurfer/channelsurfer.lua");
dofile("../addons/expviewer/expviewer.lua");
dofile("../addons/guildmates/guildmates.lua");
dofile("../addons/hidemaxedattributes/hidemaxedattributes.lua");
dofile("../addons/mapfogviewer/mapfogviewer.lua");
dofile("../addons/monsterframes/monsterframes.lua");
dofile("../addons/monstertracker/monstertracker.lua");
dofile("../addons/showinvestedstatpoints/showinvestedstatpoints.lua");
dofile("../addons/tooltiphelper/tooltiphelper.lua") --add this
dofile("../addons/showpetstamina/showpetstamina.lua") --add this
```

For those using fiote's addon loader, **no additional steps needed**.




