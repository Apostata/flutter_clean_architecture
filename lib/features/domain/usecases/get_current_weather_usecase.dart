import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/Interfaces/usecase.dart';
import 'package:flutter_clean_architecture/core/utils/errors/failure.dart';
import 'package:flutter_clean_architecture/features/domain/entities/weather_entity.dart';
// import 'package:flutter_clean_architecture/features/domain/repositories/weather_repository.dart';

import '../../data/repositories/weather_repository_implementation.dart';

class GetCurrentWeatherUsecase implements IUseCase<IWeather, String> {
  final WeatherRepository repository;
  GetCurrentWeatherUsecase(this.repository);

  @override
  Future<Either<Failure, IWeather>> call(String cityName) {
    return repository.getCurrentWeatherByCityName(cityName);
  }
}
