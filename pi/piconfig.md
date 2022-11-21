
## Hide task bar
```
right click task bar > Panel Settings > ADvance
- Minimise Panel when not in use => checked
- Size when minimized => 0
```

## Disable power management
```
xset s 0
xset -dpms
```

## Auto Start
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
```
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
@xscreensaver -no-splash
sudo /home/pi/startup.sh
```

Ref: https://forums.raspberrypi.com/viewtopic.php?t=294014

## Video Config
Copy the edid dat file into the /boot partition
```
cp ./edid.dat /boot 
```

```
sudo nano /boot/config.txt
```

And then paste in the following
```
hdmi_force_hotplug:0=1
hdmi_edid_file:0=1

hdmi_force_hotplug:1=1
hdmi_edid_file:1=1
```

