# Sinden Lightgun - Linux Utilities

- [License](License.md)
- BETA - this is currently in a BETA phase. It is unclear if the 32/64 bit binaries were properly included from the [original driver files](https://www.sindenlightgun.com/drivers/).
- The files contained within have been pulled from the latest Linux beta drivers page
- Until there is more automation in place, the files in this Git repository must be manually synced with any new release from that page.

Want to test them out and [let us know](https://github.com/SindenLightgun/SindenLightgunLinux/issues/1)?



## About

- [Version Info](Version.md)

PLEASE NOTE: This is a fork of the original repository, geared towards the Linux beta release! Please do not report issues with this setup to the Sinden developers unless you are very sure it's a core issue or bug!

## Report bugs

- [Create an issue](https://github.com/SindenLightgun/SindenLightgunLinux/issues).
- [Join the Discord](https://discord.com/invite/B67hgt4)

## Installation

```
cd ${HOME}
git clone https://github.com/mdeguzis/sinden-lightgun-linux
cd sinden-lightgun-linux
./setup-linux.sh
```

The software will be installed to `${HOME}/software/sinden`. 

### Manually test your lightgun

Run the following after installation for a quick manual test:
```
${HOME}/software/sinden/TestLightgun.sh
````

### Update

Update the files of your current version:

```
cd ${HOME}/SindenLightgunLinux
git pull
```

Re-run setup if there were Sinden utility changes. This should be able to be run anytime without negative affects.

```
./setup-linux.sh
```

### Change to a new version

If you are a new install, you will be on the default "mainline" branch of the repo, typically the most current. If you want to change the version of either a new install or an update to a newer version, you can grab all versions, list them, and change via:

```
cd ${HOME}/sidnen-lightgun-linux
git fetch; git branch
git branch checkout VERSION_NAME
```

## Configure / Setup

To configure your lightgun
```
./configure-lightgun.sh
```

## OS-specific guidance

### General

This section will serve as a "quick start" guide for a few use-cases. Please see https://www.sindenwiki.org/wiki/Sinden_Wiki for complete documentation. In a nuteshell, the experience requires:
* A working driver installation (Installation, stop, start, and/or plug and play automation)
* A working border overlay for your mode of play
   * Desktop / Steam Deck desktop mode: Gnome border extension (untested)
   * Steam Deck GameMode border via plugin (untested)
   * Borders enabled in your emulator or frontend of choice, such as Retroarch, MAME, or a frontend like Emulation Station.

### SteamOS / Steam Deck

#### Universal border box in Steam

You can install the [Decky Loader](https://github.com/SteamDeckHomebrew/decky-loader) plugin [Reshadeck](https://github.com/safijari/Reshadeck). Aafter you have done this, download and install [Border.fx](https://github.com/Otakumouse/stormshade/blob/master/v4.X/reshade-shaders/Shader%20Library/Recommended/Border.fx) with this extension. This is the Steam Deck version of [ReShade](https://reshade.me/). Copy the shader file to `${HOME}/.local/share/gamescope/reshade/shaders`. Other files are marked executable, but I'm not sure if that is required. Restart Steam or reload the plugin from Decky Loader.

More readining:
* https://www.sindenwiki.org/wiki/Reshade

### All other Linux systems
TODO

## Finish


## Emulator Setups

### MAME

Install full Mame, avoid using packages like RetroArch and Steam EmuDeck for now.  This guide assumes you know a bit

You need to do a few things, I haven't re-installed so I may have missed something but we need to do  this.  On the Mame screen where you select roms, go down to General Settings, we want to do a few things

1) Make sure Joystick input is supported
2) Remove weird joystick settings like deadzone (these make sense for joysticks but not our lightguns)
3) Disable joystick movement in the menu (this is very annoying otherwise)

1&2)
```
Advanced options->
Joystick = On
Joystick Deadzone = 0
Joystick Saturation = 1
Joystick Threshold = 0
```

3)
```
Input Assignments->
User Interface->
```

## Troubleshooting

### Logs

* Sevice logs (udev automatic star/stop) can be found at: `/tmp/sinden-lightgun.log`.
* User initiated actions can be found at: `/tmp/sinden-lightgun.user.log`.

### Gun test not working

- ssh into your device
- Plug the gun in
- check for the `LightgunMono.exe.lock` Lockfile `ls /tmp/Light*`
- Is the Lockfile there? Yes -- head to discord, lets figure this out
- Is the Lockfile there? No
    - StopAll Devices `${HOME}/$HOME/.local/bin/sindenlightgun-stopall.sh`
    - Manually start P1 `${HOME}/$HOME/.local/bin/sindenlightgun-p1-start.sh`
    - Check for the lockfile `ls /tmp/Light*`
    - Still not working? -- head to discord, lets figure this out

### Gun not working in an emulator/game

- head to discord, lets figure this out

### Auto Start/Stop not working, but gun works

With the gun plugged in run

```
cat /proc/bus/input/devices
```

This should output a list of devices, including 3 entries for Sinden Gun. One of the entries should be `Name="SindenCameraE` and have a line that identifies the vendor/product/version. Those values should be

```
I: Bus=0003 Vendor=32e4 Product=9210 Version=0100
```

If they are not, the ID for your gun is different, and why the auto detect may not be working

You will need to change the values in `/etc/udev/rules.d/99-sinden-lightgun.rules` to match your gun.

*TODO* if this is an actual bug, need to add a hook to NOT swap an updated file out.


