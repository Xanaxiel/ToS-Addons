# ToS-Addons
Compatible with the following addons:
* [Excrulon's Addons](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods)
* [fiote's cwAPI](https://github.com/fiote/treeofsavior-addons)



# Tooltip Helper

A simple tooltip helper to indicate which items are:
* Part of a collection
* Components for a recipe

![image](https://cloud.githubusercontent.com/assets/19189593/15227060/1439633c-18b8-11e6-9b43-e67d77f7a0e8.png)

# Configuration

```javascript
local config = {
    showCollectionCustomTooltips = true, //Show collection on item tooltips
    showCompletedCollections = true, //Show completed collections on item tooltips
    showRecipeCustomTooltips = true //Show recipes on item tooltips
}
```

# Installation

Depending on which release you downloaded, navigate to their installation section. Paste this folder inside the `/path/to/TreeOfSavior/addons` folder afterwards.

If you're using [Excrulon's addon pack](https://github.com/Excrulon/Tree-of-Savior-Lua-Mods), don't forget to add the following line after the last `dofile` line
```javascript
dofile("../addons/tooltiphelper/tooltiphelper.lua");
```





