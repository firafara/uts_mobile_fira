import 'dart:convert';

ModelBudaya modelBudayaFromJson(String str) =>
    ModelBudaya.fromJson(json.decode(str));

String modelBudayaToJson(ModelBudaya data) => json.encode(data.toJson());

class ModelBudaya {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelBudaya({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelBudaya.fromJson(Map<String, dynamic> json) => ModelBudaya(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String judul;
  String konten;
  String gambar;
  DateTime createdAt;

  Datum({
    required this.id,
    required this.judul,
    required this.konten,
    required this.gambar,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? '0', // Providing a default value if null
        judul: json["judul"] ?? 'No Title', // Providing a default value if null
        konten:
            json["konten"] ?? 'No Content', // Providing a default value if null
        gambar: json["gambar"] ??
            'default_image.png', // Providing a default value if null
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(), // Providing a current date if null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "konten": konten,
        "gambar": gambar,
        "createdAt": createdAt.toIso8601String(),
      };
}
