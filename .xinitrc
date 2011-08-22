#load Xresources
xrdb -merge .Xresources
urxvtd -q -o -f 
xscreensaver -no-splash &
#synergyc 192.168.0.3 &
sh .screenlayout/workdesk.sh
awesome
