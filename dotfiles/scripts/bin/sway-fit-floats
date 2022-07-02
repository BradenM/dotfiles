#!/usr/bin/env bash
# https://gitlab.com/wef/dotfiles/-/blob/master/bin/sway-fit-floats

TIME_STAMP="20211102.175139"

# Copyright (C) 2020-2021 Bob Hepple <bob dot hepple at gmail dot com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

initialise() {
    PROG=$(basename $0)
    VERSION="$TIME_STAMP"
    ARGUMENTS=""
    USAGE="arrange floating windows in swaywm between visible and scratchpad
NB untested in multiple monitor setups. Suggested keys:

# fits all visible floaters:
bindsym    $mod+backslash   exec sway-fit-floats               --x-origin=20 --y-origin=20 --padx=20 --pady=20 -v
# if no floaters, bring them from scratchpad; else send to scratchpad:
bindsym $mod+$c+backslash   exec sway-fit-floats --toggle      --x-origin=20 --y-origin=20 --padx=20 --pady=20 -v
# send visible floating windows to scratchpad:
bindsym $mod+$s+backslash   exec sway-fit-floats -S --no-focus --x-origin=20 --y-origin=20 --padx=20 --pady=20 -v
# unfloat all visible windows:
bindsym $mod+$c+$s+backslash   exec sway-fit-floats --unfloat

"

    NEW_ARGS=( )

    ARGS="
ARGP_DELETE=quiet
ARGP_VERSION=$VERSION
ARGP_PROG=$PROG
##############################################################   
#OPTIONS:
#name=default sname arg       type range   description
##############################################################   
ALL=''        a     ''        b    ''      fit all windows (not just visible - includes scratchpad)
PADX='0'      ''    padx      i    '0-'    pad windows right
PADY='0'      ''    pady      i    '0-'    pad windows below
X_ORIGIN='0'  ''    xorg      i    '0-'    offset in x
Y_ORIGIN='0'  ''    yorg      i    '0-'    offset in y
SHELF=''      s     ''        b    ''      use simple shelf tiling
SCRATCHPAD='' S     ''        b    ''      send visible (or --all) floating windows to scratchpad
NO_FOCUS=''   f     ''        b    ''      with -S don't send a focused window to scratchpad
TOGGLE=''     t     ''        b    ''      if no floaters, bring them from scratchpad; else send to scratchpad
UNFLOAT=''    u     ''        b    ''      change floating windows to normal windows
##############################################################   
ARGP_ARGS=[--] $ARGUMENTS
ARGP_SHORT=$SHORT_DESC
ARGP_USAGE=$USAGE"

    exec 4>&1
    eval "$(echo "$ARGS" | argp.sh "$@" 3>&1 1>&4 || echo exit $? )"
    exec 4>&-

    NEW_ARGS=( "$@" )

    return 0
}

# assume we're filling from top left, windows appear in height order
add_node() {
    x=$(( $1 ))
    y=$(( $2  ))
    for ((i=0; i<num_nodes; i++)); do
        # make sure it's unique:
        if (( x == node_x[i] )) && (( y == node_y[i] )); then
            # corner case of covering up an existing node
            node_x[i]=-1
            return
        fi
    done

    if (( x < workspace_width )) && (( y < workspace_height )); then
        node_x[i]=$x
        node_y[i]=$y
        num_nodes=$(( num_nodes + 1 ))
    fi
}

place_window() {
    local index=$1 i
    [[ "$VERBOSE" ]] && echo "$PROG: trying to place window[$index] id ${win_id[index]} w=${win_width[index]} h=${win_height[index]} on $num_nodes nodes" >&2
    for ((i=0; i<num_nodes; i++)); do
        if (( node_x[i] == -1 )); then
            continue
        fi
        
        if ((  win_width[index]  + node_x[i] < workspace_width  )) && 
            (( win_height[index] + node_y[i] < workspace_height )); then

            [[ "$VERBOSE" ]] && echo "$PROG: success! placed window[$index] on node[$i]" >&2

            # Success!
            win_x[index]=${node_x[i]}
            win_y[index]=${node_y[i]}
            node_x[i]=-1 # used
            # order is important here - top right, bottom left, bottom right
            add_node $(( win_x[index] + win_width[index] + PADX )) ${win_y[index]}
            add_node ${win_x[index]} $(( win_y[index] + win_height[index] + PADY ))
            add_node $(( win_x[index] + win_width[index] + PADX )) $(( win_y[index] + win_height[index] + PADY ))
            win_placed[index]="true"
            return 0
        fi
    done

    # this one fits nowhere - start again
    return 1
}

fill_windows() {
    # slurp all windows into arrays:
    local index=0 id width height
    
    while read id width height _; do
        if (( width + PADX > workspace_width - X_ORIGIN )) || (( height + PADY > workspace_height - Y_ORIGIN )); then
            echo "$PROG: ignoring window $id as it's too large to ever fit" >&2
            continue
        fi
        [[ "$VERBOSE" ]] && echo "$PROG: got window $id $width $height" >&2
        win_id[index]=$id
        win_width[index]=$width
        win_height[index]=$height
        win_placed[index]=""
        index=$(( index + 1 ))
    done
    num_windows=$index

    [[ "$VERBOSE" ]] && echo "$PROG: got $num_windows windows" >&2

    # Loop over all the rectangles, fitting them in somewhere
    local finished="false"
    local safety=0
    while [[ $finished == "false" ]] && (( safety < 50 )); do
        node_x[0]=$X_ORIGIN # '-1' means a used node
        node_y[0]=$Y_ORIGIN
        num_nodes=1
        safety=$(( safety + 1 ))

        for (( index=0; index<$num_windows; index++ )); do
            if [[ ${win_placed[index]} != "true" ]]; then
                place_window $index
            fi
        done
        
        finished="true"
        for ((index=0; index<$num_windows; index++)); do
            if [[ ${win_placed[index]} != "true" ]]; then
                finished="false"
                [[ "$VERBOSE" ]] && echo "$PROG: starting again at origin" >&2
                break
            fi
        done
    done
    
    # output results
    for ((index=0; index<$num_windows; index++)); do
        if [[ ${win_placed[index]} == "true" ]]; then
            echo "${win_id[index]} ${win_x[index]} ${win_y[index]}"
        fi
    done
}

simple_shelf_pack() {
    xPos=$X_ORIGIN
    yPos=$Y_ORIGIN
    largestHThisRow=$Y_ORIGIN
    
    # slurp all rectangle into arrays:
    index=0
    while read id width height _; do
        if (( width + PADX > workspace_width - X_ORIGIN )) || (( height + PADY > workspace_height - Y_ORIGIN )); then
            echo "$PROG: ignoring window $id as it's too large to ever fit" >&2
            continue
        fi
        [[ "$VERBOSE" ]] && echo "$PROG: got window $id $width $height" >&2
        win_id[index]=$id
        win_width[index]=$width
        win_height[index]=$height
        win_placed[index]=""
        index=$(( index + 1 ))
    done
    num_windows=$index
    
    # Loop over all the rectangles, fitting them in somewhere
    for ((index=0; index<$num_windows; index++)); do
        # If this rectangle will go past the width of the image
        # Then loop around to next row, using the largest height from the previous row
        if (( (xPos + win_width[index]) + PADX > workspace_width - X_ORIGIN )); then
            yPos=$(( ypos + largestHThisRow +PADY ))
            xPos=$X_ORIGIN
            largestHThisRow=$Y_ORIGIN
        fi

        # If we go off the bottom edge of the image, then start again
        if (( (yPos + win_height[index]) > workspace_height )); then
            xPos=$X_ORIGIN
            yPos=$Y_ORIGIN
        fi

        # This is the position of the rectangle
        win_x[index]=$xPos
        win_y[index]=$yPos

        # Move along to the next spot in the row
        xPos=$(( xPos + win_width[index] + PADX ))
        
        # Just saving the largest height in the new row
        if (( win_height[index] + PADY > largestHThisRow )); then
            largestHThisRow=$(( win_height[index] + PADY ))
        fi
        
        # Success!
        win_placed[index]="true"
    done

    for ((index=0; index < $num_windows; index++)); do
        if ( ${win_placed[index]} == "true" ); then
            echo "${win_id[index]} ${win_x[index]} ${win_y[index]}"
        fi
    done
}

initialise "$@" && set -- "${NEW_ARGS[@]:-}"

TREE=$( swaymsg -t get_tree )
focused=$( echo "$TREE" | jq '..| select(.type?) | select(.focused==true) | .id' )

# find smallest "workspace" height
workspace_height=$(
    min=0
    echo "$TREE" | jq '..| select(.type?)|select(.type=="workspace")|.rect.height' | (
        while read h; do
            if (( min == 0 )) || (( h < min )); then
                min=$h
            fi
        done
        echo $min
    )
)

# any "workspace" width should do:
workspace_width=$(
    val=0
    echo "$TREE" | jq '..| select(.type?)|select(.type=="workspace")|.rect.width' |
    while read w; do
        echo $w
        break
    done
)

[[ "$VERBOSE" ]] && echo "$PROG: workspace is ${workspace_width}x${workspace_height}" >&2

Q1='.. | select(.type?) | select(.type=="floating_con")'
Q2=' | select(.visible==true)'
Q3=' | .id, " ", .rect.width, " ", .rect.height + .deco_rect.height, "\n"'

QUERY="$Q1"
[[ "$ALL" ]] || QUERY+="$Q2" # select only visible windows
QUERY+="$Q3"

if [[ "$UNFLOAT" ]]; then
    echo "$TREE" | jq -j "$QUERY" | while read id rest; do
        swaymsg "[con_id=$id] focus; floating disable; border pixel 1"
    done
    exit 0
fi

if [[ "$TOGGLE" ]]; then

    # count number of visible floating windows
    num_floaters=0
    while read id _; do
        num_floaters=$(( num_floaters + 1 ))
    done < <( echo "$TREE" | jq -j "$Q1$Q2$Q3" )

    if (( num_floaters > 0 )); then
        SCRATCHPAD="true"
    else
        unset SCRATCHPAD
        QUERY="$Q1$Q3" # move all windows to current w/s including scratchpad
    fi
fi

if [[ "$SCRATCHPAD" ]]; then
    # send windows to scratchpad
    echo "$TREE" |
    jq -j "$QUERY" |
    while read id _; do
        if [[ "$NO_FOCUS" == "" ]] || [[ $id != $focused ]]; then
            swaymsg "[con_id=$id] focus; move window to scratchpad" &> /dev/null
            [[ "$VERBOSE" ]] && echo "$PROG: moved id $id to scratchpad" >&2
        fi
    done

else
    tile_function="fill_windows"
    [[ "$SHELF" ]] && tile_function="simple_shelf_pack"

    echo "$TREE" |
    jq -j "$QUERY" |
    sort -k3nr | # sort by height
    # simple_shelf_pack |
    # or this one:
    $tile_function | {
    while read id x y; do
        swaymsg "[con_id=$id] move window to workspace current; [con_id=$id] focus; move position $x $y" &>/dev/null
        [[ "$VERBOSE" ]] && echo "$PROG: moved id $id to current workspace ($x, $y)" >&2
    done
    }
fi

# restore focus:
swaymsg "[con_id=$focused]" &>/dev/null

# Local Variables:
# mode: shell-script
# time-stamp-pattern: "4/TIME_STAMP=\"%:y%02m%02d.%02H%02M%02S\""
# eval: (add-hook 'before-save-hook 'time-stamp)
# End:

