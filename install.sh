#!/bin/bash
# Run this script using sudo


# Move the files
cp -r /usr/* /usr/

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
