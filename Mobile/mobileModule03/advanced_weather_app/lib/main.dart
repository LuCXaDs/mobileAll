import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import './services/geolocation_service.dart';

import './models/app_state.dart';
import './models/weather_model.dart';

import 'screens/currently_page.dart';
import 'screens/today_page.dart';
import 'screens/weekly_page.dart';
import 'screens/search_view_screen.dart';
import 'screens/app_bar.dart';

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
        colorScheme: ColorScheme.light(
          primary: Color(0xff2C5364),
          onPrimary: Colors.white,
          secondary: Color(0xff0F2027),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black87,
          error: Colors.red,
          onError: Colors.white,
        ),

        scaffoldBackgroundColor: const Color(0xff030524),
        useMaterial3: true,
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
  final PageController _pageController = PageController();
  String result = '';

  @override
  void initState() {
    super.initState();
    context.read<AppState>().searchController.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geolocationService.handleInitialLocationRequest(context);
    });
  }

  void _onTextChanged() {
    setState(() {
      _geolocationService.searchCities(context);
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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(),
              Expanded(
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
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Today',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Weekly',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                        );
                      },
                    ),
                    if (context
                        .watch<AppState>()
                        .searchController
                        .text
                        .isNotEmpty)
                      Builder(
                        builder:
                            (myHomePageContext) => SearchViewScreen(
                              myHomePageContext: myHomePageContext,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xff11112a),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: GNav(
          padding: EdgeInsetsGeometry.only(
            right: 20,
            left: 20,
            top: 10,
            bottom: 10,
          ),
          gap: 20,
          backgroundColor: Color(0xff11112a),
          tabBackgroundColor: Color(0xff030524),
          color: Colors.white,
          activeColor: Colors.white,
          tabs: [
            GButton(icon: Icons.cloud, text: 'Currently'),
            GButton(icon: Icons.sunny, text: 'Today'),
            GButton(icon: Icons.event, text: 'Weekly'),
          ],
          selectedIndex: appState.selectedIndex,
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }
}
