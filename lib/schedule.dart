import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'main.dart';
import 'home.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editCalender.dart';
import 'widget/loading.dart';
import 'changeRequest.dart';




class MySchedulePage extends StatefulWidget {
  final String currentUserId;

  MySchedulePage({Key key, @required this.currentUserId}) : super(key: key);

  EventCalendarState createState() => EventCalendarState(currentUserId: currentUserId);
}

List<Color> _colorCollection;
List<String> _colorNames;
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection;
DataSource _events;
Meeting _selectedAppointment;
DateTime _startDate;
TimeOfDay _startTime;
DateTime _endDate;
TimeOfDay _endTime;
bool _isAllDay;
String _subject = '';
String _notes = '';
String myName;
DateTime myStartTime;
DateTime myEndTime;
String myDescription;

class EventCalendarState extends State<MySchedulePage> {
  EventCalendarState({Key key,@required this.currentUserId});

  final String currentUserId;
  CalendarView _calendarView;
  List<String> eventNameCollection;
  List<Meeting> appointments;
  String shiftDay;
  DateTime shiftStart;
  DateTime shiftEnd;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    getData().then((appointments){
      setState(() {
        this.appointments = appointments;
      });
    });
    print(appointments);
    _events = DataSource(appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build([BuildContext context]) {
    _events = DataSource(appointments);
      return Scaffold(
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              'My Schedule',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: getEventCalendar(_calendarView, _events, onCalendarTapped)),

      );
    }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    } else {
      if (calendarTapDetails.appointments != null &&
          calendarTapDetails.appointments.length == 1) {
            final Meeting meetingDetails = calendarTapDetails.appointments[0];
            shiftDay = meetingDetails.eventName;
            shiftStart = meetingDetails.from;
            shiftEnd = meetingDetails.to;

              Navigator.push<Widget>(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChangeRequest(
                            currentUserId: currentUserId, shiftDay: shiftDay, shiftStart: shiftStart, shiftEnd: shiftEnd)),
        );
      }
      }

    }

  SfCalendar getEventCalendar(
      [CalendarView _calendarView,
        CalendarDataSource _calendarDataSource,
        CalendarTapCallback calendarTapCallback]) {
    return SfCalendar(
        view: CalendarView.week,
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        timeSlotViewSettings: TimeSlotViewSettings(
            startHour: 8,
            endHour: 20,
            minimumAppointmentDuration: const Duration(minutes: 60)));
  }


  Future<List<Meeting>> getData() async {

    List<Meeting> oldSchedule = <Meeting>[];
    final scheduleId = "cal" + currentUserId;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('schedule').doc(scheduleId).collection(scheduleId);

    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((daySchedule) {
      myName = daySchedule["eventName"];
      //print(myName);
      myStartTime = daySchedule["from"].toDate();
      //print(myStartTime);
      myEndTime = daySchedule["to"].toDate();
      //print(myEndTime);
      myDescription = daySchedule["description"];
      //print(myDescription);

      oldSchedule.add(Meeting(
        from: myStartTime,
        to: myEndTime,
        background: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
        description: myDescription,
        isAllDay: false,
        eventName: myName,
      ));
      //print(oldSchedule);
    });

    return oldSchedule;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  String getSubject(int index) => appointments[index].eventName;

  @override
  String getStartTimeZone(int index) => appointments[index].startTimeZone;

  @override
  String getNotes(int index) => appointments[index].description;

  @override
  String getEndTimeZone(int index) => appointments[index].endTimeZone;

  @override
  Color getColor(int index) => appointments[index].background;

  @override
  DateTime getStartTime(int index) => appointments[index].from;

  @override
  DateTime getEndTime(int index) => appointments[index].to;
}

class Meeting {
  Meeting(
      {@required this.from,
        @required this.to,
        this.background = Colors.blue,
        this.isAllDay = false,
        this.eventName = '',
        this.startTimeZone = '',
        this.endTimeZone = '',
        this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
