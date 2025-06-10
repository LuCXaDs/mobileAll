import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather_App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      home: const MyHomePage(title: 'Weather_App'),
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
  final TextEditingController _controller = TextEditingController();
  final PageController _pageController = PageController();
  String _searchText = '';
  String _placeText = '';
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      debugPrint('$_selectedIndex');
      _pageController.animateToPage(
        duration: Duration(microseconds: 200),
        curve: Curves.linear,
        index,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTapPlace() {
    setState(() {
      if (_placeText.isEmpty) {
        _placeText = 'Geolocation';
      } else {
        _placeText = '';
      }
      if (_searchText.isNotEmpty) {
        _searchText = '';
      }
    });
  }

  void _onTapSearch() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _placeText = '';
        _searchText = _controller.text;
        _controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4, right: 10),
              child: IconButton(
                onPressed: _onTapSearch,
                icon: Icon(Icons.search),
              ),
            ),

            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  setState(() {
                    _searchText = value;
                    if (_placeText.isNotEmpty) {
                      _placeText = '';
                    }
                    _controller.clear();
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _onTapPlace,
            icon: Icon(Icons.place),
            iconSize: 24,
            color:
                _placeText.isNotEmpty ? Colors.deepPurpleAccent : Colors.grey,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: _onPageChanged,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text('Currently', style: TextStyle(fontSize: 36)),
                ),
                if (_searchText.isNotEmpty)
                  Flexible(
                    child: Text(_searchText, style: TextStyle(fontSize: 24)),
                  ),
                if (_placeText.isNotEmpty)
                  Flexible(
                    child: Text(_placeText, style: TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Text('Today', style: TextStyle(fontSize: 36))),
                if (_searchText.isNotEmpty)
                  Flexible(
                    child: Text(_searchText, style: TextStyle(fontSize: 24)),
                  ),
                if (_placeText.isNotEmpty)
                  Flexible(
                    child: Text(_placeText, style: TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Text('Weekly', style: TextStyle(fontSize: 36))),
                if (_searchText.isNotEmpty)
                  Flexible(
                    child: Text(_searchText, style: TextStyle(fontSize: 24)),
                  ),
                if (_placeText.isNotEmpty)
                  Flexible(
                    child: Text(_placeText, style: TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: 'Currently',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.sunny), label: 'Today'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Weekly'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepPurpleAccent,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
