import 'package:breejstores_users_app/mainScreens/address_screen.dart';
import 'package:breejstores_users_app/mainScreens/history_screen.dart';
import 'package:breejstores_users_app/mainScreens/home_screen.dart';
import 'package:breejstores_users_app/mainScreens/my_orders_screen.dart';
import 'package:breejstores_users_app/mainScreens/search_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../Global/global.dart';
import '../authentication/auth_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              color: Colors.cyan,
              child: InkWell(
                onTap: () {},
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: 24 + MediaQuery.of(context).padding.top,
                      bottom: 24,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              sharedPreferences!.getString("photoUrl")!),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          sharedPreferences!.getString("name")!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        Text(sharedPreferences!.getString("email")!,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14)),
                      ],
                    )),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                runSpacing: 12,
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const HomeScreen()));
                    },
                    leading: const Icon(EvaIcons.home),
                    title: const Text('Home'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const MyOrdersScreen()));
                    },
                    leading: Icon(EvaIcons.list),
                    title: Text('My Orders'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const HistoryScreen()));
                    },
                    leading: const Icon(Icons.access_time),
                    title: const Text('History'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const SearchScreen()));
                    },
                    leading: const Icon(EvaIcons.search),
                    title: const Text('Search'),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const AddressScreen()));
                    },
                    leading: const Icon(Icons.add_location),
                    title: const Text('Add new address'),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(EvaIcons.file),
                    title: const Text('Terms of use'),
                  ),
                  // ListTile(
                  //   onTap: (){},
                  //   leading: const Icon(EvaIcons.shield),
                  //   title: const Text('Privacy Policy'),
                  // ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.help_center),
                    title: const Text('Help Center'),
                  ),
                  ListTile(
                    onTap: () {
                      firebaseAuth.signOut().then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const AuthScreen()));
                      });
                    },
                    leading: const Icon(
                      EvaIcons.logOut,
                      color: Colors.cyan,
                    ),
                    title: const Text('Sign Out'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
