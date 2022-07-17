import 'package:breejstores_users_app/Global/global.dart';
import 'package:breejstores_users_app/assisantMethods/assistant_methods.dart';
import 'package:breejstores_users_app/widgets/order_card.dart';
import 'package:breejstores_users_app/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan,
                      Colors.amber,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  )),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "History",
              style: TextStyle(fontSize: 35, fontFamily: "Signatra"),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("orders")
                .where("status", isEqualTo: "ended")
                .orderBy("orderTime", descending: true)
                .snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("items")
                        .where("itemID",
                        whereIn: separateOrderItemIDs(
                            (snapshot.data!.docs[index].data()!
                            as Map<String, dynamic>)["productID"]))
                        .where("orderBy",
                        whereIn: (snapshot.data!.docs[index].data()!
                        as Map<String, dynamic>)["uid"])
                        .orderBy("publishedDate", descending: true)
                        .get(),
                    builder: (c, snap) {
                      return snap.hasData
                          ? OrderCard(
                        itemCount: snap.data!.docs.length,
                        data: snap.data!.docs,
                        orderID: snapshot.data!.docs[index].id,
                        separateQuantitiesList:
                        separateOrderItemQuantities(
                            (snapshot.data!.docs[index].data()!
                            as Map<String, dynamic>)["productID"]),
                      )
                          : Center(
                        child: circularProgress(),
                      );
                    },
                  );
                },
              )
                  : Center(
                child: circularProgress(),
              );
            },
          ),
        ));
  }
}
