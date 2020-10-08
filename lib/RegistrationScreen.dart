import 'package:crypto_list/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  final key = new GlobalKey<ScaffoldState>();
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
                title: 'Register',
                colour: Colors.orange,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    await _auth.createUserWithEmailAndPassword(
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
                            content: new Text("bad email format"),
                          ));
                          break;
                        }
                      case "email-already-in-use":
                        {
                          setState(() {
                            _controller1.clear();
                            _controller2.clear();
                            showSpinner = false;
                            FocusScope.of(context).unfocus();
                          });
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("email already in use"),
                          ));
                          break;
                        }
                      case "weak-password":
                        {
                          setState(() {
                            _controller1.clear();
                            _controller2.clear();
                            showSpinner = false;
                            FocusScope.of(context).unfocus();
                          });
                          key.currentState.showSnackBar(new SnackBar(
                            content: new Text("password has to be at least 6 letters"),
                          ));
                          break;
                        }
                      default:
                        key.currentState.showSnackBar(new SnackBar(
                          content: new Text("Undefined error happened"),
                        ));
                        print(error);
                    }
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
