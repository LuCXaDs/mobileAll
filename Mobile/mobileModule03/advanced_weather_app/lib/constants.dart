
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Padding(
      //         padding: EdgeInsets.only(left: 4, right: 10),
      //         child: IconButton(
      //           onPressed: () {
      //             setState(() {
      //               context.read<AppState>().onTapSearch(context);
      //             });
      //           },
      //           icon: Icon(Icons.search),
      //         ),
      //       ),
      //       Expanded(
      //         child: TextField(
      //           controller: context.read<AppState>().searchController,
      //           decoration: InputDecoration(
      //             hintText: 'Search...',
      //             border: InputBorder.none,
      //           ),
      //           onSubmitted: (value) {
      //             setState(() {
      //               context.read<AppState>().onTapSearch(context);
      //             });
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         _geolocationService.fetchLocation(context);
      //       },
      //       icon: Icon(Icons.place),
      //       iconSize: 24,
      //     ),
      //   ],
      // ),