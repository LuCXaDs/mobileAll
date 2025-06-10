import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Column(
      children: [
        Expanded(
          child: Container(
            color:
                appState.citySuggestions.isNotEmpty
                    ? Colors.grey[50]
                    : Colors.white,
            child: ListView.builder(
              itemCount: appState.citySuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = appState.citySuggestions[index];
                return ListTile(
                  title: Text(suggestion['name']),
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
        ),
      ],
    );
  }
}









  // void showSuggestionDetails(dynamic suggestion) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(suggestion['name']),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Country: ${suggestion['country']}'),
  //             Text('Region: ${suggestion['region']}'),
  //             Text('Latitude: ${suggestion['latitude']}'),
  //             Text('Longitude: ${suggestion['longitude']}'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Close'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               setState(() {
  //                 context.read<AppState>().onTapListSearch(context, suggestion);
  //               });
  //             },
  //             child: Text('Voir'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
