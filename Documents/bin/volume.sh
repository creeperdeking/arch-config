#!/bin/sh

pactl get-sink-volume $(pactl get-default-sink) | head -n 1 | cut -d'/' -f 2 | cut -d'%' -f 1 | xargs
