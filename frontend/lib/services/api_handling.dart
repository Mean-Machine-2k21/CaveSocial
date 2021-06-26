import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
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

  Future<void> createMural(String content, Flipbook? flipbook) async {
    print('Content Url ---> ${content}');
    if (flipbook != null) {
      print('Flipbook Frames ----> ${flipbook.frames}');
      print('Flipbook Duration ---> ${flipbook.duration}');
    }

    try {
      final token = await localRead('jwt');
      //final token =
      //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGQ2M2NlMzk2YjdiODNjNzgzY2M3YjQiLCJpYXQiOjE2MjQ2NTcwODZ9.FvPveb4RpYtHshxKZdzArrOr5n9pHMkJQaX4XPC-zYg';
      final response = await Dio(options).post(
        url + '/api/createmural',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
        data: {
          'content': content,
          'flipbook': flipbook != null
              ? {
                  'frames': flipbook.frames,
                  'duration': flipbook.duration,
                }
              : null,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Mural>> fetchAllMurals(int pageNo) async {
    print('PageNo---> ${pageNo}');

    List<Mural> murals = [];

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).get(url + '/api/murals/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            'pagenumber': pageNo,
          });

      ////print(json.decode(response.data));

      //final extractedData = json.decode(response.data) as Map<String, dynamic>;
      final vari = Map<String, dynamic>.from(response.data);

      final muralMap = vari.values.elementAt(0);
      muralMap.forEach((element) {
        print('Mural ---> ${element.values.elementAt(0)}');
        murals.add(Mural(
          id: element.values.elementAt(0),
          creatorId: element.values.elementAt(1),
          creatorUsername: element.values.elementAt(2),
          imageUrl: element.values.elementAt(3),
          likedCount: element.values.elementAt(4),
          commentCount: element.values.elementAt(5),
          isLiked: element.values.elementAt(6),
        ));
      });

      // extractedData.forEach((key, value) {
      //   murals.add(muralFromJson(value));
      // });
    } catch (e) {
      print(e.toString());
    }

    return murals;
  }

  Future<void> likeMural(String muralId) async {
    print('MuralId ---> ${muralId}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).patch(
        url + '/api/likemural/',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          'muralId': muralId,
        },
      );

      print(json.decode(response.data));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unLikeMural(String muralId) async {
    print('MuralId ---> ${muralId}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).patch(
        url + '/api/unlikemural/',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          'muralId': muralId,
        },
      );

      print(json.decode(response.data));
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

      print(token);
      print(' URL ----> ${url + '/api/profile/' + username}');
      final response = await Dio(options).get(url + '/api/profile/' + username,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            'pagenumber': pageNo,
          });

      print('*******************->  ${response}');
      // print(json.decode(response.data));

      Map extractedData = response.data;

      print('------> ${extractedData}');

      print('------> ${extractedData['user']}');
      //print('!!!!!!!!!!!> ${extractedData['user']['username']}');

      Map userMap = extractedData['user'];

      User? newUser;

      final vari = Map<String, dynamic>.from(response.data);

      print('HHHHHHHHHHHHHHHHHH->  ${vari.runtimeType}');

      vari.values.forEach((element) {
        print(element[0]);
        print('Hiiii');
      });

      final userMap2 = vari.values.elementAt(1);
      final muralMap = vari.values.elementAt(2);
      print(userMap2.values.elementAt(1));
      print('UUUUUUUUUUUUUUUUUU-> ${muralMap}');

      userMap2.values.forEach((element) {
        print('Value--> ${element}');
      });

      print('@@@@@@@-> ${extractedData['user'].runtimeType}');

      user = User(
        avatarUrl: userMap2.values.elementAt(2),
        bioUrl: userMap2.values.elementAt(3),
        id: userMap2.values.elementAt(0),
        username: userMap2.values.elementAt(1),
      );

      print('^^^^^^^^-> ${user.username}');

      muralMap.forEach((element) {
        print('Mural ---> ${element.values.elementAt(0)}');
        murals.add(Mural(
          id: element.values.elementAt(0),
          creatorId: element.values.elementAt(1),
          creatorUsername: element.values.elementAt(2),
          imageUrl: element.values.elementAt(3),
          likedCount: element.values.elementAt(4),
          commentCount: element.values.elementAt(5),
          isLiked: element.values.elementAt(6),
        ));
      });
    } catch (e) {
      print(e.toString());
    }

    return user!;
  }
}
