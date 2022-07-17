import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration:  const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                  begin: FractionalOffset(0,0),
                  end: FractionalOffset(1,0),
                  stops: [0,1],
                  tileMode: TileMode.clamp
                ),
              ),
            ),
            title: const Text(
              "breejStores",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: "Lobster",
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(tabs:[
              Tab(icon: Icon(Icons.lock, color: Colors.white,), text: "Login",),
              Tab(icon: Icon(Icons.person, color: Colors.white,), text: "Register",)
            ],
            indicatorColor: Colors.white38,
              indicatorWeight: 3,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.amber,
                  Colors.cyan
                ]
              )
            ),
            child: const TabBarView(
                children: [
              LoginScreen(),
              RegisterScreen()
            ],
            ),
          ),
        ),
    );
  }
}
