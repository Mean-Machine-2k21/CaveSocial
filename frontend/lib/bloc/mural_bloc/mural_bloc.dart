import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/mural_bloc/mural_event.dart';
import 'package:frontend/bloc/mural_bloc/mural_state.dart';

class MuralBloc extends Bloc<MuralEvent, MuralState> {
  MuralBloc() : super(InitialState());
  @override
  Stream<MuralState> mapEventToState(MuralEvent event) async* {
   
   if(event is FetchAllMurals)
   {

   }
   if(event is CreateMural)
   {
     
   }
   if(event is LikeMural)
   {

   }
   if(event is FetchMuralLikeList)
   {

   }
   if(event is FetchMuralCommentList)
   {

   }
   if(event is CommentMural)
   {
     
   }

    //throw UnimplementedError();
  }
}
