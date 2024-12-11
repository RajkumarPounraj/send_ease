import 'dart:convert';

List<TransactionDetail> transactionDetailFromJson(str) => List<TransactionDetail>.from(json.decode(str).map((x) => TransactionDetail.fromJson(x)));

String transactionDetailToJson(List<TransactionDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionDetail {
  int id;
  String date;
  int amount;
  String description;

  TransactionDetail({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) => TransactionDetail(
    id: json["id"],
    date: json["date"],
    amount: json["amount"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "amount": amount,
    "description": description,
  };
}
