import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/liked_user.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:logger/logger.dart';

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

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  var loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  Future<void> editProfile({
    required String avatarUrl,
    required String bioUrl,
  }) async {
    try {
      final token = await localRead('jwt');
      //final token =
      //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGQ2M2NlMzk2YjdiODNjNzgzY2M3YjQiLCJpYXQiOjE2MjQ2NTcwODZ9.FvPveb4RpYtHshxKZdzArrOr5n9pHMkJQaX4XPC-zYg';

      final response;
      if (avatarUrl == "") {
        response = await Dio(options).patch(url + '/api/editprofile',
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            }),
            data: {
              'bio_url': bioUrl,
            });
      } else if (bioUrl == "") {
        response = await Dio(options).patch(url + '/api/editprofile',
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            }),
            data: {
              'avatar_url': avatarUrl,
            });
      } else {
        response = await Dio(options).patch(url + '/api/editprofile',
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            }),
            data: {
              'avatar_url': avatarUrl,
              'bio_url': bioUrl,
            });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<LikedUsers>> fetchLikesonMural(String muralId) async {
    List<LikedUsers> likedUsers = [];

    try {
      final token = await localRead('jwt');
      print('tokennn -----> ${token}');
      print('muralId -----> ${muralId}');
      final response = await Dio(options).get(
        url + '/api/likesonmural/${muralId}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final vari = Map<String, dynamic>.from(response.data);

      final likedList = vari.values.elementAt(0);
      likedList.forEach((element) {
        print(element.values.elementAt(0));

        likedUsers.add(
          LikedUsers(
            element.values.elementAt(1),
            element.values.elementAt(2),
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }

    print('Liked Users Length ---> ${likedUsers.length}');
    return likedUsers;
  }

  Future<void> signOut() async {
    try {
      final token = await localRead('jwt');

      final response = await Dio(options).post(
        url + '/api/logout',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
      );
    } catch (e) {}
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

      Map<String, dynamic> data = {
        'content': content,
      };
      if (flipbook != null) {
        data['flipbook'] = {
          'frames': flipbook.frames,
          'duration': flipbook.duration,
        };
      }

      print(data);

      final response = await Dio(options).post(
        url + '/api/createmural',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        }),
        data: data,
      );
      print(response.data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentMural(
      String content, String parentMuralId, Flipbook? flipbook) async {
    print('Inside Coment API------>');
    print('Content Url ---> ${content}');
    if (flipbook != null) {
      print('Flipbook Frames ----> ${flipbook.frames}');
      print('Flipbook Duration ---> ${flipbook.duration}');
    }

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).post(
        url + '/api/commentonmural/${parentMuralId}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        ),
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
      print(response.data);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Mural>> fetchMuralCommentList(String muralId, int pageNo) async {
    print(
        'PageNo ggggggggggggggggeeeeeeeeeeeeeee--------------------------> ${pageNo}');

    List<Mural> murals = [];

    try {
      final token = await localRead('jwt');
      print('tokennn -----> ${token}');
      print('muralId -----> ${muralId}');
      final response =
          await Dio(options).get(url + '/api/commentsonmural/${muralId}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }),
              queryParameters: {
            'pagenumber': pageNo,
          });

      ////print(json.decode(response.data));
      //final extractedData = json.decode(response.data) as Map<String, dynamic>;
      final vari = Map<String, dynamic>.from(response.data);

      print(response.data);

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

    print('Lengthhhh----> ${murals.length}');

    return murals;
  }

  Future<void> likeMural(String muralId) async {
    print('Likkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk MuralId ---> ${muralId}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).patch(
        url + '/api/likemural',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          'muralId': muralId,
        },
      );
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
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Mural>> fetchAllMurals(int pageNo) async {
    // print(
    //     'PageNo gggggggggggggggggggggggg--------------------------> ${pageNo}');
    loggerNoStack.i({pageNo});
    List<Mural> murals2 = [];

    try {
      final token = await localRead('jwt');

      Response<String> response2 = await Dio(options).get(url + '/api/murals/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            'pagenumber': pageNo,
          });

      final parsed = json.decode(response2.data ?? "") as Map<String, dynamic>;

      parsed["murals"].forEach((element) {
        if (element["flipbook"] != null) {
          murals2.add(returnMuralWithFlipbook(element));
        } else {
          murals2.add(returnMural(element));
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return murals2;
  }

  Future<User?> fetchProfileMurals(
      String username, List<Mural> murals, int pageNo) async {
    print('Username ---> ${username}');

    User? user;

    try {
      final token = await localRead('jwt');

      print(token);
      logger.i(' URL ----> ${url + '/api/profile/' + username}');
      Response<String> response =
          await Dio(options).get(url + '/api/profile/' + username,
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }),
              queryParameters: {
            'pagenumber': pageNo,
          });

      logger.d('${response}');
      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

      user = returnUser(parsed["user"]);
      parsed["murals"].forEach((element) {
        if (element["flipbook"] != null) {
          murals.add(returnMuralWithFlipbook(element));
        } else {
          murals.add(returnMural(element));
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return user!;
  }
}
