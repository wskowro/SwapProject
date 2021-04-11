import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'schedule.dart';
import 'main.dart';
import 'chat.dart';
import 'requestMailBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {

  final String currentUserId;
  MyHomePage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(currentUserId: currentUserId);
}


class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key, @required this.currentUserId});
  final _auth = FirebaseAuth.instance;
  String currentUserId;
  bool showProgress = false;
  int counter = 0;

  Future <void> getRequestCount() async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('request').doc('reqU' + currentUserId).collection('req' + currentUserId).get();
    final int documents = qSnap.docs.length;
    counter = documents;
  }

  @override
  void initState() {
    getRequestCount().then((appointments){
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swap App"),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showProgress,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Home Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
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
                      counter = 0;
                      setState(() {
                        //showProgress = true;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RequestMailBox(currentUserId: currentUserId)));
                    },
                    child: Stack(
                      children: <Widget>[
                        counter != 0 ? new Positioned(
                          right: 11,
                          top: 3,
                          child: new Container(
                            padding: EdgeInsets.all(4),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              '$counter',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ) : new Container(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.calendar_today_outlined),
                        ),
                        Align(
                          child: Text(
                            "Request",
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
                          //showProgress = true;
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
                              "Schedule",
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 310.0,
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
                        //showProgress = true;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatApp(currentUserId: currentUserId)));
                    },
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.chat),
                        ),
                        Align(
                          child: Text(
                            "Chat",
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
                      //showProgress = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyLoginPage()));
                  },
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.logout),
                      ),
                      Align(
                        child: Text(
                          "Logout",
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
                height: 15.0,
              ),

            ],
          ),
        ),
      ),
    );
  }
}