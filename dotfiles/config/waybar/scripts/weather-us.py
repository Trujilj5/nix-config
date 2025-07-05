#!/usr/bin/env python3

import json
import sys

try:
    import requests
    from datetime import datetime

    WEATHER_CODES = {
        '113': '☀️',
        '116': '⛅',
        '119': '☁️',
        '122': '☁️',
        '143': '🌫️',
        '176': '🌦️',
        '179': '🌨️',
        '182': '🌧️',
        '185': '🌧️',
        '200': '⛈️',
        '227': '🌨️',
        '230': '❄️',
        '248': '🌫️',
        '260': '🌫️',
        '263': '🌦️',
        '266': '🌦️',
        '281': '🌧️',
        '284': '🌧️',
        '293': '🌦️',
        '296': '🌦️',
        '299': '🌧️',
        '302': '🌧️',
        '305': '🌧️',
        '308': '🌧️',
        '311': '🌧️',
        '314': '🌧️',
        '317': '🌧️',
        '320': '🌨️',
        '323': '🌨️',
        '326': '🌨️',
        '329': '❄️',
        '332': '❄️',
        '335': '❄️',
        '338': '❄️',
        '350': '🌧️',
        '353': '🌦️',
        '356': '🌧️',
        '359': '🌧️',
        '362': '🌧️',
        '365': '🌧️',
        '368': '🌨️',
        '371': '❄️',
        '374': '🌨️',
        '377': '🌧️',
        '386': '⛈️',
        '389': '⛈️',
        '392': '⛈️',
        '395': '❄️'
    }

    # Change this to your city
    CITY = "Phoenix"  # Phoenix, Arizona
    
    weather = requests.get(f"https://wttr.in/{CITY}?format=j1").json()

    tempF = int(weather['current_condition'][0]['temp_F'])
    weather_code = weather['current_condition'][0]['weatherCode']
    
    data = {}
    data['text'] = f"{WEATHER_CODES.get(weather_code, '🌡️')} {tempF}°F"
    
    data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {tempF}°F</b>\n"
    data['tooltip'] += f"Feels like: {weather['current_condition'][0]['FeelsLikeF']}°F\n"
    data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedMiles']}mph\n"
    data['tooltip'] += f"Humidity: {weather['current_condition'][0]['humidity']}%\n"
    
    for i, day in enumerate(weather['weather']):
        data['tooltip'] += f"\n<b>"
        if i == 0:
            data['tooltip'] += "Today, "
        elif i == 1:
            data['tooltip'] += "Tomorrow, "
        data['tooltip'] += f"{day['date']}</b>\n"
        data['tooltip'] += f"High: {day['maxtempF']}°F  Low: {day['mintempF']}°F\n"
        data['tooltip'] += f"Sunrise: {day['astronomy'][0]['sunrise']}  Sunset: {day['astronomy'][0]['sunset']}\n"

    print(json.dumps(data))

except ImportError:
    data = {
        'text': '🌡️ Weather',
        'tooltip': 'Install python3-requests for weather updates'
    }
    print(json.dumps(data))
except Exception as e:
    data = {
        'text': '🌡️ N/A',
        'tooltip': f'Weather error: {str(e)}'
    }
    print(json.dumps(data))