import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';

class ApiHandling {
  static const String url = SERVER_IP;
  late BaseOptions options;
  ApiHandling() {
    options = BaseOptions(
      baseUrl: SERVER_IP,
      contentType: "application/json",
      // queryParameters: ,
    );
  }

  Future<void> editProfile(String avatarUrl, String bioUrl) async {
    print('Avatar Url ---> ${avatarUrl}');
    print('Bio Url ----> ${bioUrl}');
    try {
      final token = await localRead('jwt');
      //final token =
      //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGQ2M2NlMzk2YjdiODNjNzgzY2M3YjQiLCJpYXQiOjE2MjQ2NTcwODZ9.FvPveb4RpYtHshxKZdzArrOr5n9pHMkJQaX4XPC-zYg';
      final response = await Dio(options).patch(url + '/api/editprofile',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }),
          data: {
            'avatar_url': avatarUrl,
            'bio_url': bioUrl,
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> fetchProfileMurals(
      String username, List<Mural> murals, int pageNo) async {
    print('Username ---> ${username}');

    User? user;

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).get(url + '/api/profile/' + username,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            'pagenumber': pageNo,
          });

      print(json.decode(response.data));

      final extractedData = json.decode(response.data) as Map<String, dynamic>;
      User user = User(
        avatarUrl: extractedData['user']['avatar_url'],
        bioUrl: extractedData['user']['bio_url'],
        id: extractedData['user']['_id'],
        username: extractedData['user']['username'],
      );

      extractedData['murals'].forEach((key, value) {
        // murals.add(Mural(
        //   commentCount: value['commentCount'],
        //   creatorId: value['creatorId'],
        //   creatorUsername: value['creatorUsername'],
        //   id: value['_id'],
        //   imageUrl: value['imageUrl'],
        //   isLiked: value['isLiked'],
        //   likedCount: value['likedCount'],
        // ));
        murals.add(muralFromJson(value));
      });
    } catch (e) {
      print(e.toString());
    }

    return user!;
  }
}
