import 'package:flutter_clean_architecture/features/domain/usecases/get_current_weather_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentWeatherUsecase extends Mock
    implements GetCurrentWeatherUsecase {}
