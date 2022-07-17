import 'package:breejstores_users_app/assisantMethods/address_change.dart';
import 'package:breejstores_users_app/assisantMethods/cart_item_counter.dart';
import 'package:breejstores_users_app/assisantMethods/total_amount.dart';
import 'package:breejstores_users_app/splashScreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Global/global.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddressChanger()),
        ChangeNotifierProvider(create: (context) => TotalAmount()),
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Users App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
