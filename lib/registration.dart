import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'main.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwapApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyRegistrationPage(),
    );
  }
}
class MyRegistrationPage extends StatefulWidget {
  @override
  _MyRegistrationPageState createState() => _MyRegistrationPageState();
}
class _MyRegistrationPageState extends State<MyRegistrationPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password, userName;
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
                "Registration Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userName = value; //get the value entered by user.
                },
                decoration: InputDecoration(
                    hintText: "Enter your username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
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
                    try {
                      final newuser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      User myUser = newuser.user;
                      myUser.updateProfile(displayName: userName);

                      FirebaseFirestore.instance.collection('users').doc().set({
                        'name': userName,
                        'id': myUser.uid,
                        'email': myUser.email,
                      });


                      if (newuser != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLoginPage()),
                        );
                        setState(() {
                          showProgress = false;
                        });
                      }
                    } catch (e) {}
                  },
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    color: Color(0xff01A0C7),
                    child: Text("Register", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
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