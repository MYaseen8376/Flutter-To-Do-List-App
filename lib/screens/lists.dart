import 'dart:convert';

LinkModel productModelFromJson(String str) =>
    LinkModel.fromJson(json.decode(str));

String productModelToJson(LinkModel data) => json.encode(data.toJson());

class LinkModel {
  String name;
  String image;

  LinkModel({
    required this.name,
    required this.image,
  });

  factory LinkModel.fromJson(Map<String, dynamic> json) => LinkModel(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
