xwallpaper --zoom ~/Wallpaper/natureoffear.png
xrdb ~/.Xresources
slstatus &
picom &
dunst &
systemctl --user import-environment DISPLAY XAUTHORITY
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY
exec dwm
