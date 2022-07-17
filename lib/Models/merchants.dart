class Merchants {
  String? sellerName;
  String? sellerUID;
  String? sellerAvatarUrl;
  String? sellerEmail;
  String? sellerAddress;

  Merchants(
      {this.sellerName,
      this.sellerAvatarUrl,
      this.sellerEmail,
      this.sellerUID,
      this.sellerAddress,
      });

  Merchants.fromJson(Map <String, dynamic> json){
    sellerUID = json["sellerUID"];
    sellerEmail = json["sellerEmail"];
    sellerName = json["sellerName"];
    sellerAvatarUrl = json["sellerAvatarUrl"];
    sellerAddress = json["sellerAddress"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["sellerAvatarUrl"] = sellerAvatarUrl;
    data["sellerEmail"] = sellerEmail;
    data["sellerAddress"] = sellerAddress;

    return data;
  }
}
