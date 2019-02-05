import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unpub/screens/email_screen.dart';
import 'package:unpub/screens/events_screen.dart';
import 'package:unpub/screens/feedback/confirm_dialog.dart';
import 'package:unpub/screens/feedback/feedback_screen_bloc.dart';
import 'package:unpub/screens/feedback/feedback_widget.dart';
import 'package:unpub/screens/game_details_screen.dart';
import 'package:unpub/screens/game_list.dart';
import 'package:unpub/screens/game_search_bar.dart';
import 'package:unpub/unpub_service.dart';

enum RootScreenTab {
  Games,
  Events,
  Feedback,
}

class RootScreen extends StatefulWidget {
  final RootScreenTab initialTab;
  final UnpubService service;

  const RootScreen({
    Key key,
    this.initialTab = RootScreenTab.Games,
    @required this.service,
  }) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  final List<BottomNavigationBarItem> _tabs = [
    BottomNavigationBarItem(title: Text('Games'), icon: Icon(Icons.gamepad)),
    BottomNavigationBarItem(title: Text('Events'), icon: Icon(Icons.event)),
    BottomNavigationBarItem(
        title: Text('Feedback'), icon: Icon(Icons.feedback)),
    BottomNavigationBarItem(title: Text('Settings'), icon: Icon(Icons.email)),
  ];

  int _currentIndex = 0;
  TabController _tabController;
  UnpubService _service;
  // This allows us to retain entered information on the feedback screen
  // even if you navigate away from the widget.
  FeedbackScreenBloc _feedbackBloc;

  String _gameSearchString = '';

  @override
  void initState() {
    super.initState();
    _service = UnpubService();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _feedbackBloc = FeedbackScreenBloc(service: _service);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _tabs[_currentIndex];
    Widget searchWidget;
    List<Widget> actions;
    if (_currentIndex == 0) {
      searchWidget = PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: GameSearchBar(onTextChanged: (text) {
          setState(() {
            _gameSearchString = text;
          });
        }),
      );
    } else if (_currentIndex == 2) {
      actions = [
        IconButton(
          icon: Icon(Icons.clear_all),
          onPressed: () => _clearFeedback(),
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: currentTab.title,
        bottom: searchWidget,
        actions: actions,
      ),
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
        return GameList(
          filter: _gameSearchString,
          service: widget.service,
          gameSelected: (game) => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GameDetailsScreen(
                      game: game,
                      service: widget.service,
                    ),
              )),
        );
      case 1:
        return EventsScreen(
          service: widget.service,
        );
      case 2:
        return FeedbackWidget(
          bloc: _feedbackBloc,
          service: widget.service,
        );
      case 3:
        return EmailScreen();
    }
    return Container();
  }

  Future<void> _clearFeedback() async {
    final shouldClear = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
            text: 'Are you sure you want to clear this feedback form?',
          ),
    );
    if (shouldClear != null && shouldClear) {
      setState(() {
        _feedbackBloc.reset();
      });
    }
  }
}
