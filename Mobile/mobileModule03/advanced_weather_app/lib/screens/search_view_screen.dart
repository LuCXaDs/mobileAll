import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';

import '../models/app_state.dart';

class SearchViewScreen extends StatefulWidget {
  const SearchViewScreen({super.key, required this.myHomePageContext});

  final BuildContext myHomePageContext;

  @override
  State<SearchViewScreen> createState() => SearchViewScreenState();
}

class SearchViewScreenState extends State<SearchViewScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withAlpha((0.95 * 255).round()),
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  appState.citySuggestions.length > 5
                      ? 5
                      : appState.citySuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = appState.citySuggestions[index];
                return ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CountryFlag.fromCountryCode(
                        suggestion['code'],
                        height: 16,
                        width: 16,
                        shape: const RoundedRectangle(20),
                      ),
                      SizedBox(width: 8),
                      Text(
                        suggestion['name'],
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    '${suggestion['country']}, ${suggestion['region']}',
                  ),
                  trailing: Text(
                    'Lat: ${suggestion['latitude']}, Lon: ${suggestion['longitude']}',
                  ),
                  onTap: () {
                    context.read<AppState>().onTapListSearch(
                      widget.myHomePageContext,
                      suggestion,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
