import 'package:breejstores_users_app/Models/items.dart';
import 'package:breejstores_users_app/mainScreens/item_detail_screen.dart';
import 'package:flutter/material.dart';

class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 265,
          child: Column(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              Text(
                widget.model!.itemTitle!,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "₦" + widget.model!.price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
