import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptolemay_test/core/application.dart';
import 'package:ptolemay_test/presentation/counter_page/bloc/counter_bloc.dart';
import 'package:ptolemay_test/presentation/theme/bloc/theme_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = CounterBloc();
  int _counter = 0;

  String? weatherData;
  Position? _position;
  bool isWeatherLoading = false;

  void _requestPermission() async {
    _position = await Application.determinePosition();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        isWeatherLoading = state is WeatherLoading;
        if (state is WeatherLoaded) {
          weatherData = state.data;
        }
        setState(() {});
      },
      builder: (context, state) {
        if (state is CounterIncremented) {
          _counter = state.counter;
        }
        if (state is CounterDecremented) {
          _counter = state.counter;
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Weather
                WeatherWidget(
                  weather: weatherData,
                  isLoading: state is WeatherLoading,
                ),
                const SizedBox(height: 16.0),

                // Counter
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Weather && Palette
                    FloatingActionButton(
                      onPressed: () {
                        if (isWeatherLoading) return;
                        _bloc.getWeather(_position);
                      },
                      tooltip: 'Weather',
                      child: isWeatherLoading ? const CupertinoActivityIndicator() : const Icon(Icons.cloud),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    FloatingActionButton(
                      onPressed: () => BlocProvider.of<ThemeBloc>(context).change(Application.getThemeMode(context, reversed: true)),
                      tooltip: 'Theme mode',
                      child: const Icon(Icons.palette),
                    ),
                  ],
                ),

                // Increment && Decrement
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: _counter < 10
                          ? FloatingActionButton(
                              onPressed: () => _bloc.increment(_counter, Application.getThemeMode(context)),
                              tooltip: 'Increment',
                              child: const Icon(Icons.add),
                            )
                          : const SizedBox(height: 56, width: 56),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16.0)),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: _counter > 0
                          ? FloatingActionButton(
                              onPressed: () => _bloc.decrement(
                                _counter,
                                Application.getThemeMode(context),
                              ),
                              tooltip: 'Decrement',
                              child: const Icon(Icons.remove),
                            )
                          : const SizedBox(height: 56, width: 56),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key, required this.weather, this.isLoading = false}) : super(key: key);

  final bool isLoading;
  final String? weather;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
      child: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                weather ?? 'Press the icon to get your location',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }
}
