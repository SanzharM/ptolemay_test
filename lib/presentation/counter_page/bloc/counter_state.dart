part of 'counter_bloc.dart';

abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterInitial extends CounterState {}

class ErrorState extends CounterState {
  final String message;

  const ErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class CounterIncremented extends CounterState {
  final int counter;

  const CounterIncremented(this.counter);

  @override
  List<Object> get props => [counter];
}

class CounterDecremented extends CounterState {
  final int counter;

  const CounterDecremented(this.counter);

  @override
  List<Object> get props => [counter];
}

class WeatherLoaded extends CounterState {
  final String data;

  const WeatherLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class WeatherLoading extends CounterState {}
