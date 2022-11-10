import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utils/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/utils/errors/failure.dart';
import 'package:flutter_clean_architecture/features/data/repositories/weather_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks/mock_city_name.dart';
import '../../../mocks/mock_weatherModel.dart';
import '../../../mocks/mock_weather_datasource.dart';

void main() {
  late MockWeatherDataSource mockWeatherDataSource;
  late WeatherRepository repository;

  setUp(() {
    mockWeatherDataSource = MockWeatherDataSource();
    repository = WeatherRepository(mockWeatherDataSource);
  });

  void dataSoruceGetSuccess() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenAnswer(
      (invocation) async => tWheaterModel,
    );
  }

  void dataSoruceGetFail() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenThrow(ServerException());
  }

  void dataSoruceGetNoConnection() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenThrow(SocketException());
  }

  group('get weather from datasource', () {
    test(
        'Should return the Weather when successful call the the datasource from repository',
        () async {
      dataSoruceGetSuccess();

      final successfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(successfulResponse, const Right(tWheaterModel));
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });

    test(
        'Should ServerExeption when unsuccessful call the the datasource from repository',
        () async {
      dataSoruceGetFail();

      final unsuccessfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(
        unsuccessfulResponse,
        const Left(
          ServerFailure('Something went wrong'),
        ),
      );
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });

    test('Should SocketException when there is no connection', () async {
      dataSoruceGetNoConnection();

      final unsuccessfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(
        unsuccessfulResponse,
        const Left(
          ConnectionFailure('Failed to connect to newwork!'),
        ),
      );
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });
  });
}
