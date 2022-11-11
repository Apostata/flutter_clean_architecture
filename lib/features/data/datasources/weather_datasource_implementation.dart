import 'dart:convert';

import 'package:flutter_clean_architecture/core/http_client/http_client_implementation.dart';
import 'package:flutter_clean_architecture/core/utils/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/utils/keys/open_weather_pai_key.dart';
import 'package:flutter_clean_architecture/features/data/datasources/endpoints/weather_endpoints.dart';
import 'package:flutter_clean_architecture/features/data/datasources/weather_datasource_interface.dart';
import 'package:flutter_clean_architecture/features/data/models/weather_model.dart';

class WeatherDataSource implements IWeatherDatasource {
  final HttpClientCustom client;
  WeatherDataSource(this.client);

  @override
  Future<WeatherModel> getCurrentWeatherByCityName(String cityName) async {
    final url = WeatherEndpoints.getCurrentWeatherByName(
        OpenWeatherApiKeys.apiKey, cityName);
    final ressponse = await client.get(url);
    if (ressponse.statusCode == 200) {
      return WeatherModel.fromJson(
        jsonDecode(ressponse.data),
      );
    } else {
      throw ServerException();
    }
  }
}
