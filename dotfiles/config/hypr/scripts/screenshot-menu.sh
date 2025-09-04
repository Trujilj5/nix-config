#!/bin/sh

# Screenshot menu script with proper delay functionality
choice=$(echo -e "📸 Region Screenshot\n🖥️ Full Screen\n🪟 Window Screenshot\n⏱️ 3s Delay Region\n⏲️ 5s Delay Region" | wofi --dmenu --prompt="Screenshot Options")

case "$choice" in
    "📸 Region Screenshot")
        grim -g "$(slurp)" - | swappy -f -
        ;;
    "🖥️ Full Screen")
        grim - | swappy -f -
        ;;
    "🪟 Window Screenshot")
        grim -g "$(hyprctl activewindow -j | jq -r '"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"')" - | swappy -f -
        ;;
    "⏱️ 3s Delay Region")
        # First select the region while hovering
        region=$(slurp)
        if [ $? -eq 0 ]; then
            # Show countdown notification
            notify-send "Screenshot" "Taking screenshot in 3 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 2 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 1 second..." -t 1000
            sleep 1
            # Take the screenshot of the pre-selected region
            grim -g "$region" - | swappy -f -
        fi
        ;;
    "⏲️ 5s Delay Region")
        # First select the region while hovering
        region=$(slurp)
        if [ $? -eq 0 ]; then
            # Show countdown notification
            notify-send "Screenshot" "Taking screenshot in 5 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 4 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 3 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 2 seconds..." -t 1000
            sleep 1
            notify-send "Screenshot" "Taking screenshot in 1 second..." -t 1000
            sleep 1
            # Take the screenshot of the pre-selected region
            grim -g "$region" - | swappy -f -
        fi
        ;;
esac
