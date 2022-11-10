import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/domain/entities/weather_entity.dart';
import '../../../core/utils/errors/failure.dart';

abstract class IWeatherRepository {
  Future<Either<Failure, IWeather>> getCurrentWeatherByCityName(
      String cityName);
}
