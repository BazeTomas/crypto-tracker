import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  final key = new GlobalKey<ScaffoldState>();
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/Bitcoin.svg.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: _controller1,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _controller2,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.black,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                      Navigator.pushNamed(context, HomeScreen.id);
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (error) {
                    switch (error.code) {
                      case "invalid-email":
                        {
                          setState(() {
                            _controller1.clear();
                            _controller2.clear();
                            showSpinner = false;
                            FocusScope.of(context).unfocus();
                          });
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("incorrect email"),
                          ));
                          break;
                        }
                      case "wrong-password":
                        {
                          setState(() {
                            _controller1.clear();
                            _controller2.clear();
                            showSpinner = false;
                            FocusScope.of(context).unfocus();
                          });
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("incorrect password"),
                          ));
                          break;
                        }
                      case "user-not-found":
                        {
                          setState(() {
                            _controller1.clear();
                            _controller2.clear();
                            showSpinner = false;
                            FocusScope.of(context).unfocus();
                          });
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("User not found"),
                          ));
                          break;
                        }
                      default:
                        key.currentState.showSnackBar(new SnackBar(
                          content: new Text("Undefined error happened"),
                        ));

                    } print(error);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}