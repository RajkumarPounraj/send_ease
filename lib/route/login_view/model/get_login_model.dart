import 'dart:convert';

List<LoginDetail> loginDetailFromJson(str) => List<LoginDetail>.from(json.decode(str).map((x) => LoginDetail.fromJson(x)));

String loginDetailToJson(List<LoginDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginDetail {
    int id;
    String username;
    String password;
    String name;

    LoginDetail({
        required this.id,
        required this.username,
        required this.password,
        required this.name
    });

    factory LoginDetail.fromJson(Map<String, dynamic> json) => LoginDetail(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        name : json["name"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "name" : name
    };
}
