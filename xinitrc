# tsoporans xinitrc

xrdb -merge ~/.Xresources &

xscreensaver -no-splash &

redshift -O 4200K -P &

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

exec i3
