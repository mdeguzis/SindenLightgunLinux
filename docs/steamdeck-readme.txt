This is the first version of the Steamdeck Sinden Lightgun driver, I took notes along the way but it is possible I missed something, so any problems with the raw notes or suggestions please feedback to:
contact@sindenlightgun.com with "Linux Beta" in the title.

In general this is not a guide for a complete beginner who doesn't know anything about Linux and/or Emulation.

This assumes you are running your Steamdeck on the latest OS, I bought my Steamdeck in March 2023.  It also assumes you are using the dock.  Always connect Sinden lightguns direct to the dock, but you can connect all other devices to an unpowered hub which is connected to the third USB port.

I believe you need SteamOS 3.0 - holo based on Arch Linux or newer.  It should be possible for it to work on the older SteamOS but it needs a way to install these components:
V4L2
Mono
sdl12-compat 
sdl_image 
sdl

Steamdeck boots into Steam.  Select "Steam Menu" in the bottom left like you are going to shut down the machine and choose Power, then the option to "Switch to desktop" mode.

I recommend using a TV/monitor and making it your primary screen.

Download this beta driver and extract the files.  I recommend using a PC and setting up FTP to the steamdeck as this helps with roms etc but you can do it on the machine also.

Firstly put the Lightgun folder in your home folder which is:
/home/deck/

So you can access the lightgun files in:
/home/deck/Lightgun

Then you need to install the software dependancies.  I haven't yet created a script because this is quite raw and needs more testing.  Also please note that you run these commands at your own risk, I don't know enough about Steamdeck and whether any of this could cause unexpected software issues (I don't expect it to).  Of course it can't break the hardware.

For new users of Linux please remember all these commands are case sensitive.

#Create a password and make a note of it (if you have already created a system password then you don't need this):
passwd

#Disable steamos readonly mode, so we can install stuff
sudo steamos-readonly disable

#install dependencies

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy mono
sudo pacman -Sy sdl12-compat sdl_image sdl

#these commands give you permissions to run the Sinden driver without the sudo prefix
usermod -a -G video deck

#Then try both of these, hopefully one should work
usermod -a -G serial deck
usermod -a -G uucp deck
usermod -a -G uucm deck
usermod -a -G dialout deck

#Put the steamos back into read only mode
sudo steamos-readonly enable

MAKE SURE YOUR SINDEN LIGHTGUNS ARE ON V1.9 FIRMWARE BY USING THE WINDOWS BETA 2.05 OR HIGHER AND UPDATING FIRMWARE.  WE NEED THE JOYSTICK FUNCTIONALITY.  ALSO ON THE FIRMWARE UPDATE TAB ENABLE THE JOYSTICK FUNCTIONALITY FOR EACH LIGHTGUN.

I'm not sure how well Steamdeck Linux does with absolute mouse coordinates devices, so for this first release I'm recommending you use joystick mode.  I think mouse should work but it hijacks the mouse cursor and seemed a bit messy, hopefully people can experiment and feed back.

Also I have only set this up with Mame to start with.  Other emulators may need something different.  The more experimenting I do the more documentation I need and it's important to get this first Steamdeck release out there.

If you now open the Konsole and run:
cd Lightgun
mono LightgunMono.exe steam joystick sdl

sdl tells it to open the calibration utility.  The joystick flag tells the lightgun to go into joystick mode and steam tells it to squash the screen so the whole utility fits onto the steam deck screen.

You should see a mouse cursor moving on screen if you have 1 lightgun, or 2 crosshairs if you have 2 lightguns.

You can hold dpad left down for 5 seconds, when the cursor moves to he centre, if you shoot it, then your lightgun should be calibrated.

If the cursor is all over the place, you may need to change some lightgun camera settings, please see the old linux documentation for how to do this.  Usually just reducing background light should sort it too.

The lightgun may be a tiny bit jittery on this screen but don't worry will be fine in game.  Move the cursor(s) to the bottom right to exit.

You can now set the driver to run in the background:
mono-service LightgunMono.exe joystick

Use or don't use the joystick toggle to enable/disable joystick mode.

OK lets use Mame to test.  Install full Mame, avoid using packages like RetroArch and Steam EmuDeck for now.  This guide assumes you know a bit about Mame, in future guides will be more beginner friendly.

You need to do a few things, I haven't re-installed so I may have missed something but we need to do  this.  On the Mame screen where you select roms, go down to General Settings, we want to do 3 things:
1) Make sure Joystick input is supported
2) Remove weird joystick settings like deadzone (these make sense for joysticks but not our lightguns)
3) Disable joystick movement in the menu (this is very annoying otherwise)

4) Also we need to setup borders for the lightgun using Mame overlays but this down with moving files.

1&2) 
Advanced options->
Joystick = On 
Joystick Deadzone = 0
Joystick Saturation = 1
Joystick Threshold = 0

3)
Input Assignments->
User Interface->
I'm not 100% sure which values I changed but I think it was UI UP/DOWN/LEFT/RIGHT.  I removed the joystick input.

4) Copy the Overlays folder from the Lightgun directory into your Mame directory, I installed Mame to /home/deck/Emualtion/Mame

That folder was empty and I added the overlays.

There are 3 there for some common games, for another rom you just need to copy the folder and rename it to match the rom name and then change the .lay file name inside to match the rom name.

The Sinden wiki does have links to great packs of border art which you can download and use, this is just about getting you up and running.  The example border I included is quite thin, depending on your setup you may need a thicker border.

I recommend Terminator2 - Judgement Day as your first game.  

When you load the game, you should see a Sinden border round the outside, this is required.  You may need to tab and go into Video Options to select the option with the border.  Turn bezels on and select OriginalAspectRatio.

This guide assumes standard Mame knowledge but inside the game, you need to hit tab:
Input Settings
Input Assignments (this system)
Set P1 Trigger to trigger
P1 Bomb to the pump action
Set "AD Stick X Analog" to moving the lightgun across the screen.  It should say "Joy2 A1" or similar.
Set "AD Stick Y Analog" to moving the lightgun up/down the screen.  It should also say the same.
Set Player1 Start to a side button.
Set Coin 1 to another Start button.

Now press escape to go back into the game and add some coins, select start and it should work.  You probably need to go through the calibration process for the arcade rom when it launches.  It insists on a Player 2, so if you only have 1 lightgun, use the assigned keyboard keys to action player2 in the calibration.

Finally in the Lightgun folder there are some scripts in the "StartupScripts" folder, you can copy these onto the steam deck desktop and double click to run:
Start
Stop
Calibrate

Please remember that after you run Calibrate it will then stop the lightguns and you have to run Start to run the lightguns in the background.

When you first start I recommend using the Konsole and manually typing to ensure you can see what is going on.












