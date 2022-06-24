part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class IncrementCounter extends CounterEvent {
  final int counter;
  final ThemeMode themeMode;

  const IncrementCounter({required this.counter, this.themeMode = ThemeMode.light});

  @override
  List<Object> get props => [counter, themeMode];
}

class DecrementCounter extends CounterEvent {
  final int counter;
  final ThemeMode themeMode;

  const DecrementCounter({required this.counter, this.themeMode = ThemeMode.light});

  @override
  List<Object> get props => [counter, themeMode];
}

class GetWeather extends CounterEvent {
  final Position? location;

  const GetWeather(this.location);

  @override
  List<Object> get props => [];
}
