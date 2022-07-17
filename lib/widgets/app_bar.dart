import 'package:flutter/material.dart';
import '../Global/global.dart';

class MyAppBar extends StatefulWidget {
  final String? sellerUID;
  const MyAppBar({Key? key, this.sellerUID}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
      ),
      title: Text(
        sharedPreferences!.getString("name")!,
      ),
      centerTitle: true,
    );
  }
}
