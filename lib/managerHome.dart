import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'schedule.dart';
import 'main.dart';
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
      home: MyManagerHomePage(),
    );
  }
}
class MyManagerHomePage extends StatefulWidget {

  final String currentUserId;
  MyManagerHomePage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _MyManagerHomePageState createState() => _MyManagerHomePageState(currentUserId: currentUserId);
}
class _MyManagerHomePageState extends State<MyManagerHomePage> {
  _MyManagerHomePageState({Key key, @required this.currentUserId});
  final _auth = FirebaseAuth.instance;
  String currentUserId;
  bool showProgress = false;

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
                height: 75.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Manager Home Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child:
                FlatButton(
                  textColor: Colors.white,
                  height: 45.0,
                  color: Colors.lightBlue,
                  onPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'EMAIL',
                      )
                    ],
                  ),
                ),

              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child:
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    //Button push here later
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  color: Color(0xff01A0C7),
                  child: Text("Edit Schedule", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),

              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child:
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatApp(currentUserId: currentUserId)));
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  color: Color(0xff01A0C7),
                  child: Text("Chat", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),

              ),
              SizedBox(
                height: 20.0,
              ),
              Material(
                elevation: 5,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(32.0),
                child:
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showProgress = true;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyLoginPage()));
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  color: Color(0xff01A0C7),
                  child: Text("Logout", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
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