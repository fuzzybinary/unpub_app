import 'package:flutter/material.dart';
import 'package:unpub/screens/feedback/simple_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String NameKey = 'feedback_name';
const String EmailKey = 'feedback_email';

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final FocusNode focusName = FocusNode();
  final FocusNode focusEmail = FocusNode();

  Future<void> _fetchPreferencesFuture;

  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchPreferencesFuture = _fetchPreferences();
  }

  @override
  void dispose() {
    _savePreferences(_name, _email);
    super.dispose();
  }

  Future<void> _fetchPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        _name = prefs.getString(NameKey);
        _email = prefs.getString(EmailKey);
      } catch (Exception) {
        //ignore: empty_catch
      }
    });
  }

  Future<void> _savePreferences(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(NameKey, _name);
    prefs.setString(EmailKey, _email);
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    return Form(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Email Settings', style: theme.textTheme.headline),
            Container(
              decoration:
                  BoxDecoration(border: Border(top: BorderSide(width: 1))),
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    'Use these settings to save your name and email for the feedback you send to designers',
                    style: theme.textTheme.body1,
                  ),
                  SimpleTextField(
                    value: _name,
                    label: 'Name',
                    icon: Icon(Icons.person),
                    focus: focusName,
                    nextFocus: focusEmail,
                    onChanged: (value) {
                      _name = value;
                    },
                  ),
                  SimpleTextField(
                    value: _email,
                    label: 'Email',
                    icon: Icon(Icons.email),
                    focus: focusEmail,
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPreferencesFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _buildBody();
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
