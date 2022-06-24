import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ptolemay_test/core/application.dart';
import 'package:ptolemay_test/services/weather/weather_service.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial());

  void increment(int counter, ThemeMode themeMode) => add(IncrementCounter(counter: counter, themeMode: themeMode));
  void decrement(int counter, ThemeMode themeMode) => add(DecrementCounter(counter: counter, themeMode: themeMode));
  void getWeather(Position? position) => add(GetWeather(position));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is IncrementCounter) {
      yield* stateFromIncrement(event.counter, event.themeMode);
    } else if (event is DecrementCounter) {
      yield* stateFromDecrement(event.counter, event.themeMode);
    } else if (event is GetWeather) {
      yield* stateFromGetWeather(event.location);
    }
  }

  Stream<CounterState> stateFromIncrement(int counter, ThemeMode? themeMode) async* {
    counter = counter + (themeMode == ThemeMode.dark ? 2 : 1);
    yield CounterIncremented(checkCounterConstraints(counter));
  }

  Stream<CounterState> stateFromDecrement(int counter, ThemeMode? themeMode) async* {
    counter = counter - (themeMode == ThemeMode.dark ? 2 : 1);
    yield CounterDecremented(checkCounterConstraints(counter));
  }

  Stream<CounterState> stateFromGetWeather(Position? position) async* {
    if (position == null) {
      final position = await Application.determinePosition();
      if (position == null) {
        yield const WeatherLoaded('No position determined');
        return;
      }
    }

    yield WeatherLoading();
    final data = await WeatherService.fetchWeather(position!);
    print('data: $data');

    if (data != null) {
      yield WeatherLoaded(data);
    } else {
      yield const WeatherLoaded('Unable to fetch weather');
    }
  }

  int checkCounterConstraints(int value) {
    if (value.isNegative) return 0;
    if (value > 10) return 10;
    return value;
  }
}
