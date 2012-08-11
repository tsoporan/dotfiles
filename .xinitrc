#load Xresources
xrdb -merge .Xresources &
urxvtd -q -o -f
xscreensaver -no-splash &
#synergyc 192.168.0.3 &
#sh .screenlayout/workdesk.sh
redshift -l 28:-81 &
awesome
