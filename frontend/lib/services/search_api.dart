import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/models/search_result.dart';
import 'package:http/http.dart' as http;
import 'api_handling.dart';

class SearchApi {
  Dio dio = new Dio();

  Future<List<SearchResult>> searchMovie(String name) async {
    // final url = Uri.parse('http://www.SearchApi.com/?apikey=e6aefcb6&s=$name');
    List<SearchResult> loadedMovies = [];
    try {
      // final response = await await Dio(options).get(
      //   url + '/api/likesonmural/',
      //   options: Options(headers: {
      //     'Authorization': 'Bearer $token',
      //   }),
      // );
      // final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      // print(extractedData.values.elementAt(0)[0]);
      // extractedData.values.elementAt(0).forEach(
      //   (value) {
      //     loadedMovies.add(
      //       MovieModel(
      //         imdbID: value['imdbID'],
      //         poster: value['Poster'],
      //         title: value['Title'],
      //         type: value['Type'],
      //         year: value['Year'],
      //       ),
      //     );
      //   },
      // );
      ApiHandling api = ApiHandling();
      loadedMovies = await api.fetchSearchResults(name);
      return loadedMovies;
    } catch (e) {
      print('Error ' + e.toString());
    }
    return loadedMovies;
  }
}
