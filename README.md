# Dual Universe Schematics Monitor

![Screenshot 2023-03-03 215923](https://user-images.githubusercontent.com/94600381/222704352-691b1db6-d70a-4174-9ba6-7e2ad3d7ed5c.png)

Installation:
1. Place Programming Board
2. Copy code from [HERE](https://raw.githubusercontent.com/Vtreka/DU-Schematics-Monitor/main/LUA.json) and paste it into board by Right mouse click -> Advanced -> Paste Lua Configuration from Clipboard
3. Connect PB to CONTAINER FIRST and then to screen(s). 

MAIN THING is to link container to the first slot which contains needed event listeners.

Screen can be in vertical or horizontal position. Its state will automatically update depending on how you place monitor. Horizontal monitor will contain all 3 pages on one screen, while vertical one will contain only one page per screen.

Extra:
You can have multiple screens by simply linking more than one screen to PB. 
By default script will only show first page on all linked screens, to get second page you will need to go into build mode, right click screen and rename it to **Screen_2** or **Screen_3**

Additional information:
You can prioritize schematics which will be shown as red when amount is lower than 100%, this to be more obvious for regular users to know which ones needs to be printed and which ones are not that important. This needs to be done by directly editing code, was to lazy to add exported variable for each of them. Its straight forward way, just add "true" for schematics you want to prioritize as some existing examples in default setup. 
Aditionally you can set schematic to "false" which will set schematic to low priority. High priority schematics name turn white when amount is equal or over 100%, normal priority schematics will turn grey when there is enough of those. Low priority remains grey at all times. 
Tile and sub borders will turn red in case linked schematics container isint set to be used as main for entire core. This can be disabled in LUA parameters window.

Just keep in mind that container contents can only be updated every 30 seconds PER player. So if you have multiple scripts scanning containers then it might take some extra time for contents to be updated. Soonest update will be indicated with a timer on top left corner.
Running it for the first time, dont forget to turn on screen and nothing will appear in it until container content scan is performed, which can be delayed due to previously mentioned limitations.

<hr>
<b>Version 2.1 Update</b>
Can now add in a 3rd screen for Tier 2-4 Ammo
Screen can be in vertical or horizontal position. Its state will automatically update depending on the rotation of the monitor. Horizontal monitor will contain all 3 pages on one screen, while vertical one will contain only one page per screen.
Priority Colours added to top right of screen - Can set colours in parameters
Tile and sub borders will turn red in case linked schematics container isint set to be used as main for entire core. This can be disabled in LUA parameters window.
Can now connect a Databank to save new Parameters
Parameters added:
   - Low/High Priority Colours
   - Tier 1-5 Colours
   - When checked, if the container connected is not the container set as the Core Schematics container the borders will turn red
   - Localize parameter to localize schematic names

<b>Version 2.0 Update</b>

Added in the following sections and schematics to be tracked:

Deployables:
   - Bonsai
   - Territory Unit
   - Warp Beacon

Fuel (renamed from Consumables) and set to alphabetical order.

Scrap - Tier 2-5

Colours for Tier 2-5 to match standard Tier colouring.
