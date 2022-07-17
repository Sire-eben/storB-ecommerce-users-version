import 'package:breejstores_users_app/Models/merchants.dart';
import 'package:breejstores_users_app/mainScreens/products_screen.dart';
import 'package:flutter/material.dart';

class MerchantsDesignWidget extends StatefulWidget {
  final Merchants? model;
  BuildContext? context;

  MerchantsDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  @override
  State<MerchantsDesignWidget> createState() => _MerchantsDesignWidgetState();
}

class _MerchantsDesignWidgetState extends State<MerchantsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => ProductsScreen(
          model: widget.model
        )));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          color: Colors.white,
          height: 265,
          child: Column(
            children: [
              Image.network(
                widget.model!.sellerAvatarUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.model!.sellerAddress!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
