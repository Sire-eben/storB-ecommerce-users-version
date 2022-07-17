import 'dart:async';

import 'package:flutter/material.dart';
import '../Global/global.dart';
import '../authentication/auth_screen.dart';
import '../mainScreens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber,
              Colors.cyan,
            ],
            begin: FractionalOffset(0,0),
            end:  FractionalOffset((1), 0),
            stops: [0,1],
            tileMode: TileMode.clamp
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/welcome.png'),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Buy everything you need Online',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
