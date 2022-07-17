import 'package:breejstores_users_app/widgets/merchants_design_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/merchants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? storesDocumentsList;
  String sellerNameText = "";

  initSearchingStore(String textEntered) {
    storesDocumentsList = FirebaseFirestore.instance
        .collection("merchants")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp),
          ),
        ),
        title: TextField(
          onChanged: (textEntered) {
            //INITIATE SEARCH
            setState(() {
              sellerNameText = textEntered;
            });
            initSearchingStore(textEntered);
          },
          decoration: InputDecoration(
              hintText: "Search Stores...",
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                  onPressed: () {
                    //INITIATE SEARCH
                    initSearchingStore(sellerNameText);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: storesDocumentsList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Merchants model = Merchants.fromJson(snapshot.data!.docs[index].data()! as Map<String, dynamic>);

              return MerchantsDesignWidget(
                model: model,
                context: context,
              );
            },
          )
              : const Center(
            child: Text("No store found!"),
          );
        },
      ),
    );
  }
}
