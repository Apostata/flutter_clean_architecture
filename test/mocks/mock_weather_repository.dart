import 'package:flutter_clean_architecture/features/domain/repositories/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements IWeatherRepository {}
