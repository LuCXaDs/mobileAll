import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/geolocation_service.dart';

import './models/app_state.dart';
import './models/weather_model.dart';

import 'screens/currently_page.dart';
import 'screens/today_page.dart';
import 'screens/weekly_page.dart';
import 'screens/search_view_screen.dart';

import 'design/degrees_background.dart';

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
        // Crée une instance de ThemeData pour définir le thème de l'application.

        // --- Section des commentaires initiaux ---
        // *** Éviter primary swatch pour ne pas avoir la couleur par défaut (violet) ***
        // Commentaire pertinent. `primarySwatch` génère une palette de couleurs (shades)
        // à partir d'une seule couleur MaterialColor. Si on ne veut pas de ce comportement
        // ou des couleurs par défaut qu'il peut entraîner (souvent basées sur Colors.blue ou
        // Colors.purple si non spécifié), il est préférable de définir les couleurs plus finement.

        // Au lieu de cela, définissez des couleurs spécifiques ou utilisez ColorScheme.
        // Bonne suggestion, ColorScheme étant la méthode moderne et recommandée.

        // --- Option 1: Définir des couleurs spécifiques (méthode plus ancienne, commentée) ---
        // Cette section montre l'ancienne manière de définir certaines couleurs primaires du thème.
        // primaryColor: Colors.grey[300],
        // Définit la couleur principale de l'application. Utilisée par défaut pour les AppBars,
        // certains boutons, etc. `Colors.grey[300]` est une nuance claire de gris.

        // accentColor: Colors.blueGrey,
        // (Obsolète, remplacé par `secondary` dans `ColorScheme`). Utilisée pour les éléments
        // interactifs comme les FloatingActionButtons, les curseurs, les switchs, etc.
        // `Colors.blueGrey` est un gris bleuté.

        // cardColor: Colors.white,
        // Couleur de fond par défaut pour les widgets Card.

        // textSelectionTheme: TextSelectionThemeData(
        // Permet de personnaliser l'apparence de la sélection de texte.
        //   cursorColor: Colors.blueGrey, // Couleur du curseur de texte.
        //   selectionColor: Colors.blueGrey.withOpacity(0.5), // Couleur de fond du texte sélectionné.
        //   selectionHandleColor: Colors.blueGrey, // Couleur des poignées de sélection.
        // ),

        // --- Option 2: Utiliser ColorScheme (méthode recommandée avec Material 3) ---
        // C'est la méthode moderne et plus complète pour définir la palette de couleurs.
        // Un ColorScheme permet de définir toutes les couleurs du thème de manière cohérente.
        // Excellent commentaire. ColorScheme est un ensemble sémantique de couleurs.
        colorScheme: ColorScheme.light(
          // Crée un schéma de couleurs pour un thème clair.
          // Pour un thème sombre, on utiliserait `ColorScheme.dark()`
          // ou `ColorScheme.fromSeed(seedColor: ..., brightness: Brightness.dark)`.
          primary: Color(0xff2C5364),

          // La couleur principale du schéma. Utilisée pour les éléments proéminents comme
          // l'AppBar, les boutons principaux, la teinte des éléments actifs.
          // `Color(0xff2C5364)` est un bleu/gris foncé et profond. Le `0xff` indique l'opacité totale.
          onPrimary: Colors.white,

          // La couleur du texte et des icônes à afficher PAR-DESSUS la couleur `primary`.
          // `Colors.white` assure un bon contraste avec la couleur `primary` foncée.
          secondary: Color(0xff0F2027),

          // La couleur secondaire, utilisée pour les éléments interactifs moins proéminents
          // comme les FloatingActionButtons, filtres, puces, etc.
          // `Color(0xff0F2027)` est un bleu/gris encore plus foncé, presque noir.
          onSecondary: Colors.white,

          // Couleur du texte et des icônes PAR-DESSUS la couleur `secondary`.
          surface: Colors.white,

          // Couleur des "surfaces" des composants comme les Card, Dialog, BottomSheet, menus.
          // `Colors.white` est typique pour les surfaces en thème clair.
          onSurface: Colors.black87,

          // Couleur du texte et des icônes PAR-DESSUS la couleur `surface`.
          // `Colors.black87` (noir avec 87% d'opacité) est un choix courant pour le texte principal.

          // background: Colors.transparent,
          // (Commenté) Couleur de fond générale de l'application. Si vous utilisez un dégradé
          // personnalisé pour le corps du Scaffold, le mettre à transparent ici ou dans
          // `scaffoldBackgroundColor` est une bonne idée.

          // onBackground: Colors.black87,
          // (Commenté) Couleur du texte et des icônes PAR-DESSUS la couleur `background`.
          error: Colors.red,

          // Couleur utilisée pour indiquer des erreurs (par exemple, dans les champs de texte).
          onError: Colors.white,
          // Couleur du texte et des icônes PAR-DESSUS la couleur `error`.

          // Vous pouvez définir d'autres couleurs ici (primaryContainer, secondaryContainer, etc.)
          // Commentaire important. `ColorScheme` a beaucoup plus de propriétés pour des variations
          // de teintes (comme `primaryContainer`, `onPrimaryContainer`, `surfaceVariant`,
          // `onSurfaceVariant`, `outline`, etc.) qui sont particulièrement utiles avec Material 3.
        ),

        // scaffoldBackgroundColor définit la couleur de fond par défaut des Scaffold
        // On le met en transparent ici pour que le dégradé du body soit visible
        scaffoldBackgroundColor: Colors.transparent,

        // Très utile si votre design de fond est géré par un Container parent avec un dégradé
        // ou une image, permettant à ce fond de transparaître.

        // typography: Typography.material2018(), // Utiliser la typographie Material par défaut
        // (Commenté) Permet de spécifier une configuration typographique de base.
        // `Typography.material2018()` ou `Typography.material2021()` (avec Material 3)
        // définissent les styles de texte par défaut (headline1, bodyText1, etc.).

        // textTheme: TextTheme(...), // Personnaliser la typographie si nécessaire
        // (Commenté) Permet de surcharger les styles de texte individuels (taille, graisse,
        // famille de police pour `headlineLarge`, `bodyMedium`, `labelSmall`, etc.).
        useMaterial3: true,
        // Active l'utilisation des styles et comportements de Material Design 3.
        // Cela affecte l'apparence de nombreux widgets (boutons, champs de texte, AppBar, etc.)
        // et est fortement recommandé pour les nouvelles applications.
        // Cela rend également `ColorScheme` encore plus central.
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
  // final WeatherService _weatherService = WeatherService();
  final DegreesBackground _degreesBackground = DegreesBackground();
  final PageController _pageController = PageController();
  final double _currentDegrees = 25;

  @override
  void initState() {
    super.initState();
    context.read<AppState>().searchController.addListener(_onTextChanged);
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
      backgroundColor: Colors.transparent,
      body: Container(
        // Ce Container prend tout l'écran et applique le dégradé
        decoration: BoxDecoration(
          gradient: _degreesBackground.getGradientForDegrees(
            context.read<AppState>().currentDegrees,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Notre AppBar personnalisée
              Padding(
                // Padding pour l'espacement externe de l'AppBar (haut, gauche, droite)
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 16.0,
                  right: 16.0,
                  // bottom: 10.0,
                ),
                child: Container(
                  // Padding interne pour le contenu de l'AppBar
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                    vertical: 3.0,
                  ),
                  decoration: BoxDecoration(
                    // Couleur de fond de l'AppBar (peut être semi-transparente)
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withAlpha((0.90 * 255).round()),
                    borderRadius: BorderRadius.circular(15.0), // Bords arrondis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.1 * 255).round()),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 4, right: 10),
                        child: IconButton(
                          onPressed: () {
                            // setState est utilisé ici si onTapSearch modifie l'état local
                            // Si onTapSearch ne fait que lire depuis AppState et potentiellement
                            // notifier les listeners, setState ici n'est peut-être pas nécessaire
                            // pour la recherche elle-même, mais pour toute autre MAJ d'UI.
                            context.read<AppState>().onTapSearch(context);
                          },
                          icon: Icon(Icons.search),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: context.read<AppState>().searchController,
                          // style: TextStyle(
                          //   color: Theme.of(context).colorScheme.onSurface,
                          // ),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withAlpha((0.6 * 255).round()),
                            ),
                            border:
                                InputBorder
                                    .none, // Pas de bordure pour le TextField
                          ),
                          onSubmitted: (value) {
                            context.read<AppState>().onTapSearch(context);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _geolocationService.fetchLocation(context);
                        },
                        icon: Icon(Icons.place),
                        iconSize: 24,
                        // color: Colors.red,
                        // focusColor: Colors.yellow,
                        // hoverColor: Colors.purple,
                        // highlightColor: Colors.green,
                        // splashColor: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              // Utilisez Expanded pour donner au Stack l'espace restant
              Expanded(
                // <--- MODIFICATION IMPORTANTE
                child: Stack(
                  children: [
                    Consumer<AppState>(
                      builder: (context, appState, child) {
                        return PageView(
                          controller: _pageController, // Doit être initialisé
                          scrollDirection: Axis.horizontal,
                          onPageChanged: _onPageChanged, // Doit être défini
                          physics:
                              appState.showPageInformation
                                  ? null // Permet le scroll
                                  : const NeverScrollableScrollPhysics(), // Bloque le scroll
                          children:
                              appState.showPageInformation
                                  ? const <Widget>[
                                    CurrentlyPage(), // Assurez-vous que ces pages existent
                                    TodayPage(),
                                    WeeklyPage(),
                                  ]
                                  : const <Widget>[
                                    // Contenu alternatif si showPageInformation est false
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
              // Padding(
              //   // Padding pour l'espacement externe de l'AppBar (haut, gauche, droite)
              //   padding: const EdgeInsets.only(
              //     top: 20.0,
              //     left: 16.0,
              //     right: 16.0,
              //     bottom: 10.0,
              //   ),
              //   child: Container(
              //     // Padding interne pour le contenu de l'AppBar
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 8.0,
              //       vertical: 8.0,
              //     ),
              //     decoration: BoxDecoration(
              //       // Couleur de fond de l'AppBar (peut être semi-transparente)
              //       color: Theme.of(
              //         context,
              //       ).colorScheme.surface.withAlpha((0.85 * 255).round()),
              //       borderRadius: BorderRadius.circular(10.0), // Bords arrondis
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withAlpha((0.1 * 255).round()),
              //           blurRadius: 10,
              //           offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: IconButton(
              //             onPressed: () {},
              //             icon: Icon(Icons.currency_ruble),
              //           ),
              //         ),
              //         Expanded(
              //           child: IconButton(
              //             onPressed: () {},
              //             icon: Icon(Icons.currency_ruble),
              //           ),
              //         ),
              //         Expanded(
              //           child: IconButton(
              //             onPressed: () {},
              //             icon: Icon(Icons.currency_ruble),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
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
        // backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
