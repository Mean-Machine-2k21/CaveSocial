import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/api_handling.dart';

class MuralRepository {
  ApiHandling _apiHandling = ApiHandling();

  fetchProfileMurals(
      {required List<Mural> murals,
      required String username,
      required int page}) async {
    return await _apiHandling.fetchProfileMurals(username, murals, page);
  }

  fetchAllMurals(int page) async {
    return await _apiHandling.fetchAllMurals(page);
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

  fetchMuralLikeList({required String muralid}) {}

  fetchMuralCommentList({required String muralid}) {}

  commentMural(
      {required String parentMuralId,
      required String content,
      Flipbook? flipbook}) {}
}
