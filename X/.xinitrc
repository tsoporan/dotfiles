# tsoporans xinitrc

xrdb -merge ~/.Xresources &

xscreensaver -no-splash &

redshift -O 3800K -P &

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

exec awesome
