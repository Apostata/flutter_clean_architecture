import 'dart:convert';
import 'dart:math';

import 'package:flutter_clean_architecture/features/data/models/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/mock_iweather.dart';
import '../../../mocks/mock_weatherModel.dart';
import '../../../mocks/mock_weather_api_response.dart';
import '../../../mocks/mock_weather_model_to_json.dart';
import '../../../mocks/mock_weather_to_string.dart';

void main() {
  group('to entity', () {
    test('Should tWeatherModel be a subclass of Weather entity (IWeather)', () {
      final tWheaterModelToEntity = tWheaterModel.toEntity();

      expect(tWheaterModelToEntity, tWeatherEntity);
    });
  });

  group('from json', () {
    test('Should return a valid WeatherModel from a given json', () {
      final Map<String, dynamic> jsonMap = jsonDecode(mockWeatherApiResponse);

      final tJsonToWeatherModel = WeatherModel.fromJson(jsonMap);
      expect(tJsonToWeatherModel, tWheaterModel);
    });
  });

  group('to json', () {
    test('Should return a valid json from a given WeatherModel', () {
      final tJsonMapFromWheaterModel = tWheaterModel.tojson();
      expect(tJsonMapFromWheaterModel, weatherModelToMap);
    });
  });

  group('to string', () {
    test('Should return a string representation of the Weather model', () {
      final tStringFromWeatherModel = tWheaterModel.toString();
      expect(tStringFromWeatherModel, tMockWeatherToString);
    });
  });
}
