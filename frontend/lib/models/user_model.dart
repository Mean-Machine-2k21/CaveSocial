// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

User returnUser(Map<String, dynamic> json) {
  return User(
    id: json["_id"],
    username: json["username"],
    avatarUrl: json["avatar_url"],
    bioUrl: json["bio_url"],
    followersCount: json["followersCount"],
    followingCount: json["followingCount"],
    isFollowed: json["isFollowed"],
  );
}

class User {
  User({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.bioUrl,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowed,
  });

  String id;
  String username;
  String avatarUrl;
  String bioUrl;
  int followersCount;
  int followingCount;
  bool isFollowed = false;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      username: json["username"],
      avatarUrl: json["avatar_url"],
      bioUrl: json["bio_url"],
      followersCount: json["followersCount"],
      followingCount: json["followingCount"],
      isFollowed: json["isFollowed"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "avatar_url": avatarUrl,
        "bio_url": bioUrl,
        "followersCount": followersCount,
        "followingCount": followingCount,
        "isFollowed": isFollowed,
      };
}
