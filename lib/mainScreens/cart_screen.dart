import 'package:breejstores_users_app/assisantMethods/assistant_methods.dart';
import 'package:breejstores_users_app/assisantMethods/total_amount.dart';
import 'package:breejstores_users_app/mainScreens/address_screen.dart';
import 'package:breejstores_users_app/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../Models/items.dart';
import '../assisantMethods/cart_item_counter.dart';
import '../widgets/cart_item_design.dart';
import '../widgets/progress_bar.dart';
import '../widgets/text_widget.dart';



class CartScreen extends StatefulWidget
{
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}




class _CartScreenState extends State<CartScreen>
{
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false)
        .displayTotalAmount(0);

    separateItemQuantityList = separateItemQuantities();
  }

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
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My cart",
          style: TextStyle(fontSize: 35, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {
                clearCartNow(context);
                Fluttertoast.showToast(msg: "Cart has been cleared!");

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      sellerUID: widget.sellerUID,
                    )));
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [

          //overall total amount
          SliverPersistentHeader(
              pinned: true,
              delegate: TextHeaderWidget(title: "My Cart List")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: " + amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight:  FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),

          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(child: Center(child: circularProgress(),),);
              } else {
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                children: const [

                  Icon(Icons.shopping_cart, color: Colors.grey,),

                  SizedBox(height: 20,),

                  Text("Cart is empty"),

                ],
              );
                } else {
                  return SliverList(
                delegate: SliverChildBuilderDelegate((context, index)
                {
                  Items model = Items.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );

                  if(index == 0)
                  {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  } else
                  {
                    totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                  }

                  if(snapshot.data!.docs.length - 1 == index)
                  {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                    {
                      Provider.of<TotalAmount>(context, listen: false)
                          .displayTotalAmount(totalAmount.toDouble());
                    },
                    );
                  }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber: separateItemQuantityList![index],
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                ),
              );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
