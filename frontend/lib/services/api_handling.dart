import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/global.dart';
import 'package:frontend/models/liked_user.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/search_result.dart';
import 'package:frontend/models/user_list.dart';
import 'package:frontend/models/user_model.dart';
import 'logger.dart';

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

  Future<void> editProfile({
    required String avatarUrl,
    required String bioUrl,
  }) async {
    try {
      final token = await localRead('jwt');
      String oldAvatar = await localRead('avatar_url');
      String oldBio = await localRead('bio_url');

      logger.i('old Avatar - ${oldAvatar}');
      logger.i('newAvatar - ${avatarUrl}');
      logger.i('oldBio - ${oldBio}');
      logger.i('newBio - ${bioUrl}');
      //final token =
      //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGQ2M2NlMzk2YjdiODNjNzgzY2M3YjQiLCJpYXQiOjE2MjQ2NTcwODZ9.FvPveb4RpYtHshxKZdzArrOr5n9pHMkJQaX4XPC-zYg';

      final response;
      // if (avatarUrl == oldAvatar) {
      //   response = await Dio(options).patch(url + '/api/editprofile',
      //       options: Options(headers: {
      //         'Authorization': 'Bearer $token',
      //         'Content-Type': 'application/json'
      //       }),
      //       data: {
      //         'bio_url': bioUrl,
      //       });
      // } else if (bioUrl == oldBio) {
      //   response = await Dio(options).patch(url + '/api/editprofile',
      //       options: Options(headers: {
      //         'Authorization': 'Bearer $token',
      //         'Content-Type': 'application/json'
      //       }),
      //       data: {
      //         'avatar_url': avatarUrl,
      //       });
      // } else {
      response = await Dio(options).patch(url + '/api/editprofile',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          }),
          data: {
            'avatar_url': avatarUrl,
            'bio_url': bioUrl,
          });
      // }
    } catch (e) {
      print(e.toString());
    }
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

  Future<void> followUser(String userId) async {
    logger.d('UserId ---> ${userId}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).put(
        url + '/api/follow/${userId}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unfollowUser(String userId) async {
    logger.d('UserId ---> ${userId}');

    try {
      final token = await localRead('jwt');
      final response = await Dio(options).put(
        url + '/api/unfollow/${userId}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Mural>> fetchAllMurals(int pageNo) async {
    loggerNoStack.i('All Murals:- ${pageNo}');
    List<Mural> murals = [];

    try {
      final token = await localRead('jwt');

      Response<String> response = await Dio(options).get(url + '/api/murals/',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
          queryParameters: {
            'pagenumber': pageNo,
          });

      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

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
    logger.i(murals.length);
    return [...murals];
  }

  Future<List<Mural>> fetchFollowingMurals(int pageNo) async {
    logger.i("Following:- ${pageNo}");
    List<Mural> murals = [];

    try {
      final token = await localRead('jwt');

      Response<String> response =
          await Dio(options).get(url + '/api/following/murals/',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }),
              queryParameters: {
            'pagenumber': pageNo,
          });

      logger.i('Following:-- ${response}');
      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

      parsed["murals"].forEach((element) {
        if (element["flipbook"] != null) {
          logger.i(element["creatorUsername"]);
          murals.add(returnMuralWithFlipbook(element));
        } else {
          logger.i(element["creatorUsername"]);
          murals.add(returnMural(element));
        }
      });
    } catch (e) {
      print(e.toString());
    }
    logger.i(murals.length);
    return [...murals];
  }

  Future<List<UserList>> fetchUserList(String userId, String type) async {
    List<UserList> usersList = [];

    try {
      final token = await localRead('jwt');
      Response<String> response = await Dio(options).get(
        url + '/api/user/${userId}/${type}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

      parsed["${type.toLowerCase()}"].forEach((element) {
        usersList.add(
          UserList(
            element["_id"],
            element["username"],
            element["avatar_url"],
            element["isFollowed"],
          ),
        );
      });
    } catch (e) {
      logger.e(e.toString());
    }

    return usersList;
  }

  Future<List<SearchResult>> fetchSearchResults(String searchTerm) async {
    List<SearchResult> usersList = [];
    logger.i(searchTerm);
    searchTerm = searchTerm.trim();
    try {
      final token = await localRead('jwt');
      Response<String> response = await Dio(options).get(
        url + '/api/search/profile?searchTerm=$searchTerm',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;
      logger.i(parsed.toString());
      parsed["users"].forEach((element) {
        usersList.add(
          SearchResult(
            element["_id"],
            element["username"],
            element["avatar_url"],
          ),
        );
      });
    } catch (e) {
      logger.e(e.toString());
    }

    return usersList;
  }

  Future<List<LikedUsers>> fetchLikesonMural(String muralId) async {
    List<LikedUsers> likedUsers = [];

    try {
      final token = await localRead('jwt');
      print('tokennn -----> ${token}');
      print('muralId -----> ${muralId}');
      Response<String> response = await Dio(options).get(
        url + '/api/likesonmural/${muralId}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

      parsed["likes"].forEach((element) {
        likedUsers.add(
          LikedUsers(
            element["_id"],
            element["username"],
            element["avatar_url"],
          ),
        );
      });
    } catch (e) {
      print(e.toString());
    }

    print('Liked Users Length ---> ${likedUsers.length}');
    return likedUsers;
  }

  Future<List<Mural>> fetchMuralCommentList(String muralId, int pageNo) async {
    logger.i('PageNo -> ${pageNo}');

    List<Mural> murals = [];

    try {
      final token = await localRead('jwt');
      print('tokennn -----> ${token}');
      print('muralId -----> ${muralId}');
      Response<String> response =
          await Dio(options).get(url + '/api/commentsonmural/${muralId}',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }),
              queryParameters: {
            'pagenumber': pageNo,
          });

      final parsed = json.decode(response.data ?? "") as Map<String, dynamic>;

      parsed["comments"].forEach((element) {
        if (element["flipbook"] != null) {
          murals.add(returnMuralWithFlipbook(element));
        } else {
          murals.add(returnMural(element));
        }
      });
    } catch (e) {
      print(e.toString());
    }

    print('Lengthhhh----> ${murals.length}');

    return murals;
  }

  Future<User?> fetchProfileMurals(
      String username, List<Mural> murals, int pageNo, String id) async {
    print('Username ---> ${username}');
    logger.i('id-----> ${id}');

    User? user;

    try {
      final token = await localRead('jwt');

      print(token);
      logger.i(' URL ----> ${url + '/api/profile/' + id}');
      Response<String> response =
          await Dio(options).get(url + '/api/profile/' + id,
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
