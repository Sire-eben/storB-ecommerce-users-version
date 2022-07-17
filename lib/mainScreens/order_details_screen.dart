import 'package:breejstores_users_app/Models/address.dart';
import 'package:breejstores_users_app/widgets/progress_bar.dart';
import 'package:breejstores_users_app/widgets/shipment_address_design.dart';
import 'package:breejstores_users_app/widgets/status_banners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Global/global.dart';
import '../constants/constants.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;

  const OrderDetailsScreen({Key? key, this.orderID}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("orders")
                .doc(widget.orderID)
                .get(),
            builder: (c, snapshot) {
              Map? dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data!.data()! as Map<String, dynamic>;
                orderStatus = dataMap["status"].toString();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(kDefaultPadding),
                            decoration: const BoxDecoration(color: Colors.cyan,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            child: orderStatus == "ended"
                                ? const Text("Order was delivered!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                                : const Text("Delivery in progress!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Total Amount: " +
                                    "N" +
                                    dataMap!["totalAmount"].toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Order Id: " + widget.orderID!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Order at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(
                                        dataMap["orderTime"],
                                      ),
                                    ),
                                  ),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 4,
                          ),
                          orderStatus == "ended"
                              ? Image.asset("assets/images/delivered.jpg")
                              : Image.asset("assets/images/state.jpg"),
                          const Divider(
                            thickness: 4,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(sharedPreferences!.getString("uid"))
                                .collection("userAddress")
                                .doc(dataMap["addressID"])
                                .get(),
                            builder: (c, snapshot) {
                              return snapshot.hasData
                                  ? ShipmentAddressDesign(
                                      model: Address.fromJson(snapshot.data!
                                          .data()! as Map<String, dynamic>),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
