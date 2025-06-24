import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/geolocation_service.dart';

import '../models/app_state.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final GeolocationService geolocationService = GeolocationService();
    final AppState appState = context.read<AppState>();

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withAlpha(230),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // --- Search Button ---
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 10),
              child: IconButton(
                onPressed: () => appState.onTapSearch(context),
                icon: const Icon(Icons.search),
                tooltip: 'Find a City',
              ),
            ),
            // --- Text Field ---
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
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => appState.onTapSearch(context),
              ),
            ),
            // --- Geolocalisation Button ---
            IconButton(
              onPressed: () => geolocationService.fetchLocation(context),
              icon: const Icon(Icons.place),
              tooltip: 'My Position',
              iconSize: 24,
              color:
                  appState.locationButtonColor == false
                      ? Colors.black87
                      : const Color.fromARGB(255, 72, 126, 197),
            ),
          ],
        ),
      ),
    );
  }
}
