import 'package:flutter_clean_architecture/features/data/models/weather_model.dart';

abstract class IWeatherDatasource {
  Future<WeatherModel> getCurrentWeatherByCityName(String cityName);
}
