# tsoporans xinitrc

# Other config
xrdb -merge ~/.Xresources &

# Screen
xscreensaver -no-splash &

# Color shift
redshift -O 3800K -P &

# Clipboard
clipit &

# Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# WM
exec awesome
