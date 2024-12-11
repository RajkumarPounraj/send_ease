import 'dart:convert';

SendMoneyResponseDetail sendMoneyResponseDetailFromJson(str) => SendMoneyResponseDetail.fromJson(json.decode(str));

String sendMoneyResponseDetailToJson(SendMoneyResponseDetail data) => json.encode(data.toJson());

class SendMoneyResponseDetail {
  String? date;
  String? description;
  dynamic amount;
  int? id;

  SendMoneyResponseDetail({
    required this.date,
    required this.description,
    required this.amount,
    required this.id,
  });

  factory SendMoneyResponseDetail.fromJson(Map<String, dynamic> json) => SendMoneyResponseDetail(
    date: json["date"] ??  "",
    description: json["description"] ?? "",
    amount: json["amount"] ?? 0.0,
    id: json["id"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "description": description,
    "amount": amount,
    "id": id,
  };
}
