#!/bin/bash

# ------------ CONFIGURATION ------------
IDLE_THRESHOLD_MS=300000     # 5 minutes = 300000 ms
CALENDAR_WORKSPACE=4         # Workspace 4 (0-indexed)
CHECK_INTERVAL=5             # Check every 5 seconds
THUNDERBIRD_CMD="thunderbird"

# ------------ STATE ------------
calendar_active=false
original_workspace=$(wmctrl -d | grep '*' | cut -d ' ' -f1)

# ------------ CLEANUP FUNCTION ------------
cleanup() {
    echo "[INFO] Exiting. Cleaning up…"
    if $calendar_active; then
        pkill -f "$THUNDERBIRD_CMD"
        wmctrl -s $original_workspace
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM

# ------------ HELPER FUNCTION: Check if fullscreen video is playing ------------
is_fullscreen_video_playing() {
    active_win=$(xdotool getactivewindow)

    if [ -n "$active_win" ]; then
        fullscreen=$(xprop -id "$active_win" _NET_WM_STATE 2>/dev/null | grep _NET_WM_STATE_FULLSCREEN)
        class=$(xprop -id "$active_win" WM_CLASS 2>/dev/null)

        if [[ -n "$fullscreen" ]] && echo "$class" | grep -Ei 'vlc|mpv|firefox|chromium|brave|kodi|totem|mplayer' >/dev/null; then
            echo "[INFO] Fullscreen video playing in: $class"
            return 0
        fi
    fi

    return 1
}

# ------------ MAIN LOOP ------------
while true; do
    idle_time=$(xprintidle)

    if [ "$idle_time" -gt "$IDLE_THRESHOLD_MS" ] && ! is_fullscreen_video_playing; then
        if ! $calendar_active; then
            echo "[INFO] Idle. Launching Thunderbird calendar."

            # Save workspace
            original_workspace=$(wmctrl -d | grep '*' | cut -d ' ' -f1)

            # Switch to calendar workspace
            wmctrl -s $CALENDAR_WORKSPACE
            sleep 1

            # Launch Thunderbird
            $THUNDERBIRD_CMD &
            sleep 5

            # Wait for Thunderbird window to be visible
            timeout=30
            while [ $timeout -gt 0 ]; do
                tb_win=$(xdotool search --onlyvisible --class thunderbird 2>/dev/null | head -n 1)
                if [ -n "$tb_win" ]; then
                    break
                fi
                sleep 1
                timeout=$((timeout - 1))
            done

            # Fullscreen it
            if [ -n "$tb_win" ]; then
                echo "[INFO] Fullscreening Thunderbird: $tb_win"
                xdotool windowactivate "$tb_win"
                sleep 0.5
                xdotool key --window "$tb_win" F11
            else
                echo "[WARN] Thunderbird window not found."
            fi

            calendar_active=true
        fi
    else
        if $calendar_active; then
            echo "[INFO] User active or video playing. Closing calendar."

            pkill -f "$THUNDERBIRD_CMD"
            sleep 2
            wmctrl -s $original_workspace
            calendar_active=false
        fi
    fi

    sleep $CHECK_INTERVAL
done
