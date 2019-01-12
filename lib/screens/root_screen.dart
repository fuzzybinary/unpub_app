import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/events_screen.dart';
import 'package:unpub/screens/feedback/feedback_screen.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
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

  int _currentIndex = 0;
  TabController _tabController;
  // This allows us to retain entered information on the feedback screen
  // even if you navigate away from the widget.
  final FeedbackScreenBloc _feedbackBloc = FeedbackScreenBloc();

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
          textTheme: TextTheme(caption: TextStyle(color: Colors.white54)),
        ),
        child: BottomNavigationBar(
          items: _tabs,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
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
        return EventsScreen();
      case 2:
        return FeedbackScreen(bloc: _feedbackBloc);
    }
    return Container();
  }
}
