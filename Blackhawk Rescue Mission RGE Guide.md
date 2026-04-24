# Title

*Made by Maxikxng3*  
BRM5

# **Realtime Game Editor**

Guidebook

\**Disclaimer: This Guide is not an official document by Platinum 5*\*

MADE BY MAXIKXNG3  
[**RGE Guidelines**](https://docs.google.com/document/d/1L-b-AWN4pXf5tYGjXA8Q43HxBFOPUn-LT9PmLtTe6H0/edit?usp=sharing%20) **by PLM5**

**Contents:**

[Known Bugs and Fixes]()  
[Controls & Hotkeys]()  
[Commands]()  
[Triggers]() WIP

**Note:**  
If you find any Bugs or Fixes that have not been Included, or Errors in this Document, please Contact @Maxikxng3 on Discord on the PLM5 Server.

**Contributions:**  
**@milordmaximka (Kalashnikov\_Maxim)**  
\-Commands, Camera Movement, Hotkeys

**@fen.perez (fen0612)**  
\-Commands, general Help

# Known Bugs and Fixes

**Known Bugs and Fixes**  
MADE BY MAXIKXNG3

Bug \#1  
Symptoms:  
\-Unable to Load Map  
	\-Map Loading gets stuck at “Baking Navmesh Data” step

Cause:  
\-Loading a Map upon Private server Load which includes Custom Navmesh

Fix:	(This Fix is not Tested by me, and in turn has a chance to not work)  
\-Set Standard Private Server Map as “OW\_Ronograd” or “OW\_Blank” depending  
 on what Map your Save is Created on.  
\-Load Private Server and Open RGE, go to the “AI” Tab, Enable the Custom Navmesh.  
\-Load your Map through the Console or Load Button.

Bug FIXED  
Symptoms:   
\-Unable to enter Studio+ Camera mode  
\-Part´s set as Triggers creating “Ghosts”

Cause:  
\-Saving a Custom Model wich includes Part´s set as Triggers

Fix:  
\-Search through your Custom Model list for Models that include Triggers.  
\-Delete any Model that includes Triggers, or Save over the Model with a  
 Version that does not include Triggers / has “isTrigger” turned off on all Triggers.

Bug FIXED  
Symptoms:  
\-in Private Servers Admins that are not the Owner are unable to use the savecopy and loadcopy Commands

Cause:   
\-Unknown

Fix:   
\-Unknown

# Controls & Hotkeys

**Controls**  
MADE BY MAXIKXNG3

Selecting a Camera:

| Camera Movement |
| ----- |
| W \= Forward |
| S \= Backward |
| A \= Left |
| D \= Right |
| E \= Up                                                           \*only Cinematic and Studio Camera |
| Q \= Down                                                      \*only Cinematic and Studio Camera |
| Shift \= Slow Camera Movement |
| Ctrl \= Disables Movement                                                          (used in hotkeys) |
| Mouse Wheel \= Zoom in Cinematic & Topdown, and move in Studio |

| Hotkeys |
| ----- |
| F \= Focus on selected Object |
| L \= Toggle Fullscreen |
| Delete / Backspace \= Delete Selection |
| Ctrl \+ Place \= Keep object in Hand |
| Ctrl \+ D \= Duplicate Selection |
| Ctrl \+ Z \= Undo last Action                                       (\!\!Does not work on Delete\!\!) |
| Ctrl \+ G \= Group Selection                            (Only Parts are able to be grouped) |
| Ctrl \+ L \= Toggle World space |
| 2 \= select Move |
| 3 \= select Scale |
| 4 \= select Rotate |
| Double Clicking Console \= Move Console to bottom |

# Commands

**Commands**  
MADE BY MAXIKXNG3  
\[ \] \= do not insert in final command  
|  \= Separates different command Arguments  
pX \= Position on the X axis  
pY \= Position on the Y axis  
pZ \= Position on the Z axis  
rX \= Rotation on the X axis  
rY \= Rotation on the Y axis  
rZ \= Rotation on the Z axis  
sX \= Size in the X direction  
sY \= Size in the Y direction  
sZ \= Size in the Z direction  
world \= Selected World slice to reference  
Commands in Red are currently Broken

[BRM5 Command Editor](https://triple-alt.github.io/brm5-command-editor/editor.html) made by @triple\_xx(m\_smi)

| Command: ban Function: Bans Named Player of off the Private Server Usage: ban \[player\] |
| :---- |
| **Command:** compounds **Function:** Enables/Disables the Preset Enemies on the Ronograd Map  **Usage:** compounds \[enable;disable\] |
| **Command:** create **Function:** Creates Parts **Usage:** create \[world\] \[part | wedge | corner | cylinder | ball\] \[pX\] \[pY\] \[pZ\] |
| **Command:** color **Function:** sets the Color of defined Object **Usage:** color \[world\] \[UID | %variableName\] \[r\] \[g\] \[b\] |
| **Command:** delete **Function:** Deletes Objects from the world **Usage:** delete \[world\] \[UID | %variableName\] |
| **Command:** duplicate **Function:** Duplicates an Object **Usage:** duplicate \[world\] \[UID | %variableName\] |
| **Command:** explosion **Function:** Creates an Explosion at the designated Coordinates **Usage:** explosion \[Radius\] \[Damage\] \[pX\] \[pY\] \[pZ\] \[None | Grenade | HelicopterVehicle | C4 | Igla | Breach | Flash | Mine | RPG7v2 | ObjBig | Motar | GroundVehicle\] |
| **Command:** file insertmodel **Function:** Spawns Saved Models into the world at designated Coordinates **Usage:** file insertmodel \[world\] \[name\] \[pX\] \[pY\] \[pZ\] \[r\] |
| **Command:** file savemodel;deletemodel **Function:** Saves or Deletes a selected Model from the custom Model list **Usage:** file \[savemodel | deletemodel\] \[name\] |
| **Command:** file list **Function:** Lists Saved Worlds **Usage:** file list |
| **Command:** file save;load;delete **Function:** Saves or Loads a named World file **Usage:** file \[save | load | delete\] \[name\] |
| **Command:** file savecopy;loadcopy **Function:** Saves or Loads a named World file when you are not the owner of the Private Server **Usage:** file \[Savecopy | loadcopy\] \[name\] |
| **Command:** firstperson **Function:** Locks all Players to First Person **Usage:** firstperson \[lock | unlock\] |
| **Command:** friendlyfire                                                                        friendly fire isn't **Function:** Turns PVP On/Off, Squad mode Enables PVP between Squads **Usage:** friendlyfire \[disable | squad | all\] |
| **Command:** hud **Function:** Forcefully Disables the HUD for all Players, normally done with F8 **Usage:** hud \[disable | enable\] |
| **Command:** kick **Function:** Kick Named Player of off the Private Server **Usage:** kick \[player\] |
| **Command:** move **Function:** Teleports a designated Object **Usage:** move \[world\] \[UID | %variableName\] \[pX\] \[pY\] \[pZ\] \[rX\] \[rY\] \[rZ\]  |
| **Command:** material **Function:** sets Material for an Object **Usage:** material \[world\] \[UID | %variableName\] \[material\] |
| **Command:** navmesh **Function:** Enable / Disable the Custom Navmesh, and Enable / Disable the Navmesh editor **Usage:** navmesh \[enable | disable | editor | confirm\] |
| **Command:** revive **Function:** Allows Players to be Revived, Enabled by default **Usage:** revive \[disable | enable\] |
| **Command:** respawn all;others **Function:** Respawns All Players, or All players except the one that executed the command **Usage:** respawn \[all | others\] |
| **Command:** respawn squad;player **Function:** Respawns all Players from a Squad, or specific Players **Usage:** respawn \[squad | player\] \[name\] |
| **Command:** serverlock **Function:** Blocks additional Players from Joining the Private Server **Usage:** serverlock \[enable | disable\] |
| **Command:** squadchanging **Function:** Prevents Players from Changing Squads **Usage:** squadchanging \[disable | enable\] |
| **Command:** squadspawn **Function:** Sets the Spawnpoint for Specific Squads **Usage:** squadspawn \[pX\] \[pY\] \[pZ\] \[r\] \[red | blue | orange | yellow | green | neutral\] |
| **Command:** size **Function:** sets the Size of an Object **Usage:** size \[world\] \[UID | %variableName\] \[sX\] \[sY\] \[sZ\] |
| **Command:** squad **Function:** Sets the Squad of a specific Player **Usage:** squad \[player\] \[none | red | blue | orange | yellow | green\] |
| **Command:** teleport **Function:** Teleports a Named Player **Usage:** teleport \[player | squad | all\] \[name\] \[pX\] \[pY\] \[pZ\] \[r\] |
| **Command:** time start;stop **Function:** Starts or Stops the Day, Night Cycle **Usage:** time \[start | stop\] |
| **Command:** time now **Function:** Prints the current Time to the console **Usage:** time now |
| **Command:** time set **Function:** Sets the Time to a specified Time **Usage:** time set \[time\] |
| **Command:** tween **Function:** moves and Object Smoothly around in a specified amount of Time **Usage:** tween \[world\] \[UID | %variableName\] \[Duration\] \[pX\] \[pY\] \[pZ\] \[rX\] \[rY\] \[rZ\]  |
| **Command:** transparency **Function:** sets the Transparency of a Specified Object **Usage:** transparency \[world\] \[UID | %variableName\] \[Transparency 0-1\] |
| **Command:** trigger **Function:** Explained in [Triggers]()  |
| **Command:** world **Function:** Deprecated Command used to Load Saves from Before RGE 2.0 **Usage:** world \[list;load\] \[File Name\] \[World\] |

# Triggers

**Triggers**  
MADE BY MAXIKXNG3

| Commands |
| ----- |
| **Command:** trigger add;remove **Function:** Adds / Removes a Trigger to an Object **Usage:** trigger \[add;remove\] \[world\] \[UID;%\[Name\]\] |
| **Command:** trigger addbutton;removebutton **Function:** Adds / Removes an Interaction to a Trigger Object **Usage:** trigger \[addbutton;removebutton\] \[world\] \[UID;%\[Name\]\] |
| **Command:** trigger set **Function:** Sets wich Triggergroup a Trigger Object Belongs to **Usage:** trigger set \[world\] \[UID;%\[Name\]\] \[Trigger Group\] \[True;False\] |
| **Command:** trigger activate;reset **Function:** Activate / Reset a Trigger Group **Usage:** trigger \[activate;reset\] \[world\] \[Trigger Group Name\] |
| **Command:** trigger create;delete **Function:** Creates / Deletes a Trigger Group **Usage:** trigger \[create;delete\] \[world\] \[Trigger Group Name\] |
| **Command:** trigger color **Function:** Sets the Color of a Trigger Group **Usage:** trigger color \[world\] \[Trigger Group Name\] \[0-255\]  \[0-255\]  \[0-255\] |
| **Command:** trigger whitelist **Function:** Sets which Entities can Interact with a Trigger Group **Usage:** trigger whitelist \[world\] \[Trigger Group Name\] \[Players;Bots;Helicopters;Ground\] \[true;false\] |
| **Command:** trigger whitelist IsLooping **Function:** Makes the trigger constantly repeat upon loading in **Usage:** trigger whitelist \[world\] \[Trigger Group Name\] IsLooping \[true;false\] |
| **Command:** trigger executable **Function:** [DO NOT USE](https://discord.com/channels/553917324340625424/1154567586948849735/1490605944390942810) |
| **Command:** wait **Function:** Pauses Line execution for Selected amount in Seconds **Usage:** wait \[Time to wait in Seconds\] |
| **Command:** reset **Function:** resets the Trigger, does not work on looping triggers, put in the last executable line **Usage:** reset |

# Tutorials

# Custom Armory

**Custom Armory**  
MADE BY MAXIKXNG3

Before we start, ensure you are

- In the world you want the Custom Armory to exist in.  
- Your character is inside the Loadout Screen

\#1 Enter RGE using the button “P”.

\#2 Select the Default View.

\#3 Create a new Camera.

\#4 you should be in the Loadout area with your Camera.

# Suggestions to Change Document

**Rules for Suggestions**

- Disclaimer: this Guide is NOT an Official Document by Platinum 5, please don't suggest additions to the Game/RGE here.  
- Please Add who made the Suggestion (Discord Name)  
- Keep Spacing between Suggestions  
- Add \-End- at the end of your suggestion, so i and others know it is Finished

**I will be a bit slow at adding new suggestions to main pages, I do hope this is understandable.**

## Hollowed Cylinder

(Circle with no filling) Guide, goldenimperiallancer on discord (credits go to mand0Bent0 and Edod, I slightly corrected and adjusted the formula)  
1\.  Create a part, size it down to a small rectangle, the vertical size (usually the Y value) should be the wanted diameter of the circle  
2\. Duplicate the part, bring it slightly forward and resize the vertical value (again, usually the Y axis) down to the wanted diameter of the outer circle (or worry about this later since you can do it at the very end)  
3\. Copy the diameter of the circle (vertical size of the part at the back), grab your calculator (or use the google one) and put in the formula: tan(rotational value \* pi/180) \* diameter (vertical size)/2  
INFO: Rotational value is the value under "snapping" in the "Home" tab. The smaller the value the smoother will the circle be, for smaller objects I recommend using 5 degrees (e.g. round graffitis, custom lettering), while as for biggers objects or objects which the player isnt supposed to reach 10-20 degrees (e.g. tunnels, objects in the background or in general to optimize the build)  
4\. Copy the result from the calculator and select the outer part (the smaller one at the front), now use the result and put it into the width value (always depending on the orientation of the part, to see which value is the width value, select the part, press 2 or the move tool and see which arrow points to the left and right, red: first value, x ; green: second value, y ; blue: third value, z)  
5\. Group both inner and outer part  
6\. Press 4 or select the rotation tool, duplicate the grouped object, rotate once on the same axis which you used for width, duplicate, and repeat until you have a circle  
7\. select all parts within the circle, ungroup, zoom in and then select only the outer (the parts on the back) and delete.  
8\. Now you can select the circle, resize it on all values EXCEPT the width (optional), group it or leave it ungrouped, recolor it or wtv^^

/\\  
I accidentally had a typo, at step 6 you dont select the previous width axis since it could be a different one now, you have to determine the width axis like in step 4\. Also I would love to provide pictures for each step\!\!

/\\ addition from Anarchist  
(there's a way to create a near-full cone using this method, if you rotate the part that creates the cylinder inward, it should work \- Anarchist)

# Saved Suggestions: ONLY edit suggestions here

**Saved Suggestions**  
 

- Only edit your own suggestions here  
- Before edits are approved you will be contacted on discord to confirm Edits

(Made by theanarchist4426 on Discord)  
Explosion Types:

Mine \= gives the explosion effect of the mine seen in Rono City and Fort  
Motar (it's really Mortar) \= gives the explosion effect of a mortar round impact  
Grenade \= gives the explosion effect of a grenade utility  
ObjBig \= gives the explosion effect of a bigger objective, like a radar or planted explosive  
GroundVehicle \= gives the explosion effect of a vehicle blowing up, like a  jeep or SRTV  
C4 \= gives the explosion effect of a C4  
HelicopterVehicle \= gives the explosion effect of a helicopter being shot down  
RPG7v2 \= gives the explosion effect of a fired RPG projectile  
Flash \= gives the explosion effect of a flashbang  
Breach \= gives the explosive effect of a breaching charge  
Igla \= unused effect  
None \= Provides no explosion effect or sound  
\-End-

