import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/domain/usecases/get_current_weather_usecase.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_event.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUsecase _getCurrentWeather;

  WeatherBloc(this._getCurrentWeather) : super(WeatherEmptyState()) {
    on<OnCityChanged>((event, emit) async {
      final cityName = event.cityName;
      emit(WeatherLoadingState());

      final weatherResult = await _getCurrentWeather(cityName);

      weatherResult.fold((failure) {
        emit(WeatherErrorState(failure.message));
      }, (data) {
        emit(
          WeatherLoadedState(data),
        );
      });
    });
  }
}
