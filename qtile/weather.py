import requests

OPEN_WEATHER_API_KEY = "22b8c2bc63839bf5b315bf9b80141b40"
AT_HOME = True


def getWeather():
    zipcode = "10463"
    if not AT_HOME:
        zipcode = "13323"
    r = requests.get(f'https://api.openweathermap.org/data/2.5/weather?zip={zipcode}&units=imperial&appid={OPEN_WEATHER_API_KEY}')
    pyDict = r.json()
    return pyDict['name']+': '+str(round(pyDict['main']['temp']))+'°F'


def weatherControl():
   print(getWeather())


if __name__ == '__main__':
    weatherControl()
