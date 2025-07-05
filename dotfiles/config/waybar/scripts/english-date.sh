#!/usr/bin/env bash

# Get current date components
day=$(date +'%d')
month=$(date +'%b')  # Short month name (Jan, Feb, etc.)
year=$(date +'%Y')
weekday=$(date +'%A')

text="󰃭 $day"
alt="󰃭 $month $day"
tooltip="󰃭 $weekday, $month $day, $year"

printf '{"text": "%s", "alt": "%s", "tooltip": "%s"}\n' "$text" "$alt" "$tooltip"