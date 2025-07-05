#!/usr/bin/env bash

# Simple weather script for Phoenix, AZ using curl and wttr.in
# This is a fallback that doesn't require Python requests library

CITY="phoenix"
CACHE_FILE="/tmp/waybar-weather-cache"
CACHE_TIME=3600  # 1 hour in seconds

# Check if cache exists and is fresh
if [[ -f "$CACHE_FILE" ]]; then
    CACHE_AGE=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [[ $CACHE_AGE -lt $CACHE_TIME ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Function to get weather data
get_weather() {
    if command -v curl >/dev/null 2>&1; then
        # Get current weather in a simple format
        WEATHER_DATA=$(curl -s "wttr.in/${CITY}?format=%C+%t+%f+%h+%w" 2>/dev/null)

        if [[ -n "$WEATHER_DATA" && "$WEATHER_DATA" != *"Unknown location"* ]]; then
            # Parse the simple format: Condition Temperature FeelsLike Humidity Wind
            IFS=' ' read -ra WEATHER_PARTS <<< "$WEATHER_DATA"

            CONDITION="${WEATHER_PARTS[0]}"
            TEMP="${WEATHER_PARTS[1]}"
            FEELS_LIKE="${WEATHER_PARTS[2]}"
            HUMIDITY="${WEATHER_PARTS[3]}"
            WIND="${WEATHER_PARTS[4]} ${WEATHER_PARTS[5]}"

            # Convert temperature to Fahrenheit if it's in Celsius
            if [[ "$TEMP" == *"°C" ]]; then
                TEMP_NUM=$(echo "$TEMP" | sed 's/°C//')
                TEMP_F=$(echo "scale=0; ($TEMP_NUM * 9/5) + 32" | bc 2>/dev/null || echo "$TEMP")
                TEMP="${TEMP_F}°F"
            fi

            # Map condition to Nerd Font weather icons
            case "$CONDITION" in
                *"Sunny"*|*"Clear"*) EMOJI="󰖙" ;;
                *"Partly"*|*"cloudy"*) EMOJI="󰖕" ;;
                *"Cloudy"*|*"Overcast"*) EMOJI="󰖐" ;;
                *"Rain"*|*"Drizzle"*) EMOJI="󰖗" ;;
                *"Snow"*) EMOJI="󰖘" ;;
                *"Thunder"*|*"Storm"*) EMOJI="󰖓" ;;
                *"Fog"*|*"Mist"*) EMOJI="󰖑" ;;
                *) EMOJI="󰔏" ;;
            esac

            # Create JSON output
            TEXT="$EMOJI $TEMP"
            TOOLTIP="$CONDITION in Phoenix, AZ\\n"
            TOOLTIP+="Temperature: $TEMP\\n"
            TOOLTIP+="Feels like: $FEELS_LIKE\\n"
            TOOLTIP+="Humidity: $HUMIDITY\\n"
            TOOLTIP+="Wind: $WIND"

            JSON_OUTPUT=$(printf '{"text": "%s", "tooltip": "%s"}' "$TEXT" "$TOOLTIP")

            # Cache the result
            echo "$JSON_OUTPUT" > "$CACHE_FILE"
            echo "$JSON_OUTPUT"
            return 0
        fi
    fi

    # Fallback if curl fails or no data
    FALLBACK='{"text": "󰔏 Phoenix", "tooltip": "Weather data unavailable"}'
    echo "$FALLBACK" > "$CACHE_FILE"
    echo "$FALLBACK"
}

get_weather
