import 'package:equatable/equatable.dart';

class IWeather extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final num temperature;
  final num pressure;
  final num humidity;

  const IWeather({
    required this.cityName,
    required this.main,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
        cityName,
        main,
        description,
        iconCode,
        temperature,
        pressure,
        humidity,
      ];
}
