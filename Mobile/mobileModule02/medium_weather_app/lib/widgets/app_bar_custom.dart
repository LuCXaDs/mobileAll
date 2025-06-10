
// class AppBarCustom {
  
// }

// lib/widgets/custom_app_bar.dart
// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final TextEditingController controller;
//   final VoidCallback onTapSearch;
//   final Future<void> Function() onGetCurrentLocation;
//   final String locationMessage;

//   CustomAppBar({
//     required this.controller,
//     required this.onTapSearch,
//     required this.onGetCurrentLocation,
//     required this.locationMessage,
//   });

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 4, right: 10),
//             child: IconButton(
//               onPressed: onTapSearch,
//               icon: const Icon(Icons.search),
//             ),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: const InputDecoration(
//                 hintText: 'Search...',
//                 border: InputBorder.none,
//               ),
//               onSubmitted: (value) {
//                 onTapSearch();
//                 controller.clear();
//               },
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           onPressed: onGetCurrentLocation,
//           icon: const Icon(Icons.place),
//           iconSize: 24,
//           color: locationMessage.isNotEmpty
//               ? Colors.deepPurpleAccent
//               : Colors.grey,
//         ),
//       ],
//     );
//   }
// }
