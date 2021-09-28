import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/api_handling.dart';

class MuralRepository {
  ApiHandling _apiHandling = ApiHandling();

  fetchProfileMurals(
      {required List<Mural> murals,
      required String username,
      required int page,
      required String id}) async {
    return await _apiHandling.fetchProfileMurals(username, murals, page, id);
  }

  fetchAllMurals(int page) async {
    return await _apiHandling.fetchAllMurals(page);
  }

  fetchFollowingMurals(int page) async {
    return await _apiHandling.fetchFollowingMurals(page);
  }

  createMural({required String content, Flipbook? flipbook}) async {
    return await _apiHandling.createMural(content, flipbook);
  }

  likeMural({required String muralId}) async {
    return await _apiHandling.likeMural(muralId);
  }

  unLikeMural({required String muralId}) async {
    return await _apiHandling.unLikeMural(muralId);
  }

  followUser({required String userId}) async {
    return await _apiHandling.followUser(userId);
  }

  unfollowUser({required String userId}) async {
    return await _apiHandling.unfollowUser(userId);
  }

  fetchMuralLikeList({required String muralid, required int page}) async {
    //print('ddddddddddddddddddddd');
    return await _apiHandling.fetchLikesonMural(muralid);
  }

  fetchUserList({required String userId, required String type}) async {
    return await _apiHandling.fetchUserList(userId, type);
  }

  fetchMuralCommentList({required String muralid, required int page}) async {
    return await _apiHandling.fetchMuralCommentList(muralid, page);
  }

  commentMural(
      {required String parentMuralId,
      required String content,
      Flipbook? flipbook}) {
    _apiHandling.commentMural(content, parentMuralId, flipbook);
  }
}
