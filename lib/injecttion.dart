import 'package:flutter_clean_architecture/core/http_client/http_client_implementation.dart';
import 'package:flutter_clean_architecture/features/data/datasources/weather_datasource_implementation.dart';
import 'package:flutter_clean_architecture/features/data/repositories/weather_repository_implementation.dart';
import 'package:flutter_clean_architecture/features/domain/usecases/get_current_weather_usecase.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_bloc.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => WeatherBloc(locator()),
  );

  // usecase
  locator.registerLazySingleton(
    () => GetCurrentWeatherUsecase(locator()),
  );

  // repository
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepository(locator()),
  );

  // datasource
  locator.registerLazySingleton(
    () => WeatherDataSource(locator()),
  );

  // httpClient
  locator.registerLazySingleton<HttpClientCustom>(() => HttpClientCustom());
}
