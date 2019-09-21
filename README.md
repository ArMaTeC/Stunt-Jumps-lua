# Stunt-Jumps-lua
Stunt Jumps FiveM (In lua)
All stock stunt jumps from GTA V in FiveM. 

This resource adds all GTAV stunt jumps into your server.
This is a clone of Vespura(TomGrobbe) resource recoded into lua

# Install
Download the latest.
Download into a new folder in your resources folder, you can call it whatever you like.
Add start <name> to the server.cfg, making sure to replace <name> with the name you gave the new folder you just made.
  
If you want to enable blips for all the stunt jumps, edit client.lua and change jumpsSetupBlips to true and jumpsSetupShowNearBlips to false

If you want to enable blips for only the nearest stunt jumps, edit client.lua and change jumpsSetupBlips to true and jumpsSetupShowNearBlips to true

# Example and original work
https://forum.fivem.net/t/stunt-jumps-all-default-stunt-jumps-from-gta-v-now-in-fivem/310208

# Developer notes
There is a limit of 64 stunt jumps set by the game TomGrobbe created a list of 50 so there is 14 margin

Would love some help with how to detect when a player compleates or fails a jump with and id of some sort so i can create the database side to store the jumps

# Changelog
v1.0.0
Initial release.


FiveM post
https://forum.fivem.net/t/stunt-jumps-lua/801339?u=cityliferpg
