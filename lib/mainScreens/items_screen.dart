import 'package:breejstores_users_app/Models/items.dart';
import 'package:breejstores_users_app/assisantMethods/cart_item_counter.dart';
import 'package:breejstores_users_app/mainScreens/cart_screen.dart';
import 'package:breejstores_users_app/mainScreens/item_detail_screen.dart';
import 'package:breejstores_users_app/widgets/items_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../constants/constants.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';

class ItemsScreen extends StatefulWidget {
  final Products? model;

  const ItemsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "breejStores",
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 30,
            ),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {
                      //sEND USER TO CART PAGE
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => CartScreen(
                                  sellerUID: widget.model!.sellerUID)));
                    },
                    icon: const Icon(Icons.shopping_cart)),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Stack(
                    children: [
                      const Icon(
                        Icons.brightness_1,
                        size: 20,
                        color: Colors.red,
                      ),
                      Positioned(
                        top: 3,
                        right: 4,
                        child: Center(
                          child: Consumer<CartItemCounter>(
                            builder: (context, counter, c) {
                              return Text(
                                counter.count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.cyan,
                          Colors.amber,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(1, 0),
                        stops: [0, 1],
                        tileMode: TileMode.clamp)),
                height: 80,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: InkWell(
                  child: Text(
                    widget.model!.productTitle.toString(),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(kDefaultPadding),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("merchants")
                      .doc(widget.model!.sellerUID)
                      .collection('products')
                      .doc(widget.model!.productID)
                      .collection("items")
                      .orderBy("publishedDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: circularProgress(),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: const [
                          Icon(
                            Icons.star,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    } else {
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          Items model = Items.fromJson(
                              snapshot.data!.docs[index].data()!
                                  as Map<String, dynamic>);
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetailsScreen(model: model)));
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        color: Colors.grey.shade300,
                                      )
                                    ]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      model.thumbnailUrl.toString(),
                                      height: 120,
                                    ),
                                    Text(
                                      model.itemTitle.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "₦" + model.price.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
