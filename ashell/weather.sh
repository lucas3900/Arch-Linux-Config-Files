#!/bin/bash

# free API key
OPEN_WEATHER_API_KEY="22b8c2bc63839bf5b315bf9b80141b40"
AT_HOME=true

# Map OpenWeatherMap icon codes to simple text
getWeatherIcon() {
    local icon="$1"
    case "$icon" in
        "01d") echo "☀" ;;  # sun
        "01n") echo "☾" ;;  # moon
        "02d"|"02n") echo "⛅" ;;  # partly cloudy
        "03d"|"03n") echo "☁" ;;  # cloudy
        "04d"|"04n") echo "☁" ;;  # cloudy
        "09d"|"09n") echo "🌧" ;;  # rain
        "10d"|"10n") echo "🌧" ;;  # rain
        "11d"|"11n") echo "⚡" ;;  # thunderstorm
        "13d"|"13n") echo "❄" ;;  # snow
        "50d"|"50n") echo "🌫" ;;  # fog
        *) echo "🌡" ;;  # thermometer
    esac
}

getWeather() {
    local zipcode="10036"
    if [ "$AT_HOME" = false ]; then
        zipcode="13323"
    fi

    # Fetch weather data from OpenWeatherMap API
    local response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?zip=${zipcode}&units=imperial&appid=${OPEN_WEATHER_API_KEY}")

    # Parse JSON response using jq (or grep/sed if jq is not available)
    if command -v jq &> /dev/null; then
        # Using jq for JSON parsing
        local name=$(echo "$response" | jq -r '.name')
        local temp=$(echo "$response" | jq -r '.main.temp')
        local icon=$(echo "$response" | jq -r '.weather[0].icon')
        local temp_rounded=$(printf "%.0f" "$temp")
        local weather_icon=$(getWeatherIcon "$icon")

        # Output in Waybar JSON format for ashell
        echo "{\"text\": \"${weather_icon}  ${temp_rounded}°F\", \"alt\": \"${icon}\"}"
    else
        # Fallback using grep and sed (less reliable but doesn't require jq)
        local name=$(echo "$response" | grep -o '"name":"[^"]*"' | sed 's/"name":"\([^"]*\)"/\1/')
        local temp=$(echo "$response" | grep -o '"temp":[0-9.]*' | sed 's/"temp":\([0-9.]*\)/\1/')
        local icon=$(echo "$response" | grep -o '"icon":"[^"]*"' | head -1 | sed 's/"icon":"\([^"]*\)"/\1/')
        local temp_rounded=$(printf "%.0f" "$temp")
        local weather_icon=$(getWeatherIcon "$icon")

        # Output in Waybar JSON format for ashell
        echo "{\"text\": \"${weather_icon}  ${temp_rounded}°F\", \"alt\": \"${icon}\"}"
    fi
}

weatherControl() {
    getWeather
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    weatherControl
fi

