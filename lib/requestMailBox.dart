import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget/loading.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart' hide MyApp;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'managerHome.dart' hide MyApp;

class RequestMailBox extends StatefulWidget {
  final String currentUserId;

  RequestMailBox({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => RequestMailBoxState(currentUserId: currentUserId);
}

class RequestMailBoxState extends State<RequestMailBox> {
  RequestMailBoxState({Key key, @required this.currentUserId});

  String currentUserId;
  String docRef;

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  bool showProgress = false;

  @override
  void initState() {
    super.initState();

    listScrollController.addListener(scrollListener);
  }





  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }


  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.swapApp' : 'com.duytq.swapApp',
      'Swap App',
      'Swap App chat channel',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));


//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: Colors.blue,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Go back to home screen?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.lightBlue,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        if (currentUserId == 'EPJBgIzeSDNAfnSxXBqIZSR6foC2') {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  MyManagerHomePage(currentUserId: currentUserId)));
        }
        else
        {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  MyHomePage(currentUserId: currentUserId)));
        }
        break;
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();


    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swap Request"),
        actions: <Widget>[
          // Using Stack to show Notification Badge
          new Stack(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.home), onPressed: () {
                setState(() {

                });
                if (currentUserId == 'EPJBgIzeSDNAfnSxXBqIZSR6foC2') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyManagerHomePage(currentUserId: currentUserId)));
                }
                else
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyHomePage(currentUserId: currentUserId)));
                }
              }),
            ],
          ),
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('request').doc('reqU' + currentUserId).collection('req' + currentUserId).limit(_limit).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      controller: listScrollController,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(

              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Name: ${document.data()['reqName']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Wants to switch your ${document.data()['eventName']} for their ${document.data()['reqEventName']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            docRef = document.reference.id;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequestMailBoxChoice(
                      currentUserId: currentUserId,
                      docRef: docRef
                    )));
          },
          color: Colors.lightBlue,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class RequestMailBoxChoice extends StatefulWidget {
  final String currentUserId;
  final String docRef;


  RequestMailBoxChoice({Key key, @required this.currentUserId, @required this.docRef}) : super(key: key);

  @override
  State createState() => RequestMailBoxChoiceState(currentUserId: currentUserId, docRef: docRef);
}

class RequestMailBoxChoiceState extends State<RequestMailBoxChoice> {
  RequestMailBoxChoiceState(
      {Key key, @required this.currentUserId, @required this.docRef});

  String currentUserId;
  String docRef;
  String shiftDay;
  String userName;
  String myName;
  String pickedName;
  String selectedID;
  String selectedDay;
  DateTime selectedStart;
  DateTime selectedEnd;
  DateTime shiftStart;
  DateTime shiftEnd;

  void initState() {
    getRequestData().then((myUsers){
      setState(() {
      });
    });
  }

  Future <void> getRequestData() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance.collection('request').doc('reqU' + currentUserId).collection('req' + currentUserId).doc(docRef)
        .get();
    myName = variable['myName'];
    shiftDay = variable['eventName'];
    shiftStart = variable['from'].toDate();
    shiftEnd = variable['to'].toDate();
    userName = variable['reqName'];
    selectedID = variable['reqID'];
    selectedDay = variable['reqEventName'];
    selectedStart = variable['reqFrom'].toDate();
    selectedEnd = variable['reqTo'].toDate();
  }

  @override
  Widget build(BuildContext context) {
    print(myName);
    print(shiftStart);
    print(shiftEnd);
    print(userName);
    print(selectedID);
    print(selectedDay);
    print(selectedStart);
    print(selectedEnd);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shift Swap Request"),
        actions: <Widget>[
          // Using Stack to show Notification Badge
          new Stack(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.home), onPressed: () {

                if (currentUserId == 'EPJBgIzeSDNAfnSxXBqIZSR6foC2') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyManagerHomePage(currentUserId: currentUserId)));
                }
                else
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          MyHomePage(currentUserId: currentUserId)));
                }
              }),
            ],
          ),
        ],
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text(
            "Your Shift",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0, color: Colors.blue),
          ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Day: " + shiftDay,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              Text(
                "Start time: " + DateFormat.Hm().format(shiftStart),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              Text(
                "End time: " + DateFormat.Hm().format(shiftEnd),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Their Shift",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 40.0, color: Colors.blue),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Day: " + selectedDay,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              Text(
                "Start time: " + DateFormat.Hm().format(selectedStart),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              Text(
                "End time: " + DateFormat.Hm().format(selectedEnd),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
          SizedBox(
            height: 20.0,
          ),
              SizedBox(
                height: 80.0,
              ),

          Container(
            width: 310,
            child:
            Material(
              elevation: 5,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(7.0),
              child:
              FlatButton(
                textColor: Colors.white,
                height: 15.0,
                color: Colors.lightBlue,
                onPressed: () async {
                  setState(() {
                  });

                  FirebaseFirestore.instance.collection('request').doc('reqUEPJBgIzeSDNAfnSxXBqIZSR6foC2').collection('reqEPJBgIzeSDNAfnSxXBqIZSR6foC2').doc().set({
                    'reqName': myName,
                    'reqID': currentUserId,
                    'reqEventName': shiftDay,
                    'reqFrom': shiftStart,
                    'reqTo': shiftEnd,
                    'myName': userName,
                    'myID': selectedID,
                    'eventName': selectedDay,
                    'from': selectedStart,
                    'to': selectedEnd

                  });

                  FirebaseFirestore.instance.collection('request').doc('reqU' + currentUserId).collection('req'+currentUserId).doc(docRef).delete();

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(currentUserId: currentUserId)));
                },
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.calendar_today_outlined),
                    ),
                    Align(
                      child: Text(
                        "Accept",
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),

          Container(
            width: 310,
            child:
            Material(
              elevation: 5,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(7.0),
              child:
              FlatButton(
                textColor: Colors.white,
                height: 15.0,
                color: Colors.lightBlue,
                onPressed: () async {
                  setState(() {
                  });

                  FirebaseFirestore.instance.collection('request').doc('reqU'+currentUserId).collection('req'+ currentUserId).doc(docRef).delete();

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(currentUserId: currentUserId)));
                },
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.calendar_today_outlined),
                    ),
                    Align(
                      child: Text(
                        "Deny",
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ])
      )
    );
  }
}






//Query database to see if any request documents exist

//if documents exists then show them as buttons

//when button is selected give user option to accept or deny request

//if deny then delete request

//if accepted move document to manager request collection

/////////////////////////////////////////////////// New Page

//Query database to see if any manger requests exist

//if so list them as buttons

//when clicked give two options, approve or deny

//if denied then delete request

//if accepted then use both given user ids and the given dates and times to swap schedules


