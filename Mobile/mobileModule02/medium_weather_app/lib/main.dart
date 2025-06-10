import 'package:flutter/material.dart';
import 'package:medium_weather_app/services/weather_service.dart';
import 'dart:async';

import './services/geolocation_service.dart';
import './models/app_state.dart';
import './models/weather_model.dart';

import 'screens/currently_page.dart';
import 'screens/today_page.dart';
import 'screens/weekly_page.dart';
import 'screens/search_view_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => WeatherDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather_App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[500],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.grey[300],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const MyHomePage(title: 'Gulli Meteo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GeolocationService _geolocationService = GeolocationService();
  final WeatherService _weatherService = WeatherService();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<AppState>().searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _searchCities();
    });
  }

  @override
  void dispose() {
    context.read<AppState>().searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      context.read<AppState>().setSelectedIndex(index);
      var endIndex = context.read<AppState>().selectedIndex;
      _pageController.animateToPage(
        duration: Duration(microseconds: 200),
        curve: Curves.linear,
        endIndex,
      );
      debugPrint('$endIndex');
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      context.read<AppState>().setSelectedIndex(index);
    });
  }

  Future<void> _fetchLocation() async {
    try {
      String result = await _geolocationService.getCurrentLocation();

      // Mettre à jour l'état de l'application
      if (context.mounted) {
        context.read<AppState>().searchController.clear();
        context.read<AppState>().citySuggestions.clear();
        context.read<AppState>().setSearchText('');
        context.read<AppState>().setLocationMessage(result);
      }

      double latitude = 0.0;
      double longitude = 0.0;
      List<String> parts = result.split(',');
      if (parts.length == 2) {
        String latitudePart = parts[0].trim();
        String longitudePart = parts[1].trim();

        if (latitudePart.startsWith('Latitude:') &&
            longitudePart.startsWith('Longitude:')) {
          latitude = double.parse(
            latitudePart.substring('Latitude:'.length).trim(),
          );
          longitude = double.parse(
            longitudePart.substring('Longitude:'.length).trim(),
          );

          // print('Latitude: $latitude');
          // print('Longitude: $longitude');
        }
      }

      if (latitude != 0 && longitude != 0) {
        if (context.mounted) {
          context.read<AppState>().setLatAndLong(
            latitude.toString(),
            longitude.toString(),
          );
        }
        // debugPrint('$latitude, $longitude NAATEFEf');

        // Récupérer les données météorologiques
        WeatherData weatherData = await _weatherService.fetchWeatherData(
          latitude.toString(),
          longitude.toString(),
        );

        // Mettre à jour le provider avec les données météorologiques
        if (context.mounted) {
          context.read<WeatherDataProvider>().setWeatherData(weatherData);
        }

        // Mettre à jour l'interface utilisateur
        setState(() {
          context.read<AppState>().setShowPageInformation(true);
        });
      }
    } catch (e) {
      // Gérer les erreurs ici
      debugPrint('Error fetching location: $e');
    }
  }

  Future<void> _searchCities() async {
    if (context.read<AppState>().searchController.text.isNotEmpty) {
      List<dynamic> result = await _weatherService.getCitySuggestions(
        context.read<AppState>().searchController.text,
      );
      // debugPrint('$result');
      setState(() {
        context.read<AppState>().setCitySuggestions(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4, right: 10),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    context.read<AppState>().onTapSearch(context);
                  });
                },
                icon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: TextField(
                controller: context.read<AppState>().searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  setState(() {
                    context.read<AppState>().onTapSearch(context);
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _fetchLocation,
            icon: Icon(Icons.place),
            iconSize: 24,
            // color:
            //     appState.locationMessage.isNotEmpty
            //         ? Colors.deepPurpleAccent
            //         : Colors.grey,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Consumer<AppState>(
              builder: (context, appState, child) {
                return PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: _onPageChanged,
                  physics:
                      appState.showPageInformation
                          ? null
                          : const NeverScrollableScrollPhysics(),
                  children:
                      appState.showPageInformation
                          ? const <Widget>[
                            CurrentlyPage(),
                            TodayPage(),
                            WeeklyPage(),
                          ]
                          : const <Widget>[
                            Center(
                              child: Text(
                                'Currently',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Today',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Weekly',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                          ],
                );
              },
            ),
            context.read<AppState>().searchController.text.isNotEmpty
          ? Builder( // Utilisez un Builder ici
              builder: (myHomePageContext) => SearchViewScreen(myHomePageContext: myHomePageContext),
            )
          : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Currently'),
          BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Weekly'),
        ],
        currentIndex: appState.selectedIndex,
        // selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
