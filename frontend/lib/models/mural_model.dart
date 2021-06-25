// To parse this JSON data, do
//
//     final mural = muralFromJson(jsonString);

import 'dart:convert';

Mural muralFromJson(String str) => Mural.fromJson(json.decode(str));

String muralToJson(Mural data) => json.encode(data.toJson());

class Mural {
  Mural({
    required this.imageUrl,
    required this.isLiked,
    required this.creatorUserName,
    required this.creatorId,
    required this.likedCount,
    required this.commentCount,
  });

  String imageUrl;
  bool isLiked;
  String creatorUserName;
  String creatorId;
  int likedCount;
  int commentCount;

  factory Mural.fromJson(Map<String, dynamic> json) => Mural(
        imageUrl: json["imageUrl"],
        isLiked: json["isLiked"],
        creatorUserName: json["creatorUserName"],
        creatorId: json["creatorId"],
        likedCount: json["likedCount"],
        commentCount: json["commentCount"],
      );

  Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "isLiked": isLiked,
        "creatorUserName": creatorUserName,
        "creatorId": creatorId,
        "likedCount": likedCount,
        "commentCount": commentCount,
      };
}
