#!/bin/sh

echo $(bc -l <<< "$(brightnessctl g)/ $(brightnessctl m)*100") | awk '{printf "%2d", $1+0.5;}'
