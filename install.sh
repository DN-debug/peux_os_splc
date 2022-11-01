#!/bin/bash
# Run this script using sudo

# Install latte dock
pacman -S latte-dock

# Move the files
cp -r .config/* ~/.config/
cp -r usr/share/* /usr/share/
cp -r usr/sbin/uniform_cursor /usr/sbin/
cp -r usr/local/bin/layoutChanger /usr/local/bin/

# Make the scripts executable
chmod +x /usr/local/bin/layoutChanger
chmod +x /usr/share/layouts/build/gui.py
chmod +x /usr/share/layouts/deepin
chmod +x /usr/share/layouts/default
chmod +x /usr/share/layouts/pmodern
chmod +x /usr/share/layouts/win11
chmod +x /usr/share/layouts/chrome
chmod +x /usr/share/layouts/unity
chmod +x /usr/sbin/uniform_cursor

echo "Done!"
