import 'package:breejstores_users_app/Global/global.dart';
import 'package:breejstores_users_app/Models/address.dart';
import 'package:breejstores_users_app/assisantMethods/address_change.dart';
import 'package:breejstores_users_app/constants/constants.dart';
import 'package:breejstores_users_app/mainScreens/save_address_screen.dart';
import 'package:breejstores_users_app/widgets/address_design.dart';
import 'package:breejstores_users_app/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;

  const AddressScreen({Key? key, this.totalAmount, this.sellerUID})
      : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          "breejStores",
          style: TextStyle(fontSize: 35, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Select Address",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress")
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: circularProgress(),
                      )
                    : snapshot.data!.docs.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("No address added"))
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return AddressDesign(
                                currentIndex: address.count,
                                value: index,
                                addressID: snapshot.data!.docs[index].id,
                                totalAmount: widget.totalAmount,
                                sellerUID: widget.sellerUID,
                                model: Address.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>),
                              );
                            },
                          );
              },
            ),
            );
          },
          ),

          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.cyan),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.cyan,width: 1)
                  )
                )
              ),
              onPressed: () {
              //SAVE ADDRESS TO DATABASE
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => SaveAddressScreen()));
            },
              label: const Text("Add New Address"),
              icon: const Icon(Icons.add_location),),
          )
        ],
      ),
    );
  }
}
