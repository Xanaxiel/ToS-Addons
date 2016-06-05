*For those asking:* 

 * *Yes, my reddit handle is /u/lkamikazel (an old account, too lazy to make a new one)*
 * *Yes, I play on [SEA]Telsiai - I could always use some Talt D:*

# Tooltip Helper

![image](https://cloud.githubusercontent.com/assets/19189593/15808840/eee97b66-2bb4-11e6-9bf8-da6d570547e0.png)

**A simple tooltip helper showing the following information:**

* **Journal Status**
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15796957/6ec2c458-2a3b-11e6-98cd-39dd15944c4f.png) ![image](https://cloud.githubusercontent.com/assets/19189593/15796961/7e78d662-2a3b-11e6-8407-d3f33a135976.png) - **Number of adventure journal points gained from the item (points for equipment scale on their upgrade level)**  
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15796960/74ea12c8-2a3b-11e6-8b42-cb6de7dc12f8.png) - **Total number of the current item obtained**

* ![image](https://cloud.githubusercontent.com/assets/19189593/15796968/9ab70c72-2a3b-11e6-9008-bdf46738f18f.png) **Collection components** 
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15760053/183b2a6e-2944-11e6-8011-c95745d01955.png) - **Collection completed** 
 *  ![image](https://cloud.githubusercontent.com/assets/19189593/15760013/f7f82248-2943-11e6-925e-889138259f76.png) - **Collection in progress**
 *  ![image](https://cloud.githubusercontent.com/assets/19189593/15759886/5e2b72be-2943-11e6-91e4-2d2740473981.png) - **Collection is not yet registered**
* ![image](https://cloud.githubusercontent.com/assets/19189593/15808821/6b2e1dc2-2bb4-11e6-8e76-ce4c64943089.png) **Recipe components**
  * **Colored text according to item grade when you OBTAIN the recipe (same coloring as [Colored Item Names](https://github.com/TehSeph/tos-addons#colored-item-names---v100))**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808826/7f4bb38c-2bb4-11e6-8b1d-1b7a43ab2dc0.png) - **Common grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808827/856ab150-2bb4-11e6-95d4-b9a26fdd8004.png) - **Uncommon grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808828/8ae50ebe-2bb4-11e6-8c03-23998852ddbd.png) - **Rare grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808830/916afd66-2bb4-11e6-87c9-24084af72c8d.png) - **Set Item**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808831/96bce3d8-2bb4-11e6-94f4-e0ef5ca2104d.png) - **Legendary grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15808832/a327631e-2bb4-11e6-9b54-182bca9e0d95.png) - **Recipe not yet obtained**
  * ![image](https://cloud.githubusercontent.com/assets/19189593/15808834/c5d3ffc6-2bb4-11e6-96b3-4a7910b4aa18.png) - **Item icon visible - you have CRAFTED the recipe at least once**
* **Equipment**
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15760899/01886d50-2948-11e6-8646-4ea471211541.png) - **Shows item level - helpful info for item awakening/feeding equipment to gems**
 *  ![image](https://cloud.githubusercontent.com/assets/19189593/15760906/0af1262a-2948-11e6-9bd3-325af3d2c1c2.png) ![image](https://cloud.githubusercontent.com/assets/19189593/15761025/9e9ebf40-2948-11e6-9b15-f5b5b0634ae8.png) - **Recommends where to get repairs - Squire vs NPC**

# Show Pet Stamina (Mounted) 

Shows pet stamina when mounted on your pet

![image](https://cloud.githubusercontent.com/assets/19189593/15264239/cac6b1c2-19a3-11e6-925b-cbf3643842ae.png)
![image](https://cloud.githubusercontent.com/assets/19189593/15264233/c41c43aa-19a3-11e6-8a83-a9e619339f31.png)

# Installation
__\*Don't use the source files unless you know how to use them\*__

Don't get your hands dirty! Use Excrulon's [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager/releases/latest). __Make sure to read the [instructions](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager#download--install) and [FAQs](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager#faq)__

# Configuration

* Auto-generated Tooltip Helper configuration - found in `../TreeOfSavior/addons/tooltiphelper/tooltiphelper.json`
```javascript
{
    "showCollectionCustomTooltips" : true, //Show collection on item tooltips
    "showCompletedCollections"     : true, //Show completed collections on item tooltips
    "showRecipeCustomTooltips"     : true, //Show recipes on item tooltips
    "showItemLevel"                : true, //Show item level for equipment
    "showJournalStats"	           : true, //Show journal stats for the item
    "showRepairRecommendation"     : true, //Show repair recommendation
    "squireRepairPerKit"           : 200   //Set price threshold for repair kits -- 160 is the minimum for the Squire to break even
}
```

# What addons do your addons conflict with?

100% guaranteed compatible with the following

* https://github.com/Excrulon/Tree-of-Savior-Lua-Mods
* https://github.com/fiote/treeofsavior-addons
* https://github.com/Miei/TOS-lua
* https://github.com/MizukiBelhi/ExtendedUI
* https://github.com/MrJul/ToS-EnhancedCollection
* https://github.com/TehSeph/tos-addons
* https://github.com/WillTheDoggy/Doggy-ToS-Addons

If you still have questions or concerns, join our [ToS Addon Discord server](https://discord.gg/0yyOKTr8o3OdJTxa). 