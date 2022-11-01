# Peux OS Clairvoyance

A version of sddm-clairvoyance theme with auto-background change implemented along with Full/Partial Blur. With every login-session, a new background image will be shown.

## Customisation:

There are a few options that you can edit in "theme.conf" - background, autoFocusPassword and enableHDPI.<br><br>
<b>background</b>: set this equal to the path of your background. 
<b>autoFocusPassword</b>: set this equal to 'true' (no quotes) to make the password input to automatically focus after you have chosen your user. To focus the password without using this option you can press the TAB key, or click in the area.<br><br>
<b>enableHDPI</b>: set this equal to 'true' (no quotes) to enable HDPI mode - this decreases some of the font-sized as they are automaticaly scaled up, messing up some of the layout. I can't test this myself on a HDPI screen, so if you have any issues, don't be afriad to open an issue.<br>

## Issues

This is not really an issue. The pictures' path is hardcoded. I could have dynamically called the images from a folder or url but simply is not my aim to do so as of now. 

If anyone wants, they can modify it as per their choice by forking or cloning this repo. You could also fetch XML data from Bing/Yahoo/Flicker and many other sites in your implementation or contribute to this by pulling a PR.

## Credits
Modified version of Eayu's clairvoyance for Peux OS
