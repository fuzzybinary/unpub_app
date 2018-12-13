import 'package:flutter/material.dart';
import 'package:unpub/screens/events_screen.dart';
import 'package:unpub/screens/game_list_screen.dart';

import 'screens/feedback_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 46, 85, 152),
        primaryColorLight: Color.fromARGB(255, 99, 129, 201),
        primaryColorDark: Color.fromARGB(255, 00, 45, 105),
        accentColor: Color.fromARGB(255, 228, 28, 36),
        bottomAppBarColor: Color.fromARGB(255, 46, 85, 152),
      ),
      home: MyHomePage(title: 'UNPUB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(title: Text('Games'), icon: Icon(Icons.gamepad)),
    BottomNavigationBarItem(title: Text('Events'), icon: Icon(Icons.event)),
    BottomNavigationBarItem(title: Text('Feedback'), icon: Icon(Icons.feedback))
  ];
  int _currentIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Color.fromARGB(255, 46, 85, 152),
          primaryColor: Colors.white,
          textTheme: TextTheme(
            caption: TextStyle(color: Colors.white54) 
          ),
        ),
        child: BottomNavigationBar(
          items: _tabs,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return GameListScreen();
      case 1:
        return Center(
          child: EventsScreen(),
        );
      case 2:
        return FeedbackScreen();
    }
    return Container();
  }
}
