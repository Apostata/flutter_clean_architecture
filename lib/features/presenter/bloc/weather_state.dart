import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/features/domain/entities/weather_entity.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherEmptyState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final IWeather weather;
  const WeatherLoadedState(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherErrorState extends WeatherState {
  final String message;
  const WeatherErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
