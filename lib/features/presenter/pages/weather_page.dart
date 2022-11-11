import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/data/constants.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_bloc.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_event.dart';
import 'package:flutter_clean_architecture/features/presenter/bloc/weather_state.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Weather',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body:
            // Container()
            Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                decoration:
                    const InputDecoration(hintText: 'Enter a city name'),
                onSubmitted: (query) {
                  context.read<WeatherBloc>().add(OnCityChanged(query));
                },
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                      // SizedBox(Text('loading...'))
                    );
                  } else if (state is WeatherLoadedState) {
                    return Center(
                      child: Column(
                        key: const Key('weather_data'),
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    state.weather.cityName,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                Image(
                                  image: NetworkImage(
                                    weatherIcon(state.weather.iconCode),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    '${state.weather.main} | ${state.weather.description}',
                                    style: const TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          Center(
                            child: Table(
                              defaultColumnWidth: const FixedColumnWidth(150),
                              border: TableBorder.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Temperature',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        state.weather.temperature.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Pressure',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        state.weather.pressure.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Humidity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        state.weather.humidity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is WeatherErrorState) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
