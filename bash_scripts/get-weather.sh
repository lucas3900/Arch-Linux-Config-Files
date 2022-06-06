#!/bin/sh
ZIPCODE='10463'
OPEN_WEATHER_API_KEY='22b8c2bc63839bf5b315bf9b80141b40'
URL="https://api.openweathermap.org/data/2.5/weather?zip=${ZIPCODE}&units=imperial&appid=${OPEN_WEATHER_API_KEY}"
temp=$(echo $(curl --silent ${URL}) | jq '.main' | jq '.feels_like')

printf "Bronx: %.0f°F" $temp 
