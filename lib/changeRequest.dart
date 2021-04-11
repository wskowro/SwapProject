import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'schedule.dart';

class ChangeRequest extends StatefulWidget {
  final String currentUserId;
  final String shiftDay;
  final DateTime shiftStart;
  final DateTime shiftEnd;

  ChangeRequest({Key key, @required this.currentUserId, @required this.shiftDay, @required this.shiftStart, @required this.shiftEnd}) : super(key: key);

  @override
  State createState() => ChangeRequestState(currentUserId: currentUserId, shiftDay: shiftDay, shiftStart: shiftStart, shiftEnd: shiftEnd);
}

class ChangeRequestState extends State<ChangeRequest> {
  ChangeRequestState({Key key, @required this.currentUserId, @required this.shiftDay, @required this.shiftStart, @required this.shiftEnd});

  String currentUserId;
  String shiftDay;
  List userList = [];
  List userNames = [];
  String selectedName;
  String selectedShift;
  List swapDays;
  String myName;
  int index;
  String selectedID;
  DateTime shiftStart;
  DateTime shiftEnd;

  void initState() {
    getUsers().then((myUsers){
      setState(() {
      });
    });

    super.initState();
  }

  //Retrieve list of user IDs
  Future<void> getUsers() async {
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allUsers = querySnapshot.docs.map((doc) => doc.data()).toList();
    allUsers.forEach((users)
        {
          userList.add(users['id']);
          userNames.add(users['name']);
        });
    //print(userList);
    //print(userNames);
  }

  //Use User IDs to access user schedules in database
  Future <void> getAvailable() async {
    String scheduleID;
    print('1');
    for (int x = 0; x < userList.length; x++) {
      print('2');
      scheduleID = 'cal' + userList.elementAt(x);
      CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('schedule').doc(scheduleID).collection(scheduleID);
      QuerySnapshot querySnapshot2 = await _collectionRef.get();
      final allUsers = querySnapshot2.docs.map((doc) => doc.data()).toList();
      allUsers.forEach((users)
      {
        print('3');
        if (users["eventName"] == shiftDay) {
          print('4');
          print(userList.elementAt(x));
          userList.removeAt(x);
          print(userNames.elementAt(x));
          userNames.removeAt(x);
        }
      });
    }
    }


    @override
    Widget build(BuildContext context) {
      //print(userList);
      //print(userNames);

      //remove own user
      for (int x = 0; x < userList.length; x++) {
        if (userList.elementAt(x) == currentUserId) {
          userList.removeAt(x);
          myName = userNames.elementAt(x);
          userNames.removeAt(x);
        }
      }

      getAvailable().then((hold){
        setState(() {
        });
      });



      //print(userList);
      //print(userNames);
      //print('test1');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 250, bottom: 30),
              ),

              DropdownButton<String>(
                value: selectedName,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 40,
                elevation: 50,
                style: TextStyle(color: Colors.blue, fontSize: 30),
                underline: Container(
                  height: 2,
                  color: Colors.black,
                ),
                onChanged: (String data) {
                  setState(() {
                    selectedName = data;

                    selectedID = userList.elementAt(userNames.indexOf(data));
                    print(selectedName);
                    print(selectedID);
                  });
                },
                items: userNames.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              Padding(
                  padding: EdgeInsets.only(top: 200, bottom: 30),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeRequestSecond(currentUserId: currentUserId, shiftDay: shiftDay, userName: selectedName, myName: myName, selectedID: selectedID, shiftStart: shiftStart, shiftEnd: shiftEnd)));
                },
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.calendar_today_outlined),
                    ),
                    Align(
                      child: Text(
                        "Submit",
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

            ]),
          ),
        ),
      );
    }









    /////////////////////////////////////////////////// New Page

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


}


class ChangeRequestSecond extends StatefulWidget {
  final String currentUserId;
  final String shiftDay;
  final String userName;
  final String myName;
  final String selectedID;
  final DateTime shiftStart;
  final DateTime shiftEnd;

  ChangeRequestSecond({Key key, @required this.currentUserId, @required this.shiftDay, @required this.userName, @required this.myName, @required this.selectedID, @required this.shiftStart, @required this.shiftEnd}) : super(key: key);

  @override
  State createState() => ChangeRequestSecondState(currentUserId: currentUserId, shiftDay: shiftDay, userName: userName, myName: myName, selectedID: selectedID, shiftStart: shiftStart, shiftEnd: shiftEnd);
}

class ChangeRequestSecondState extends State<ChangeRequestSecond> {
  ChangeRequestSecondState(
      {Key key, @required this.currentUserId, @required this.shiftDay, @required this.userName, @required this.myName, @required this.selectedID, @required this.shiftStart, @required this.shiftEnd});

  String currentUserId;
  String shiftDay;
  String userName;
  String myName;
  List userList = [];
  List userListEdited = [];
  List userDays = [];
  List userDayStart = [];
  List userDayEnd = [];
  String pickedName;
  String pickedDay;
  List swapDays;
  String selectedID;
  String selectedDay;
  DateTime selectedStart;
  DateTime selectedEnd;
  DateTime shiftStart;
  DateTime shiftEnd;

  void initState() {
    getDates(pickedName).then((myUsers){
      setState(() {
     });
    });
    super.initState();
  }

  Future <List> getDates(String name) async {
    String calID;
    List myDays;

    calID = 'cal' + selectedID;
    // Get docs from collection reference
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('schedule').doc(calID).collection(calID);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allUsers = querySnapshot.docs.map((doc) => doc.data()).toList();
    allUsers.forEach((users)
    {
        userDays.add(users["eventName"]);

        userDayStart.add(users["from"].toDate());

        userDayEnd.add(users["to"].toDate());

      });

    return myDays;
  }

  Future <void> checkDates() async {
    String calID;
    List myDays;

    calID = 'cal' + currentUserId;
    // Get docs from collection reference
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection('schedule').doc(calID).collection(calID);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allUsers = querySnapshot.docs.map((doc) => doc.data()).toList();
    allUsers.forEach((users)
    {
      for (int x = 0; x < userDays.length; x++)
        {
          if (userDays.elementAt(x)==users["eventName"])
            {
              userDays.removeAt(x);
            }
        }

    }
    );
  }

  //show selected users scheduled days other then selected day and ones current user isn't already working
  @override
  Widget build(BuildContext context) {


    for (int x = 0; x < userDays.length; x++)
      {
        if (userDays.elementAt(x) == shiftDay)
          {
            userDays.removeAt(x);
          }
      }

    checkDates().then((myUsers){
      setState(() {
      });
    });


    return Scaffold(
      body: Center(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 250, bottom: 30),
          ),

          DropdownButton<String>(
            value: pickedDay,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 40,
            elevation: 50,
            style: TextStyle(color: Colors.blue, fontSize: 30),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String data) {
              setState(() {
                pickedDay = data;
                selectedStart = userDayStart.elementAt(userDays.indexOf(data));
                selectedEnd = userDayEnd.elementAt(userDays.indexOf(data));
              });
            },
            items: userDays.map((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          Padding(
            padding: EdgeInsets.only(top: 200, bottom: 30),
          ),

          //add document containing both user IDs and both days that will be switched
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
              FirebaseFirestore.instance.collection('request').doc('reqU'+selectedID).collection('req'+selectedID).doc().set({
                'reqName': myName,
                'reqID': currentUserId,
                'reqEventName': shiftDay,
                'reqFrom': shiftStart,
                'reqTo': shiftEnd,
                'myName': userName,
                'myID': selectedID,
                'eventName': pickedDay,
                'from': selectedStart,
                'to': selectedEnd

              });
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MySchedulePage(currentUserId: currentUserId)));
            },
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.calendar_today_outlined),
                ),
                Align(
                  child: Text(
                    "Submit",
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

        ]),
      ),
    );
  }
}



