import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/api_handling.dart';

class MuralRepository {
  ApiHandling _apiHandling = ApiHandling();

  fetchProfileMurals(
      {required List<Mural> murals,
      required String username,
      required int page}) {
    _apiHandling.fetchProfileMurals(username, murals, page);
  }
}
