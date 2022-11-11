import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/data/repositories/weather_repository_implementation.dart';
import 'package:flutter_clean_architecture/features/domain/usecases/get_current_weather_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mock_iweather.dart';
import '../../../mocks/mock_weather_repository.dart';

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeatherUsecase usecase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUsecase(mockWeatherRepository);
  });

  const tCityName = 'Indaiatuba';

  test('Should get current weather from the repository', () async {
    when(
      () => mockWeatherRepository.getCurrentWeatherByCityName(tCityName),
    ).thenAnswer(
      (_) async => const Right(tWeatherEntity),
    );

    final result = await usecase(tCityName);

    expect(
      result,
      const Right(tWeatherEntity),
    );
  });
}
