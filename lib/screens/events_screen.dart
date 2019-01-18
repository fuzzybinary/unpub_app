import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:unpub/models.dart';
import 'package:unpub/screens/event_details_screen.dart';
import 'package:unpub/unpub_service.dart';

DateFormat _format = DateFormat('EEEE MMMM dd, yyyy');

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Future _initialLoadFuture;
  EventsResponse _events;

  @override
  void initState() {
    super.initState();
    _initialLoadFuture = _refreshEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialLoadFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildList();
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _refreshEvents() async {
    _events = await UnpubService().fetchEvents();
  }

  void _navigateToEvent(Event event) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event)));
  }

  Widget _buildEventItem(Event event) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _navigateToEvent(event),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.name,
              style: theme.textTheme.title,
            ),
            Text(
              _format.format(event.startDate),
              style: theme.textTheme.caption,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: _refreshEvents,
      child: ListView.separated(
        padding: EdgeInsets.only(top: 5),
        itemCount: _events.future.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = _events.future[index];
          return _buildEventItem(item);
        },
      ),
    );
  }
}
