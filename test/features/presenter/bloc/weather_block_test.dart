import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utils/errors/failure.dart';
import 'package:flutter_clean_architecture/features/domain/usecases/get_current_weather_usecase.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_bloc.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_event.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mock_city_name.dart';
import '../../../mocks/mock_iweather.dart';
import '../../../mocks/mock_weather_repository.dart';

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeatherUsecase usecase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUsecase(mockWeatherRepository);
    weatherBloc = WeatherBloc(usecase);
  });

  void successGetWeatherFromUsecase() {
    when(() => usecase(tCityName))
        .thenAnswer((invocation) async => const Right(tWeatherEntity));
  }

  void failGetWeatherFromUsecase() {
    when(() => usecase(tCityName)).thenAnswer((invocation) async =>
        const Left(ServerFailure('Something went wrong')));
  }

  test('Initial BLoc state should be empty', () {
    expect(weatherBloc.state, WeatherEmptyState());
  });

  blocTest(
    'should emit [loading, has data] when get data is successful',
    build: () {
      successGetWeatherFromUsecase();
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    expect: () => [
      WeatherLoadingState(),
      const WeatherLoadedState(tWeatherEntity),
    ],
  );

  blocTest(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      failGetWeatherFromUsecase();
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    expect: () => [
      WeatherLoadingState(),
      const WeatherErrorState('Something went wrong'),
    ],
  );
}
