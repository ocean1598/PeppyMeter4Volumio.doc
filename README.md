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
* Raspberry Pi official 7" touch screen, 1024x600

## Software
* volumio-2.853-2020-11-20-pi
* https://github.com/ocean1598/PeppyMeter (fork of https://github.com/project-owner/PeppyMeter)
* https://github.com/project-owner/peppyalsa

## Install packages
### PeppyMeter
* peppyalsa ==> follow the steps: https://github.com/project-owner/peppyalsa.doc/wiki
* PeppyMeter ==> follow the steps: https://github.com/project-owner/PeppyMeter.doc/wiki
### Volumio
* openvt ==> `apt-get install kbd`

## Configuration Changes
### Volumio
Note: The following configurations are for the headphone. Others need to change accordingly.
* /etc/asound.conf
* /etc/mpd.conf
* /volumio/app/plugins/music_service/mpd/mpd.conf.tmpl
* /home/volumio/.asoundrc ==> identical as /etc/asound.conf
### PeppyMeter
#### /home/volumio/PeppyMeter
* config.txt
  * change `screen.size = large`
  * change `pipe.name = /tmp/myfifo`
* configfileparser.py (___FORNOW___)
 * change 
   * `LARGE_WIDTH = 1024`
   * `LARGE_HEIGHT = 600`
* peppymeter.py: make the following changes in init_display()
```buildoutcfg
        os.environ["SDL_FBDEV"] = "/dev/fb0"
        os.environ["SDL_MOUSEDEV"] = "/dev/input/event0"

        if "win" not in sys.platform:
            os.environ["SDL_VIDEODRIVER"] = "directfb"
            os.environ["DISPLAY"] = ":0"
            pygame.display.init()
```
### Create pipe
* mkfifo /tmp/myfifo
* chmod 755 /tmp/myfifo

__NOTE, after reboot the permissions changes back to read-only, hence repeat `chmod` is required.__
## Run PeppyMeter /home/volumio/PeppyMeter
* `sudo openvt -s python3 peppymeter.py`
## Resume back to Volumio UI
* kill the peppymeter.py
* `sudo chvt 2`

__NOTE `fconsole` can report which console is currently active on the LCD display__
