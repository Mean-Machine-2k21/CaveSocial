// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        required this.id,
        required this.username,
        required this.avatarUrl,
        required this.bioUrl,
    });

    String id;
    String username;
    String avatarUrl;
    String bioUrl;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        avatarUrl: json["avatar_url"],
        bioUrl: json["bio_url"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar_url": avatarUrl,
        "bio_url": bioUrl,
    };
}
