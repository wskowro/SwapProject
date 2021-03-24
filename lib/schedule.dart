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

  MySchedulePage({Key key}) : super(key: key);
  @override
  _MySchedulePageState createState() => _MySchedulePageState();
}
class _MySchedulePageState extends State<MySchedulePage> {
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