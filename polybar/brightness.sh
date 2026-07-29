#!/bin/bash

#get
brightness=$(brightnessctl get)
max=$(brightnessctl max)
percent=$(( brightness * 100 / max ))

echo "$percent%"

#color
if [ $percent -le 20 ]; then
    echo "%{F#FF0000}$percent%%{F-}"
elif [ $percent -le 50 ]; then
    echo "%{F#FFFF00}$percent%%{F-}"
else
    echo "%{F#00FF00}$percent%%{F-}"
fi
