import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registration.dart';
import 'home.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swap App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(),
    );
  }
}
class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}
class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
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
                height: 225.0,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Login Page",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 310.0,
                child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value; // get value from TextField
                },
                decoration: InputDecoration(
                    hintText: "Enter your Email",
                    prefixIcon: Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)))),
              ),
          ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 310.0,
                child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value; //get value from textField
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)))),

                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: 310.0,
                child: Material(
                  elevation: 5,
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(7.0),
                  child: MaterialButton(
                    onPressed: () async {
                      setState(() {
                        showProgress = true;
                      });
                      try {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        print(newUser.toString());
                        if (newUser != null) {
                          Fluttertoast.showToast(
                              msg: "Login Successful",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            showProgress = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()));
                        }
                      } catch (e) {

                      }
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    color: Color(0xff01A0C7),
                    child: Text("Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyRegistrationPage()),
                  );
                },
                child: Text(
                  "Not Signed up? Register Now",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}