class WeatherEndpoints {
  static getCurrentWeatherByName(String apiKey, String cityName) {
    return 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';
  }
}
