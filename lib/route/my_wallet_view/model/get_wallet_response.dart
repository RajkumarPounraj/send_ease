import 'dart:convert';

WalletResponseDetail walletResponseDetailFromJson(str) => WalletResponseDetail.fromJson(json.decode(str));

String walletResponseDetailToJson(WalletResponseDetail data) => json.encode(data.toJson());

class WalletResponseDetail {
  int? id;
  String? username;
  String? name;
  dynamic amount;

  WalletResponseDetail({
    required this.id,
    required this.username,
    required this.name,
    required this.amount,
  });

  factory WalletResponseDetail.fromJson(Map<String, dynamic> json) => WalletResponseDetail(
    id: json["id"] ?? "",
    username: json["username"] ?? "",
    name: json["name"] ?? "",
    amount: json["amount"] ?? 0 ,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "amount": amount,
  };
}
