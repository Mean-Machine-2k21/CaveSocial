import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';
import 'package:frontend/models/mural_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/repository/mural_repository.dart';

import '../../global.dart';

class MuralBloc extends Bloc<MuralEvent, MuralState> {
  final MuralRepository muralRepository;
  MuralBloc(this.muralRepository) : super(InitialState());

  @override
  Stream<MuralState> mapEventToState(MuralEvent event) async* {
    // for intermediate
    yield FetchingMurals();
    try {
      if (event is FetchAllMurals) {
        yield FetchingMurals();
        List<Mural> murals = [];
        murals = await muralRepository.fetchAllMurals(event.page);
        yield FetchedMurals(Murals: murals);
      } else if (event is FetchProfileMurals) {
        var username = await localRead('username');
        List<Mural> murals = [];
        User user = await muralRepository.fetchProfileMurals(
            murals: murals, username: username, page: event.page);
        yield FetchedUserProfile(murals: murals, user: user);
      } else if (event is CreateMural) {
        await muralRepository.createMural(
            content: event.content, flipbook: event.flipbook);
        yield NoReqState();
      } else if (event is LikeMural) {
        await muralRepository.likeMural(muralId: event.muralid);
        yield NoReqState();
      } else if (event is UnLikeMural) {
        await muralRepository.unLikeMural(muralId: event.muralid);
        yield NoReqState();
      } else if (event is FetchMuralLikeList) {
        List<String> usernames = [];
        usernames =
            await muralRepository.fetchMuralLikeList(muralid: event.muralid,page:event.page);
        yield FetchedMuralLikeList(usernames: usernames);
      } else if (event is FetchMuralCommentList) {
        List<Mural> muralCommentList = [];
        muralCommentList =
            await muralRepository.fetchMuralCommentList(muralid: event.muralid,page:event.page);
        yield FetchedMuralCommentList(muralCommentList: muralCommentList);
      } else if (event is CommentMural) {
        await muralRepository.commentMural(
            parentMuralId: event.parentMuralId,
            content: event.content,
            flipbook: event.flipbook);
        yield NoReqState();
      }
    } catch (e) {
      ErrorState();
    }
  }
}
