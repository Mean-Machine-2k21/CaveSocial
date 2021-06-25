// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
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

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
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
