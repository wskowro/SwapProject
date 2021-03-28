import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'main.dart';
import 'home.dart';
import 'chat.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySchedulePage(),
    );
  }
}

class MySchedulePage extends StatefulWidget {
  final String currentUserId;

  MySchedulePage({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _MySchedulePageState createState() => _MySchedulePageState(currentUserId: currentUserId);
}
class _MySchedulePageState extends State<MySchedulePage> {
  _MySchedulePageState({Key key, @required this.currentUserId});
  final _auth = FirebaseAuth.instance;
  String currentUserId;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SfCalendar(
              view: CalendarView.week,
            ),
          )
        ),
      )
    );
  }

}