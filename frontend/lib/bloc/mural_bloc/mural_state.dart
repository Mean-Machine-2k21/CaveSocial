import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';

abstract class MuralState {}

class InitialState extends MuralState {
  InitialState();
}

class FetchingMurals extends MuralState {}

class FetchedMurals extends MuralState {
  List<Mural> Murals;
  FetchedMurals({required this.Murals});
}

class FetchedUserProfile extends MuralState {
  List<Mural> murals;
  User user;
  FetchedUserProfile({required this.murals, required this.user});
}

class FetchedMuralLikeList extends MuralState {
  List<String> usernames;
  FetchedMuralLikeList({required this.usernames});
}

class MuralCommentLoading extends MuralState {}

class FetchedMuralCommentList extends MuralState {
  List<Mural> muralCommentList;
  FetchedMuralCommentList({required this.muralCommentList});
}

class NoReqState extends MuralState {}

class ErrorState extends MuralState {}
