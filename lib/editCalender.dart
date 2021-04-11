library event_calendar;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

part 'color-picker.dart';

part 'timezone-picker.dart';

part 'appointment-editor.dart';


class EditCalender extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;
  final String peerName;

  EditCalender({Key key, @required this.peerId, @required this.peerAvatar, @required this.currentUserId, @required this.peerName}) : super(key: key);

  EventCalendarState createState() => EventCalendarState(peerId: peerId, peerAvatar: peerAvatar, currentUserId: currentUserId, peerName: peerName);
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

class EventCalendarState extends State<EditCalender> {
  EventCalendarState({Key key, @required this.peerId, @required this.peerAvatar,  @required this.currentUserId, @required this.peerName});

  final String peerId;
  final String peerAvatar;
  final String currentUserId;
  final String peerName;
  CalendarView _calendarView;
  List<String> eventNameCollection;
  List<Meeting> appointments;

  @override
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
        //: false,
        appBar: AppBar(
          title: Text(
            peerName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            // Using Stack to show Notification Badge
            new Stack(
              children: <Widget>[
                new IconButton(icon: Icon(Icons.home), onPressed: () {
                  setState(() {

                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(currentUserId: currentUserId)));
                }),
              ],
            ),
          ],
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: getEventCalendar(_calendarView, _events, onCalendarTapped)));
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


  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      if (_calendarView == CalendarView.month) {
        _calendarView = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments[0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _selectedColorIndex = 0;
          _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
              ? 0
              : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
          _subject = meetingDetails.eventName == '(No title)'
              ? ''
              : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
          //deleteData(meetingDetails.eventName);

        } else {
          final DateTime date = calendarTapDetails.date;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime =
            TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AppointmentEditor(currentUserId: currentUserId, peerId: peerId, peerAvatar: peerAvatar, peerName: peerName)),
        );
      }
    });
  }

  Future<void> deleteData(String dayName) async {
    final scheduleId = "cal" + peerId;
    FirebaseFirestore.instance
        .collection("schedule").doc(scheduleId).collection(scheduleId)
        .where("eventName", isEqualTo: dayName)
        .get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance.collection("schedule").doc(scheduleId)
            .collection(scheduleId).doc(element.id).delete()
            .then((value) {
        });
      });
    });
  }

  Future<List<Meeting>> getData() async {

    List<Meeting> oldSchedule = <Meeting>[];
    final scheduleId = "cal" + peerId;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('schedule').doc(scheduleId).collection(scheduleId);
    String myName;
    DateTime myStartTime;
    DateTime myEndTime;
    String myDescription;
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

  List<Meeting> getMeetingDetails() {
    final List<Meeting> meetingCollection = <Meeting>[];
    eventNameCollection = <String>[];


    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    _colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');
    _timeZoneCollection.add('AUS Central Standard Time');
    _timeZoneCollection.add('AUS Eastern Standard Time');
    _timeZoneCollection.add('Afghanistan Standard Time');
    _timeZoneCollection.add('Alaskan Standard Time');
    _timeZoneCollection.add('Arab Standard Time');
    _timeZoneCollection.add('Arabian Standard Time');
    _timeZoneCollection.add('Arabic Standard Time');
    _timeZoneCollection.add('Argentina Standard Time');
    _timeZoneCollection.add('Atlantic Standard Time');
    _timeZoneCollection.add('Azerbaijan Standard Time');
    _timeZoneCollection.add('Azores Standard Time');
    _timeZoneCollection.add('Bahia Standard Time');
    _timeZoneCollection.add('Bangladesh Standard Time');
    _timeZoneCollection.add('Belarus Standard Time');
    _timeZoneCollection.add('Canada Central Standard Time');
    _timeZoneCollection.add('Cape Verde Standard Time');
    _timeZoneCollection.add('Caucasus Standard Time');
    _timeZoneCollection.add('Cen. Australia Standard Time');
    _timeZoneCollection.add('Central America Standard Time');
    _timeZoneCollection.add('Central Asia Standard Time');
    _timeZoneCollection.add('Central Brazilian Standard Time');
    _timeZoneCollection.add('Central Europe Standard Time');
    _timeZoneCollection.add('Central European Standard Time');
    _timeZoneCollection.add('Central Pacific Standard Time');
    _timeZoneCollection.add('Central Standard Time');
    _timeZoneCollection.add('China Standard Time');
    _timeZoneCollection.add('Dateline Standard Time');
    _timeZoneCollection.add('E. Africa Standard Time');
    _timeZoneCollection.add('E. Australia Standard Time');
    _timeZoneCollection.add('E. South America Standard Time');
    _timeZoneCollection.add('Eastern Standard Time');
    _timeZoneCollection.add('Egypt Standard Time');
    _timeZoneCollection.add('Ekaterinburg Standard Time');
    _timeZoneCollection.add('FLE Standard Time');
    _timeZoneCollection.add('Fiji Standard Time');
    _timeZoneCollection.add('GMT Standard Time');
    _timeZoneCollection.add('GTB Standard Time');
    _timeZoneCollection.add('Georgian Standard Time');
    _timeZoneCollection.add('Greenland Standard Time');
    _timeZoneCollection.add('Greenwich Standard Time');
    _timeZoneCollection.add('Hawaiian Standard Time');
    _timeZoneCollection.add('India Standard Time');
    _timeZoneCollection.add('Iran Standard Time');
    _timeZoneCollection.add('Israel Standard Time');
    _timeZoneCollection.add('Jordan Standard Time');
    _timeZoneCollection.add('Kaliningrad Standard Time');
    _timeZoneCollection.add('Korea Standard Time');
    _timeZoneCollection.add('Libya Standard Time');
    _timeZoneCollection.add('Line Islands Standard Time');
    _timeZoneCollection.add('Magadan Standard Time');
    _timeZoneCollection.add('Mauritius Standard Time');
    _timeZoneCollection.add('Middle East Standard Time');
    _timeZoneCollection.add('Montevideo Standard Time');
    _timeZoneCollection.add('Morocco Standard Time');
    _timeZoneCollection.add('Mountain Standard Time');
    _timeZoneCollection.add('Mountain Standard Time (Mexico)');
    _timeZoneCollection.add('Myanmar Standard Time');
    _timeZoneCollection.add('N. Central Asia Standard Time');
    _timeZoneCollection.add('Namibia Standard Time');
    _timeZoneCollection.add('Nepal Standard Time');
    _timeZoneCollection.add('New Zealand Standard Time');
    _timeZoneCollection.add('Newfoundland Standard Time');
    _timeZoneCollection.add('North Asia East Standard Time');
    _timeZoneCollection.add('North Asia Standard Time');
    _timeZoneCollection.add('Pacific SA Standard Time');
    _timeZoneCollection.add('Pacific Standard Time');
    _timeZoneCollection.add('Pacific Standard Time (Mexico)');
    _timeZoneCollection.add('Pakistan Standard Time');
    _timeZoneCollection.add('Paraguay Standard Time');
    _timeZoneCollection.add('Romance Standard Time');
    _timeZoneCollection.add('Russia Time Zone 10');
    _timeZoneCollection.add('Russia Time Zone 11');
    _timeZoneCollection.add('Russia Time Zone 3');
    _timeZoneCollection.add('Russian Standard Time');
    _timeZoneCollection.add('SA Eastern Standard Time');
    _timeZoneCollection.add('SA Pacific Standard Time');
    _timeZoneCollection.add('SA Western Standard Time');
    _timeZoneCollection.add('SE Asia Standard Time');
    _timeZoneCollection.add('Samoa Standard Time');
    _timeZoneCollection.add('Singapore Standard Time');
    _timeZoneCollection.add('South Africa Standard Time');
    _timeZoneCollection.add('Sri Lanka Standard Time');
    _timeZoneCollection.add('Syria Standard Time');
    _timeZoneCollection.add('Taipei Standard Time');
    _timeZoneCollection.add('Tasmania Standard Time');
    _timeZoneCollection.add('Tokyo Standard Time');
    _timeZoneCollection.add('Tonga Standard Time');
    _timeZoneCollection.add('Turkey Standard Time');
    _timeZoneCollection.add('US Eastern Standard Time');
    _timeZoneCollection.add('US Mountain Standard Time');
    _timeZoneCollection.add('UTC');
    _timeZoneCollection.add('UTC+12');
    _timeZoneCollection.add('UTC-02');
    _timeZoneCollection.add('UTC-11');
    _timeZoneCollection.add('Ulaanbaatar Standard Time');
    _timeZoneCollection.add('Venezuela Standard Time');
    _timeZoneCollection.add('Vladivostok Standard Time');
    _timeZoneCollection.add('W. Australia Standard Time');
    _timeZoneCollection.add('W. Central Africa Standard Time');
    _timeZoneCollection.add('W. Europe Standard Time');
    _timeZoneCollection.add('West Asia Standard Time');
    _timeZoneCollection.add('West Pacific Standard Time');
    _timeZoneCollection.add('Yakutsk Standard Time');

    final DateTime today = DateTime.now();
    final Random random = Random();

    return meetingCollection;
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
