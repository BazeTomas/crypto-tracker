import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'RegistrationScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;


  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/Bitcoin.svg.png'),
                    height: 80.0,
                  ),
                ),
                ColorizeAnimatedTextKit(
                  text: [" Currency \n Tracker",],
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                speed: Duration(milliseconds: 400),
                repeatForever: true,
                colors:
                [ Colors.black,
                  Colors.orange,
                  Colors.yellow,
                  Colors.red,
                  ],

                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional.topStart,
                ),
              ],
            ),
            SizedBox(
              height: 60.0,

            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.orange,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
