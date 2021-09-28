// To parse this JSON data, do
//
//     final mural = muralFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Mural muralFromJson(String str) => Mural.fromJson(json.decode(str));

Mural returnMural(Map<String, dynamic> json) {
  return Mural(
    id: json["_id"],
    creatorId: json["creatorId"],
    creatorUsername: json["creatorUsername"],
    imageUrl: json["imageUrl"],
    likedCount: json["likedCount"],
    commentCount: json["commentCount"],
    isLiked: json["isLiked"],
  );
}

Mural returnMuralWithFlipbook(Map<String, dynamic> json) {
  return Mural(
    id: json["_id"],
    creatorId: json["creatorId"],
    creatorUsername: json["creatorUsername"],
    imageUrl: json["imageUrl"],
    flipbook: Flipbook(
      duration: json["flipbook"]["duration"],
      frames: json["flipbook"]["frames"],
    ),
    likedCount: json["likedCount"],
    commentCount: json["commentCount"],
    isLiked: json["isLiked"],
  );
}

String muralToJson(Mural data) => json.encode(data.toJson());

class Mural {
  Mural({
    required this.id,
    required this.creatorId,
    required this.creatorUsername,
    this.flipbook,
    required this.imageUrl,
    required this.likedCount,
    required this.commentCount,
    required this.isLiked,
  });

  String id;
  String creatorId;
  String creatorUsername;
  Flipbook? flipbook;
  String imageUrl;
  int likedCount;
  int commentCount;
  bool isLiked;

  factory Mural.fromJson(Map<String, dynamic> json) => Mural(
        id: json["_id"],
        creatorId: json["creatorId"],
        creatorUsername: json["creatorUsername"],
        flipbook: json["flipbook"] ? Flipbook.fromJson(json["flipbook"]) : null,
        imageUrl: json["imageUrl"],
        likedCount: json["likedCount"],
        commentCount: json["commentCount"],
        isLiked: json["isLiked"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "creatorId": creatorId,
        "creatorUsername": creatorUsername,
        "flipbook": flipbook!.toJson(),
        "imageUrl": imageUrl,
        "likedCount": likedCount,
        "commentCount": commentCount,
        "isLiked": isLiked,
      };
}

class Flipbook {
  Flipbook({
    this.frames,
    this.duration,
  });

  int? frames;
  int? duration;

  factory Flipbook.fromJson(Map<String, dynamic> json) => Flipbook(
        frames: json["frames"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "frames": frames,
        "duration": duration,
      };
}
