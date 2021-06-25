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

  Future<void> fetchProfileMurals(
      String username, List<Mural> murals, User user, int pageNo) async {
    print('Username ---> ${username}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).get(
        url + '/api/profile/' + username,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
        queryParameters: {
          'pagenumber' : pageNo
        }
      );
    } catch (e) {}
  }
}
