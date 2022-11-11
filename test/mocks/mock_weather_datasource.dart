import 'package:flutter_clean_architecture/features/data/datasources/weather_datasource_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherDataSource extends Mock implements IWeatherDatasource {}
