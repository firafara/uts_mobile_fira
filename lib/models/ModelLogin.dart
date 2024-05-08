
import 'dart:convert';

ModelLogin modelLoginFromJson(String str) => ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

// class ModelLogin {
//   int value;
//   String id;
//   String username;
//   String fullname;
//   String message;
//
//   ModelLogin({
//     required this.value,
//     required this.id,
//     required this.username,
//     required this.fullname,
//     required this.message,
//   });
//
//   factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
//     value: json["value"],
//     id: json["id"],
//     username: json["username"],
//     fullname: json["fullname"],
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "value": value,
//     "id": id,
//     "username": username,
//     "fullname": fullname,
//     "message": message,
//   };
//}
class ModelLogin {
  bool sukses;
  int status;
  String pesan;
  Data data;

  ModelLogin({
    required this.sukses,
    required this.status,
    required this.pesan,
    required this.data,
  });

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
    sukses: json["sukses"],
    status: json["status"],
    pesan: json["pesan"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : Data(
      id: "",
      username: "",
      email: "",
      password: "",
      fullname: "",
      phone_number: "",
    ),
  );

  Map<String, dynamic> toJson() => {
    "sukses": sukses,
    "status": status,
    "pesan": pesan,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String username;
  String email;
  String password;
  String fullname;
  String phone_number;

  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullname,
    required this.phone_number,

  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    fullname: json["fullname"],
    phone_number: json["phone_number"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "fullname": fullname,
    "phone_number": phone_number,

  };
}
