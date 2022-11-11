import 'package:flutter_clean_architecture/features/domain/entities/weather_entity.dart';

class WeatherModel extends IWeather {
  const WeatherModel({
    required String cityName,
    required String main,
    required String description,
    required String iconCode,
    required double temperature,
    required int pressure,
    required int humidity,
  }) : super(
          cityName: cityName,
          main: main,
          description: description,
          iconCode: iconCode,
          temperature: temperature,
          pressure: pressure,
          humidity: humidity,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json["name"],
      main: json["weather"][0]['main'],
      description: json["weather"][0]['description'],
      iconCode: json["weather"][0]['icon'],
      temperature: json["main"]['temp'],
      pressure: json["main"]['pressure'],
      humidity: json["main"]['humidity'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "weather": [
        {
          "main": main,
          "description": description,
          "icon": iconCode,
        },
      ],
      "main": {
        "temp": temperature,
        "pressure": pressure,
        "humidity": humidity,
      },
      "name": cityName,
    };
  }

  IWeather toEntity() {
    return IWeather(
      cityName: cityName,
      main: main,
      description: description,
      iconCode: iconCode,
      temperature: temperature,
      pressure: pressure,
      humidity: humidity,
    );
  }

  @override
  String toString() {
    return 'WeatherModel('
        'cityName: $cityName, '
        'main: $main, '
        'description: $description, '
        'iconCode: $iconCode, '
        'temperature: $temperature, '
        'pressure: $pressure, '
        'humidity: $humidity)';
  }
}
