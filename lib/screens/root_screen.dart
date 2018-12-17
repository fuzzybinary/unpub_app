import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/feedback_screen.dart';
import 'package:unpub/screens/game_list_screen.dart';

enum RootScreenTab {
  Games,
  Events,
  Feedback,
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key key, this.initialTab = RootScreenTab.Games})
      : super(key: key);

  final RootScreenTab initialTab;

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(title: Text('Games'), icon: Icon(Icons.gamepad)),
    BottomNavigationBarItem(title: Text('Events'), icon: Icon(Icons.event)),
    BottomNavigationBarItem(title: Text('Feedback'), icon: Icon(Icons.feedback))
  ];
  final List<Widget> _screens = [
    GameListScreen(),
    Text('Events'),
    FeedbackScreen()
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
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _screens[0];
      case 1:
        return Center(child: _screens[1]);
      case 2:
        return _screens[2];
    }
    return Container();
  }
}
