import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:frontend/models/search_result.dart';
import 'package:rxdart/rxdart.dart';

import 'search_api.dart';

class MovieSearchService {
  MovieSearchService({required this.apiWrapper}) {
    _results = _searchTerms
        .debounce((_) => TimerStream(true, Duration(milliseconds: 250)))
        .switchMap((query) async* {
      print('searching: $query');
      yield await apiWrapper.searchMovie(query);
    }); // discard previous events
  }

  final SearchApi apiWrapper;

  // Input stream (search terms)
  final _searchTerms = BehaviorSubject<String>();
  void searchMovie(String query) => _searchTerms.add(query);

  // Output stream (search results)
  late Stream<List<SearchResult>> _results;
  Stream<List<SearchResult>> get results => _results;

  void dispose() {
    _searchTerms.close();
  }
}
