import 'package:flutter_clean_architecture/core/Interfaces/http_response.dart';
import 'package:flutter_clean_architecture/core/utils/errors/exceptions.dart';
import 'package:flutter_clean_architecture/features/data/datasources/weather_datasource_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks/mock_api_url.dart';
import '../../../mocks/mock_city_name.dart';
import '../../../mocks/mock_http_client.dart';
import '../../../mocks/mock_weatherModel.dart';
import '../../../mocks/mock_weather_api_response.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late WeatherDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherDataSource(mockHttpClient);
  });

  void httpGetSuccess() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (invocation) async => HttpResponse(mockWeatherApiResponse, 200),
    );
  }

  void httpGetFail() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (invocation) async => HttpResponse('something went wrong', 400),
    );
  }

  group('get corrent weather url', () {
    test('Should call the client.get with correct url', () async {
      httpGetSuccess();

      await dataSource.getCurrentWeatherByCityName(tCityName);

      verify(() => mockHttpClient.get(mockApiUrl)).called(1);
    });
  });

  group('get current weather responses', () {
    test('Should return a WeatherModel when successful calls the api',
        () async {
      httpGetSuccess();

      final successfulResponse =
          await dataSource.getCurrentWeatherByCityName(tCityName);

      expect(successfulResponse, tWheaterModel);
    });

    test('Should return a ServerException when unsuccessful calls the api',
        () async {
      httpGetFail();

      final unsuccessfulResponse =
          dataSource.getCurrentWeatherByCityName(tCityName);

      expect(unsuccessfulResponse, throwsA(ServerException()));
    });
  });
}
