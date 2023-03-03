# Dual Universe Schematics Monitor

![Screenshot 2023-03-03 215923](https://user-images.githubusercontent.com/94600381/222704352-691b1db6-d70a-4174-9ba6-7e2ad3d7ed5c.png)

Instalation:
1. Place Programming Board
2. Copy code from [HERE](https://raw.githubusercontent.com/Vtreka/DU-Schematics-Monitor/main/LUA.json) and paste it into board by Right mouse click -> Advanced -> Paste Lua Configuration from Clipboard
3. Connect PB to CONTAINER FIRST and then to screen(s). 

MAIN THING is to link container to the first slot which contains needed event listeners. Rest 9 slots can be used for 9 screens. 

Extra:
You can have multiple screens by simply linking more than one screen to PB. 
By default script will only show first page on all linked screens, to get second page you will need to go into build mode, right click screen and rename it to **Screen_2**

Aditional information:
You can prioritize schematics which will be shown as orange when amount is lower than 100%, this is to simply for regular users to know which ones needs to be printed and which ones are not that important. This needs to be done by directly editing code, was to lazy to add exported variable for it. Its straight forward way, just change "false" to "true" for schematics you want to prioritize.

Just keep in mind that container contents can only be updated every 30 seconds PER player. So if you have multiple scripts scanning containers then it might take some extra time for contents to be updated. Soonest update will be indicated with a timer on top left corner.
Running it for the first time, dont forget to turn on screen and nothing will appear in it until container content scan is performed, which can be delayed due to previously mentioned limitations.

<hr>
Version 2.0 Update

Added in the following sections and schematics to be tracked:

Deployables:
   - Bonsai
   - Territory Unit
   - Warp Beacon

Fuel (renamed from Consumables) and set to alphabetical order.

Scrap - Tier 2-5

Colours for Tier 2-5 to match standard Tier colouring.
