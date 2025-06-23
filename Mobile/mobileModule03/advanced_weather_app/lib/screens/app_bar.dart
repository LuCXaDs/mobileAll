import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/geolocation_service.dart';
import '../models/app_state.dart';

/// Une AppBar personnalisée qui contient une barre de recherche et des actions.
///
/// Ce widget est conçu pour être réutilisable et puise ses informations
/// et ses actions depuis le `AppState` fourni par Provider.
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère les services et les états nécessaires via Provider.
    // On utilise 'context.read' car on n'a besoin que de lancer des fonctions,
    // pas de reconstruire ce widget lorsque l'état change (c'est le TextField
    // qui est contrôlé par l'état, pas l'AppBar elle-même).
    final GeolocationService geolocationService = GeolocationService();
    final AppState appState = context.read<AppState>();

    return Padding(
      // Padding externe pour aérer l'AppBar par rapport aux bords de l'écran.
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 16.0,
        right: 16.0,
        bottom: 10.0, // Espace avant le début du contenu principal.
      ),
      child: Container(
        // height: 150,
        // Padding interne pour le contenu de l'AppBar.
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
        decoration: BoxDecoration(
          // Utilise la couleur de surface du thème avec une transparence pour
          // un effet "verre dépoli" (frosted glass).
          color: Theme.of(
            context,
          ).colorScheme.surface.withAlpha(230), // 90% d'opacité
          borderRadius: BorderRadius.circular(15.0), // Bords bien arrondis.
          boxShadow: [
            // Ombre portée subtile pour donner de la profondeur.
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- Bouton de recherche ---
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 10),
              child: IconButton(
                onPressed: () => appState.onTapSearch(context),
                icon: const Icon(Icons.search),
                tooltip: 'Rechercher une ville', // Aide pour l'accessibilité.
              ),
            ),
            // --- Champ de texte pour la recherche ---
            Expanded(
              child: TextField(
                controller: appState.searchController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Seatch a city ...',
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(180),
                  ),
                  border: InputBorder.none, // Design épuré sans bordure.
                ),
                // Exécute la recherche quand l'utilisateur valide avec le clavier.
                onSubmitted: (value) => appState.onTapSearch(context),
              ),
            ),
            // --- Bouton de géolocalisation ---
            IconButton(
              onPressed: () => geolocationService.fetchLocation(context),
              icon: const Icon(Icons.place),
              tooltip:
                  'Utiliser ma position actuelle', // Aide pour l'accessibilité.
              iconSize: 24,
              color:
                  appState.locationButtonColor == false
                      ? Colors.black87
                      : const Color.fromARGB(255, 233, 186, 15),
            ),
          ],
        ),
      ),
    );
  }
}
