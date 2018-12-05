import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: _buildFirstPage(context));
  }

  Widget _buildFirstPage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Players',
                  icon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Game Time',
                    hintText: 'in minutes',
                    icon: Icon(Icons.timer)),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First place score',
                  icon: Icon(Icons.timeline),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last place score',
                  icon: Icon(Icons.timeline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
