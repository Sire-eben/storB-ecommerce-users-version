import 'package:breejstores_users_app/Global/global.dart';
import 'package:breejstores_users_app/Models/adverts.dart';
import 'package:breejstores_users_app/Models/merchants.dart';
import 'package:breejstores_users_app/assisantMethods/assistant_methods.dart';
import 'package:breejstores_users_app/constants/constants.dart';
import 'package:breejstores_users_app/mainScreens/products_screen.dart';
import 'package:breejstores_users_app/widgets/app_bar.dart';
import 'package:breejstores_users_app/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    "assets/slider/0.jpg",
    "assets/slider/1.jpg",
    "assets/slider/2.jpg",
    "assets/slider/3.jpg",
    "assets/slider/4.jpg",
    "assets/slider/5.jpg",
    "assets/slider/6.jpg",
    "assets/slider/7.jpg",
    "assets/slider/8.jpg",
    "assets/slider/9.jpg",
    "assets/slider/10.jpg",
    "assets/slider/11.jpg",
    "assets/slider/12.jpg",
    "assets/slider/13.jpg",
    "assets/slider/14.jpg",
    "assets/slider/15.jpg",
    "assets/slider/16.jpg",
    "assets/slider/17.jpg",
    "assets/slider/18.jpg",
    "assets/slider/19.jpg",
    "assets/slider/20.jpg",
    "assets/slider/21.jpg",
    "assets/slider/22.jpg",
    "assets/slider/23.jpg",
    "assets/slider/24.jpg",
    "assets/slider/25.jpg",
    "assets/slider/26.jpg",
    "assets/slider/27.jpg",
  ];

  @override
  void initState() {
    clearCartNow(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60), child: MyAppBar()),
        drawer: const CustomDrawer(),
        body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 75,
                  width: screenSize.width,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.cyan,
                        backgroundImage: NetworkImage(sharedPreferences!
                            .getString("photoUrl")
                            .toString()),
                      ),
                      const SizedBox(width: 20,),

                      Container(
                        height: 45,
                          width: 1,
                        color: Colors.cyan.shade300,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Container(
                        height: 45,
                        width: screenSize.width * 0.6,
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,child: Text("Search for stores...", style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold,
                        ),)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.16,
                  width: screenSize.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("adverts")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 50,
                          child: Center(
                            child: circularProgress(),
                          ),
                        );
                      }
                      if (snapshot.hasData)
                      {
                        return Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Adverts model = Adverts.fromJson(
                                  snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                              return Container(
                                margin: const EdgeInsets.only(left: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      color: Colors.grey.shade300
                                    )
                                  ]
                                ),
                                child: Image.network(model.imageUrl!, height: 100,),
                              );
                            },
                          )
                        );
                      } else{
                        return const Center(
                          child: Text("No ads available"),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.7,
                  width: screenSize.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("merchants")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          height: 50,
                          child: Center(
                            child: circularProgress(),
                          ),
                        );
                      }
                      if (snapshot.data!.docs.length == 0) {
                        return const Center(
                          child: Text("No stores available"),
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Merchants model = Merchants.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) =>
                                            ProductsScreen(model: model)));
                              },
                              splashColor: Colors.amber,
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: kDefaultPadding,
                                    horizontal: screenSize.width * 0.1),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: screenSize.width * 0.8,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                model.sellerAvatarUrl
                                                    .toString(),
                                              ))),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          model.sellerName.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        )),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          model.sellerAddress.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
