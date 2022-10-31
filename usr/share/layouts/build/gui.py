#!/usr/bin/env python

################################################################
#                                                              #
# Author: DN-debug                                             #
# Description: Layout Changer for Peux OS KDE version          #
# License: GPLv3                                               #
#                                                              #
################################################################

from pathlib import Path

# from tkinter import *
# Explicit imports to satisfy Flake8
from tkinter import Tk, Canvas, Entry, Text, Button, PhotoImage
import subprocess
from subprocess import check_call


OUTPUT_PATH = Path(__file__).parent
ASSETS_PATH = OUTPUT_PATH / Path("./assets")


def relative_to_assets(path: str) -> Path:
    return ASSETS_PATH / Path(path)


def defL():
   subprocess.call(['/usr/share/layouts/default'])

def depL():
   subprocess.call(['/usr/share/layouts/deepin'])

def floL():
   subprocess.call(['/usr/share/layouts/pmodern'])

def chromeL():
   subprocess.call(["bash", '/usr/share/layouts/chrome'])

def uniL():
   subprocess.call(['/usr/share/layouts/unity'])


def winL():
   subprocess.call(['/usr/share/layouts/win11'])


window = Tk()
window.title('Layout Changer [Experimental]')
window.geometry("687x350")
window.configure(bg = "#1F1F1F")


canvas = Canvas(
    window,
    bg = "#1F1F1F",
    height = 350,
    width = 687,
    bd = 0,
    highlightthickness = 0,
    relief = "ridge"
)

canvas.place(x = 0, y = 0)

canvas.create_text(
    247.0,
    16.0,
    anchor="nw",
    text="Layout Changer",
    fill="#FFFFFF",
    font=("Quicksand Regular", 24 * -1)
)

canvas.create_text(
    87.0,
    195.0,
    anchor="nw",
    text="Chrome",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

canvas.create_text(
    317.0,
    192.0,
    anchor="nw",
    text="Default",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

canvas.create_text(
    90.0,
    331.0,
    anchor="nw",
    text="Deepin",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

canvas.create_text(
    324.0,
    331.0,
    anchor="nw",
    text="Float",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

canvas.create_text(
    554.0,
    192.0,
    anchor="nw",
    text="Unity",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

canvas.create_text(
    552.0,
    331.0,
    anchor="nw",
    text="Win11",
    fill="#FFFFFF",
    font=("Questrial Regular", 14 * -1)
)

button_image_1 = PhotoImage(
    file=relative_to_assets("button_1.png"))
button_1 = Button(
    image=button_image_1,
    borderwidth=0,
    highlightthickness=0,
    command=chromeL,
    relief="flat"
)
button_1.place(
    x=18.0,
    y=75.0,
    width=189.0,
    height=113.0
)

button_image_2 = PhotoImage(
    file=relative_to_assets("button_2.png"))
button_2 = Button(
    image=button_image_2,
    borderwidth=0,
    highlightthickness=0,
    command=defL,
    relief="flat"
)
button_2.place(
    x=247.0,
    y=74.0,
    width=189.0,
    height=113.0
)

button_image_3 = PhotoImage(
    file=relative_to_assets("button_3.png"))
button_3 = Button(
    image=button_image_3,
    borderwidth=0,
    highlightthickness=0,
    command=uniL,
    relief="flat"
)
button_3.place(
    x=477.0,
    y=74.0,
    width=189.0,
    height=113.0
)

button_image_4 = PhotoImage(
    file=relative_to_assets("button_4.png"))
button_4 = Button(
    image=button_image_4,
    borderwidth=0,
    highlightthickness=0,
    command=winL,
    relief="flat"
)
button_4.place(
    x=477.0,
    y=218.0,
    width=189.0,
    height=113.0
)

button_image_5 = PhotoImage(
    file=relative_to_assets("button_5.png"))
button_5 = Button(
    image=button_image_5,
    borderwidth=0,
    highlightthickness=0,
    command=floL,
    relief="flat"
)
button_5.place(
    x=247.0,
    y=218.0,
    width=189.0,
    height=113.0
)

button_image_6 = PhotoImage(
    file=relative_to_assets("button_6.png"))
button_6 = Button(
    image=button_image_6,
    borderwidth=0,
    highlightthickness=0,
    command=depL,
    relief="flat"
)
button_6.place(
    x=18.0,
    y=217.0,
    width=189.0,
    height=113.0
)


#Setting the size of the window
#window.geometry('600x480')
window.resizable(width=0, height=0)

window_height = 350
window_width = 687

screen_width = window.winfo_screenwidth()
screen_height = window.winfo_screenheight()

x_cordinate = int((screen_width/2) - (window_width/2))
y_cordinate = int((screen_height/2) - (window_height/2))

window.geometry("{}x{}+{}+{}".format(window_width, window_height, x_cordinate, y_cordinate))

window.resizable(False, False)
window.mainloop()
