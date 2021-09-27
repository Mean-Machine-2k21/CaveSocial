import 'package:frontend/models/mural_model.dart';

abstract class MuralEvent {}

class FetchAllMurals extends MuralEvent {
  int page;
  String type;
  FetchAllMurals({required this.page, required this.type});
} //pagination to be done

//This is for any profile read.
class FetchProfileMurals extends MuralEvent {
  String username;
  int page;
  String id;
  FetchProfileMurals(
      {required this.username, required this.page, required this.id});
}

class CreateMural extends MuralEvent {
  //no state
  String content;
  Flipbook? flipbook;
  CreateMural({required this.content, this.flipbook});
}

class LikeMural extends MuralEvent {
  //no state
  String muralid;
  LikeMural({required this.muralid});
}

class UnLikeMural extends MuralEvent {
  //no state
  String muralid;
  UnLikeMural({required this.muralid});
}

class FetchMuralLikeList extends MuralEvent {
  String muralid;
  int page;
  FetchMuralLikeList({required this.muralid, required this.page});
}

class FetchUserList extends MuralEvent {
  String userid;
  String type;
  FetchUserList({required this.userid, required this.type});
}

class FetchMuralCommentList extends MuralEvent {
  String muralid;
  int page;
  FetchMuralCommentList({required this.muralid, required this.page});
}

class CommentMural extends MuralEvent {
  //no state
  String parentMuralId;
  String content;
  Flipbook? flipbook;
  CommentMural(
      {required this.parentMuralId, required this.content, this.flipbook});
}
