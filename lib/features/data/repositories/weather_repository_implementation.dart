import 'package:flutter_clean_architecture/core/utils/errors/exceptions.dart';
import 'package:flutter_clean_architecture/features/data/datasources/weather_datasource_interface.dart';
import 'package:flutter_clean_architecture/features/domain/entities/weather_entity.dart';
import 'package:flutter_clean_architecture/core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/features/domain/repositories/weather_repository.dart';

class WeatherRepository implements IWeatherRepository {
  final IWeatherDatasource datasource;

  WeatherRepository(this.datasource);

  @override
  Future<Either<Failure, IWeather>> getCurrentWeatherByCityName(
      String cityName) async {
    try {
      final result = await datasource.getCurrentWeatherByCityName(cityName);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to newwork!'));
    }
  }
}
