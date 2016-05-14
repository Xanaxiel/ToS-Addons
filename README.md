# ToS-Addons
Compatible with the following addons:
* [Excrulon's Addons](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods)
* [fiote's cwAPI](https://github.com/fiote/treeofsavior-addons)



# Tooltip Helper

A simple tooltip helper to indicate which items are:
* Part of a collection
* Components for a recipe

![image](https://cloud.githubusercontent.com/assets/19189593/15227060/1439633c-18b8-11e6-9b43-e67d77f7a0e8.png)

# Show Pet Stamina (Mounted)

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

Download the latest release from the releases tab or [this link](https://github.com/Xanaxiel/ToS-Addons/releases/latest) and extract the contents of the archive into your `../path/to/TreeOfSavior/addons` folder (G:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior\addons).

**Take note:** If you're using [Excrulon's addon pack](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods), don't forget to add the following line after the last `dofile` line
```javascript
dofile("../addons/tooltiphelper/tooltiphelper.lua");
```

For those using fiote's addon loader, no additional steps needed.




