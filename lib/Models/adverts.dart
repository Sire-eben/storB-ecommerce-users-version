import 'package:cloud_firestore/cloud_firestore.dart';

class Adverts {
  String? imageUrl;

  Adverts({
    this.imageUrl,
  });

  Adverts.fromJson(Map<String, dynamic> json){
    imageUrl = json["image"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["imageUrl"] = imageUrl;

    return data;
  }
}
