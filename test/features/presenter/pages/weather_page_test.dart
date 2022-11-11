import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/http_client/http_client_implementation.dart';
import 'package:flutter_clean_architecture/features/data/constants.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_bloc.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_event.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_state.dart';
import 'package:flutter_clean_architecture/features/presenter/pages/weather_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import '../../../mocks/mock_city_name.dart';
import '../../../mocks/mock_iweather.dart';
import '../../../mocks/mock_weather_bloc.dart';

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherState());
    registerFallbackValue(FakeWeatherEvent());

    final di = GetIt.instance;
    di.registerFactory<WeatherBloc>(() => mockWeatherBloc);
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('text field should trigger state to change from empty to loading',
      (tester) async {
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmptyState());

    await tester.pumpWidget(
      makeTestableWidget(
        const WeatherPage(),
      ),
    );
    await tester.enterText(
      find.byType(TextField),
      tCityName,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(
      find.byType(TextField),
      equals(findsOneWidget),
    );
    verify(
      () => mockWeatherBloc.add(const OnCityChanged(tCityName)),
    );
  });

  testWidgets(
      'Should show widget containg weather data when state is WeatherLoadedState',
      (tester) async {
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherLoadedState(tWeatherEntity));

    await tester.pumpWidget(
      makeTestableWidget(
        const WeatherPage(),
      ),
    );
    await tester.runAsync(
      () async {
        final HttpClientCustom httpClient = HttpClientCustom();
        await httpClient.get(weatherIcon('03d'));
      },
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('weather_data')),
      equals(findsOneWidget),
    );
  });
}
