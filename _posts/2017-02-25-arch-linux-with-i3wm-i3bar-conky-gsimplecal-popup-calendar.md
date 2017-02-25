---
layout: post
title: Arch Linux with i3-wm i3bar Conky and gsimplecal Pop-Up 
---
# Resources #
<https://>

conkexec.sh
```
#!/bin/bash

$*
killall -sUSR1 conky
```

config
```
# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
	output LVDS
	status_command $HOME/.config/i3/conky_wrapperupd
        tray_output LVDS
 # i3bar colours
        colors {
        background #3a1d00
        statusline #ffffff

        # class             border      background  text
        focused_workspace   #eabb8b     #aa8967     #ffffff
        active_workspace    #333333     #5f676a     #ffffff
        inactive_workspace  #926d49     #6d4924     #c4c4c4
        urgent_workspace    #e09248     #d66b00     #ffffff
	}
}
```

conky_wrapperupd
```
#!/usr/bin/env bash

#+++++++++++++++++++++++++++++++++++#
#           Requirements            #
#+++++++++++++++++++++++++++++++++++#
#                                   #
# jshon: parsing json               #
# gsimplecal: calendar              #
#                                   #
#+++++++++++++++++++++++++++++++++++#

# Send version header to i3bar to indicate that we want to use JSON.
# Also enable click events
echo '{"version":1, "click_events": true }'

# Begin the endless array
echo '['

# Send an empty first array of blocks to make the loop simpler
echo '[],'

# only allow one instance of conky
if [[ -z $(pgrep conky) ]]; then

    exec conky -c ~/.config/i3/conky_i3upd &

else

    killall conky
    exec conky -c ~/.config/i3/conky_i3upd &

fi

name="date"

while read -r line; do

    [[ $line = "[" ]] && continue

    line=$(echo "$line" | sed "s/^,//")
    getname=$(echo "$line" | jshon -e name -u)

    [[ $getname = "$name" ]] && gsimplecal &

done
```

conky_i3upd
```
-- everything after this is displayed on screen
-- json for i3bar
-- cmus output
--{"full_text":"${if_running cmus}"},\
--{"full_text":"${scroll 60 5 ${execi 10 cat /tmp/cmus.conky}}","color":"\#b6b6ff"},\
--{"full_text":"${endif}"},\
-- cpu
-- cpu temperature
--{"full_text":"[${hwmon temp 1}°C ]","color":${if_match ${hwmon temp 1}>64}"\#ff0000"${else}"\#49db49"${endif},"separator":false,"separator_block_width":2},\
-- memory
-- alsa master volume
--{"full_text":"[ ♪ ${mixer}% ]","color":"\#dbb6db"},\
-- date
-- vim: ft=conkyrc
-- {"full_text":"[  ${exec /home/nonasuomy/.config/i3/pacvol.sh display}]","color":"\#6AFFD8"},\
conky.config = {
out_to_x=false,
own_window=false,
out_to_console=true,
background=false,
update_interval=2,
total_run_times=0,
use_spacer='left',
use_xft=true,
font='Droid Sans Mono:size=10'

}

--template1 ${if_match "${battery_short \1}"=="U"} ${battery_short \1} ${battery_percent \1}% $else ${battery_short \1} $endif
--template0 {"full_text": " \1 ${template1 BAT0}/${template1 BAT1}","color":\2}


conky.text = [[
[\
{"full_text":"[    ${addr enp3s0}]","color":"\#ffb692"},\
{"full_text":"[  ${wireless_essid wlp5s0}   ${wireless_bitrate wlp5s0}  ${wireless_link_qual_perc wlp5s0}%  ${addr wlp5s0}]","color":"\#ffb692"},\
{"full_text":"[   ${cpu cpu0}% ]","color":${if_match ${cpu}>70}"\#ff0000"${else}"\#82c2ff"${endif},"separator":false,"separator_block_width":2},\
{"full_text":"[ ⊟ ${memperc}% ]","color":${if_match ${memperc}>70}"\#ff0000"${else}"\#dbdb00"${endif},"separator":false,"separator_block_width":2},\
{"full_text":"[  ${fs_free}]","color":"\#ffb692"},\
{"full_text":"[  ${battery_bar 5,10 BAT0} ${battery_percent BAT0}% ${battery_time BAT0}]","color":"\#ffb692"},\
# ${if_existing /sys/class/power_supply/AC/online 0}
#    ${if_match ${battery_percent BAT0} <= 20}
#      ${if_match ${battery_percent BAT1} <= 20}
#        ${template0 🔋 "\\#FF0000"},
#        ${execi 120 notify-send -t 2000 -i "/usr/share/icons/Numix/status/48/battery-low.svg" "Battery Low"}
#      $else
#        ${template0 🔋 "\\#94F397"},
#      $endif
#    $else
#      ${template0 🔋 "\\#94F397"},
#    $endif
#  $else
#    ${template0 🔌 "\\#94F397"},
#  $endif
{"full_text":"[${exec /home/nonasuomy/.config/i3/pacvol.sh display} ]","color":"\#dbb6db", "name":"volume"},\
{"name":"date","full_text":" ${time %Y-%b(%m)-%a(%d) %l:%M:%S%p}","color":"\#ffb692"},\
{"full_text": " ${execi 1800 /home/nonasuomy/.config/i3/
} ", "name":"updates"}\
],
]]
```

## Extras

pacvol.sh
```
#!/bin/sh
# PulseAudio Volume Control Script
#   2010-05-20 - Gary Hetzel <garyhetzel@gmail.com>
#
#   BUG:    Currently doesn't get information for the specified sink,
#           but rather just uses the first sink it finds in list-sinks
#           Need to fix this for systems with multiple sinks
#

SINK=0
STEP=1
MAXVOL=65537 # let's just assume this is the same all over
MUTED=0
#MAXVOL=`pacmd list-sinks | grep "volume steps" | cut -d: -f2 | tr -d "[:space:]"`

MUTED=`pacmd list-sinks 0 | grep muted | cut -d ' ' -f 2`
#VOLPERC=`pactl list sinks | awk '/Volume: 0:/ {print substr($3, 1, index($3, "%") - 1)}' | head -n1`
#VOLPERC=`pactl list sinks 1 | awk '/Volume: front-left:/ {print substr($5, 1, index($5, "%") - 1)}'`
VOLPERC=`pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 2 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'`
SKIPOVERCHECK=1

display(){
  if [ "$MUTED" = "yes" ]; then
    echo "   muted"
  elif [ "$VOLPERC" -lt 33 ]; then
    echo "  ${VOLPERC}%"
  elif [ "$VOLPERC" -lt 66 ]; then
    echo "  ${VOLPERC}%"
  else
    echo "  ${VOLPERC}%"
  fi
}

up(){
	VOLSTEP="$(( $VOLPERC+$STEP ))";
}

down(){
	VOLSTEP="$(( $VOLPERC-$STEP ))";
	SKIPOVERCHECK=1
}

max(){
	pacmd set-sink-volume $SINK $MAXVOL > /dev/null
}

min(){
	pacmd set-sink-volume $SINK 0 > /dev/null
}

overmax(){
	SKIPOVERCHECK=1
	if [ $VOLPERC -lt 100 ]; then
		max;
		exit 0;
	fi
	up
}

mute(){
	pacmd set-sink-mute $SINK 1 > /dev/null
}

unmute(){
	pacmd set-sink-mute $SINK 0 > /dev/null
}

toggle(){
	M=`pacmd list-sinks | grep "muted" | cut -d: -f2 | tr -d "[:space:]"`
	if [ $M == "no" ]; then
		mute;
	else
		unmute;
	fi
}

case $1 in
up)
	up;;
down)
	down;;
max)
	max
	exit 0;;
min)
	min
	exit 0;;
overmax)
	overmax;;
toggle)
	toggle
	exit 0;;
mute)
	mute;
	exit 0;;
unmute)
	unmute;
	exit 0;;
display)
	display;
	exit 0;;
*)
	echo "Usage: `basename $0` [up|down|min|max|overmax|toggle|mute|unmute|display]"
	exit 1;;
esac

VOLUME="$(( ($MAXVOL/100) * $VOLSTEP ))"

echo "$VOLUME : $OVERMAX"

 if [ -z $SKIPOVERCHECK ]; then
 	if [ $VOLUME -gt $MAXVOL ]; then
 		VOLUME=$MAXVOL
 	elif [ $VOLUME -lt 0 ]; then
 		VOLUME=0
 	fi
 fi

#echo "$VOLUME: $MAXVOL/100 * $VOLPERC+$VOLSTEP"
pacmd set-sink-volume $SINK $VOLUME > /dev/null
# VOLPERC=`pacmd list-sinks | grep "volume" | head -n1 | cut -d: -f3 | cut -d% -f1 | tr -d "[:space:]"`

#osd_cat -b percentage -P $VOLPERC --delay=1 --align=center --pos bottom --offset 50 --color=green&
```

update_count.sh
```
#!/bin/bash

HELD=0 # set how many packages we're holding
PML=$(pacman -Sup | wc -l)
touch /tmp/udc
UC=$(( $PML - $HELD - 1))

echo -n $UC

if (( UC > 0 ))
then
		echo " \",\"color\": \"#FFFE6A"
else
		echo " \",\"color\": \"#909090"
fi
```

**Note:** *note here*

## Other Research ##
<https://>
<https://>


# Arch Linux Install 
## Troubleshooting ##