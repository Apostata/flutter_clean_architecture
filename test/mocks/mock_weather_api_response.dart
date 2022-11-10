const mockWeatherApiResponse = """
{
  "coord": {
    "lon": -47.2181,
    "lat": -23.0903
  },
  "weather": [
    {
      "id": 800,
      "main": "Clouds",
      "description": "scattered clouds",
      "icon": "03d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 300.45,
    "feels_like": 301.98,
    "temp_min": 303.07,
    "temp_max": 303.07,
    "pressure": 1014,
    "humidity": 21,
    "sea_level": 1011,
    "grnd_level": 944
  },
  "visibility": 10000,
  "wind": {
    "speed": 6.33,
    "deg": 262,
    "gust": 9.2
  },
  "clouds": {
    "all": 8
  },
  "dt": 1668013306,
  "sys": {
    "type": 2,
    "id": 2011316,
    "country": "BR",
    "sunrise": 1667981952,
    "sunset": 1668029176
  },
  "timezone": -10800,
  "id": 3461311,
  "name": "Indaiatuba",
  "cod": 200
}""";
