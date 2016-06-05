*For those asking:* 

 * *Yes, my reddit handle is /u/lkamikazel (an old account, too lazy to make a new one)*
 * *Yes, I play on [SEA]Telsiai - I could always use some Talt D:*

# Tooltip Helper

![image](https://cloud.githubusercontent.com/assets/19189593/15796947/651c39ca-2a3b-11e6-8ca4-eeef88ecc879.png)

**A simple tooltip helper showing the following information:**

* **Journal Status**
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15796957/6ec2c458-2a3b-11e6-98cd-39dd15944c4f.png) ![image](https://cloud.githubusercontent.com/assets/19189593/15796961/7e78d662-2a3b-11e6-8407-d3f33a135976.png) - **Number of adventure journal points gained from the item (points for equipment scale on their upgrade level)**  
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15796960/74ea12c8-2a3b-11e6-8b42-cb6de7dc12f8.png) - **Total number of the current item obtained**

* ![image](https://cloud.githubusercontent.com/assets/19189593/15796968/9ab70c72-2a3b-11e6-9008-bdf46738f18f.png) **Collection components** 
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15760053/183b2a6e-2944-11e6-8011-c95745d01955.png) - **Collection completed** 
 *  ![image](https://cloud.githubusercontent.com/assets/19189593/15760013/f7f82248-2943-11e6-925e-889138259f76.png) - **Collection in progress**
 *  ![image](https://cloud.githubusercontent.com/assets/19189593/15759886/5e2b72be-2943-11e6-91e4-2d2740473981.png) - **Collection is not yet registered**
* **Recipe components** - __The prefixed icons represent the__ **CRAFTED ITEM** 
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15760787/6e370bc4-2947-11e6-924e-87be27b5116d.png) - **Anvil icon shown - You have OBTAINED and CRAFTED the item at least once**
 * **Text will be colored according to it's item grade when you OBTAIN them (same coloring as [Colored Item Names](https://github.com/TehSeph/tos-addons#colored-item-names---v100))**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15760291/173994ec-2945-11e6-85be-b013915c6bee.png) - **Common grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15760299/202d6f38-2945-11e6-8681-6b449b30ead5.png) - **Uncommon grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15760310/2cbc2bfe-2945-11e6-95eb-2dd5220725be.png) - **Rare grade**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15760372/80c8d864-2945-11e6-85a8-62d959ecb345.png) - **Set Item**
     * ![image](https://cloud.githubusercontent.com/assets/19189593/15760387/8e45fe40-2945-11e6-9433-0c9ef007a3b0.png) - **Legendary grade**
 * ![image](https://cloud.githubusercontent.com/assets/19189593/15760875/e02f5fb0-2947-11e6-8cb7-8db8e82ba22a.png) - **Greyed out text if you haven't obtained the RECIPE of the item**
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