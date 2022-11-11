import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_bloc.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_event.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class FakeWeatherState extends Fake implements WeatherState {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}
