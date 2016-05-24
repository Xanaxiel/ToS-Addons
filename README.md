*For those asking:* 
 * *Yes, my reddit handle is /u/lkamikazel (an old account, too lazy to make a new one)*
 * *Yes, I play on [SEA]Telsiai*

# ToS-Addons
Compatible with the following addons:
* [Excrulon's Addons](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods)
* [fiote's cwAPI](https://github.com/fiote/treeofsavior-addons)



# Tooltip Helper

A simple tooltip helper to indicate which items are:
* Part of a collection
 * Shows which you have already completed
* Components for a recipe 
 * Shows registered status - since some recipes need to be manually registered before being able to craft, as well as others which should automatically be registered when you obtain them, when in fact they aren't)
 * Shows crafted status - at least once
* Show item level for equipment - *helpful info for item awakening/feeding equipment to gems*

![image](https://cloud.githubusercontent.com/assets/19189593/15440047/dae36714-1f05-11e6-9434-f024056c4edf.png)

# Show Pet Stamina (Mounted) 
**Will be included in Excrulon's next release - only added it here as it originally served as an enhancement to Excrulon's pack (along with showing mounted bonuses) but I didn't know when he'd do a release back then*

Shows pet stamina when mounted on your pet

![image](https://cloud.githubusercontent.com/assets/19189593/15264239/cac6b1c2-19a3-11e6-925b-cbf3643842ae.png)
![image](https://cloud.githubusercontent.com/assets/19189593/15264233/c41c43aa-19a3-11e6-8a83-a9e619339f31.png)

# Configuration

* Tooltip Helper properties - found in `../TreeOfSavior/addons/tooltiphelper/tooltiphelper.properties`
```javascript
local config = {
    showCollectionCustomTooltips=true, //Show collection on item tooltips
    showCompletedCollections=true, //Show completed collections on item tooltips
    showRecipeCustomTooltips=true //Show recipes on item tooltips
    showItemLevel=true //Show item level for equipment
}
```

# Installation
**Don't use the source files unless you know how to use them**

* Download the latest release from the [releases tab](https://github.com/Xanaxiel/ToS-Addons/releases/latest) and extract the contents of the archive into your `../path/to/TreeOfSavior` folder (G:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior)





