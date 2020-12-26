# PeppyMeter4Volumio.doc
This repo keeps notes about changes needed to run PeppyMeter on Volumio.

Welcome community collaborations.

## Goals
### Immediate term
* Keep track of all changes needed to have PeppyMeter running on the HW described below.
* Make changes needed to my PeppyMeter fork.
* Create pull requests to the PeppyMeter root.
### Long term
TBD

## Hardware Description
* Raspberry Pi
* Raspberry Pi official 7" touch screen

## Volumio
* Burn and install Volumio, tested version: `volumio-2.853-2020-11-20-pi`
* Install and enable `Touch Display` plugin.
* Enable SSH by going to `volmio.local/dev`
* SSH to `volumio@volumio.local`, password is the same as the login.
* Install the packages needed: `apt-get install python3 python3-pygame kbd cron vim`
  * Note 1: `kbd` is the package for `openvt` that runs the PeppyMeter script.
  * Note 2: `vim` is optional.
  * Note 3: `cron` is the package for running PeppyMeter automatically after reboot
    (see "Run the meters" section below for details.)
## PeppyMeter
* Check out the source repos:
```buildoutcfg
git clone https://github.com/project-owner/peppyalsa
git clone https://github.com/ocean1598/PeppyMeter
git clone https://github.com/ocean1598/PeppyMeter4Volumio.doc
```
* Follow steps to install Peppy ALSA driver: https://github.com/project-owner/peppyalsa.doc/wiki
  
(Note all credits to the original PeppyMeter repo `https://github.com/project-owner/PeppyMeter`, 
and `https://github.com/project-owner/PeppyMeter.doc/wiki` has all the details.)

## Configuration Changes
### Volumio
Use the files in this repo:
* copy /etc/asound.conf
* update /etc/mpd.conf
* update /volumio/app/plugins/music_service/mpd/mpd.conf.tmpl
__Note The following configurations are for the headphone. Others need to change accordingly.__
### PeppyMeter
#### /home/volumio/PeppyMeter
#### Option 1: Manual changes
* config.txt
  * change `screen.size = large`
  * change `pipe.name = /tmp/myfifo`
  * chagne the SDL section as below
```
[sdl.env]
framebuffer.device = /dev/fb0
mouse.device = /dev/input/event0
mouse.driver = TSLIB
video.driver = directfb
video.display = :0
```
* peppymeter.py => remove DOUBLEBUF
  * `self.util.PYGAME_SCREEN = pygame.display.set_mode((screen_w, screen_h))`
#### Option 2: Patch method
* `cd ~/PeppyMeter`
* `patch -t  < ~/PeppyMeter4Volumio.doc/patch002.diff `
  (If you check out the upstream, use `patch001.diff` instead.)
### Reboot
Any method to reboot.
## Run the meters
### Set up automatic way
Once it's setup, the meter will automatically show up once the music starts playing by __mpd__.
* Check out this project ```git clone https://github.com/ocean1598/PeppyMeter4Volumio.doc```
* Copy the shell scripts to `/home/volumio/PeppyMeter`.
* ```sudo crontab -e``` to an entry that runs every minute: ```* * * * * /home/volumio/PeppyMeter/peppy_cron.sh```

  This script first simply checks if __mpd__ has created `/tmp/myfifo`, if not, exits.
  Then it checks if there is already a PeppyMeter instance running, if yes, exits.
  Then it'll start the PeppyMeter; meanwhile PeppyMeter has a signleton check to make sure there is only one instance running.

### Manual way
* After reboot, play some music.
* Double check if `/tmp/myfifo` exists, if not, create it: `mkfifo /tmp/myfifo` then reboot again.
* Go to `/home/volumio/PeppyMeter` folder
* `sudo openvt -s python3 peppymeter.py`

### Resume back to Volumio UI
The Volumio UI is on virtual terminal #2. The PeppyMeter UI is on #4, where #3 is used for PeppyMeter text output.
Hence one can flip the display among them by using `chvt` command.
There is no need to stop the PeppyMeter process.
The only caveat is that switching back to PeppyMeter UI doesn't show the full meter, just the moving needle.
It seems the background image got wiped out. Therefore, unless the meter redraws itself after something,
the only way to get the full meter back is when "random" is choosen and the next meter shows up.
* switch to Vulmio UI: `sudo chvt 2`
* switch to PeppyMeter UI: `sudo chvt 4`
* switch to PeppyMeter text output: `sudo chvt 3`

__NOTE `fconsole` can report which console is currently active on the LCD display__

## Tips
* kill the meter: `stop_peppy.sh` or `sudo kill -9 $(ps aux | grep peppymeter | grep root | awk '{ print $2 }')`
