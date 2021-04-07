import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeRequest extends StatefulWidget {
  final String currentUserId;
  final String shiftDay;

  ChangeRequest({Key key, @required this.currentUserId, @required this.shiftDay}) : super(key: key);

  @override
  State createState() => ChangeRequestState(currentUserId: currentUserId, shiftDay: shiftDay);
}

class ChangeRequestState extends State<ChangeRequest> {
  ChangeRequestState({Key key, @required this.currentUserId, @required this.shiftDay});

  String currentUserId;
  String shiftDay;
  List userList = [];
  List userNames = [];
  String selectedName;
  String selectedShift;
  List swapDays;

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
    print(userList);
    print(userNames);
  }

  //Use User IDs to access user schedules in database
  void getAvailable() {
    String scheduleID;
    for (int x = 0; x < userList.length; x++) {
      scheduleID = 'cal' + userList.elementAt(x);
      FirebaseFirestore.instance.collection('schedule').doc(scheduleID)
          .collection(scheduleID).get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc["eventName"] == shiftDay) {
            userList.removeAt(x);
          }
        });
      });
    }}

    List getDates(String name) {
      String myID;
      String calID;
      List myDays;
      for (int x = 0; x < userNames.length; x++) {
        if (userNames.elementAt(x) == name) {
          myID = userList.elementAt(x);
        }
      }
      calID = 'cal' + myID;
      // Get docs from collection reference
      FirebaseFirestore.instance.collection('schedule').doc(calID).collection(
          calID).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          myDays.add(doc["eventName"]);
        });
      }
      );

      return myDays;
    }

    @override
    Widget build(BuildContext context) {
      print(userList);
      print(userNames);

      //remove own user
      for (int x = 0; x < userList.length; x++) {
        if (userList.elementAt(x) == currentUserId) {
          userList.removeAt(x);
          userNames.removeAt(x);
        }
      }

      getAvailable();

      //show list of users not working that day as buttons or dropdown
      return Scaffold(
          body: Column(
            children: <Widget>[
              DropdownButton(
                hint: Text('Who would you like to swap with'),
                value: selectedName,
                onChanged: (newValue) {
                  setState(() {
                    selectedName = newValue;
                    getDates(selectedName);
                  });
                },
                items: userNames.map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ),

              //show selected users scheduled days other then selected day and ones current user isn't already working
              selectedName != "" ? DropdownButton(
                hint: Text('What shift would you like to swap'),
                value: selectedShift,
                onChanged: (newValue) {
                  setState(() {
                    selectedShift = newValue;
                  });
                },
                items: getDates(selectedName).map((location) {
                  return DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
              ) : Container()
            ],
          )
      );
    }


    //add document containing both user IDs and both days that will be switched


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


