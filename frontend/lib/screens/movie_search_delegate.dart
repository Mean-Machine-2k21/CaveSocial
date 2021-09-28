//@dart=2.9

import 'package:frontend/models/search_result.dart';
import 'package:frontend/services/movie_search_service.dart';
import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate<SearchResult> {
  MovieSearchDelegate(this.searchService);
  final MovieSearchService searchService;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // search-as-you-type if enabled
    searchService.searchMovie(query);
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      searchService.searchMovie(query);
      return buildMatchingSuggestions(context);
      //popular searches can be implemeted
    }
    // always search if submitted

    return Container(
      child: Text(query),
    );
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    // then return results
    return StreamBuilder<List<SearchResult>>(
      stream: searchService.results,
      builder: (context, AsyncSnapshot<List<SearchResult>> snapshot) {
        if (snapshot.hasData) {
          final List<SearchResult> result = snapshot.data;
          return result.isEmpty
              ? Center(child: Text('No Resuls Found !'))
              : ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            close(context, result[index]);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  1.0)), //add border radius here
                              child: result[index].avatarUrl == 'N/A'
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.amber,
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      child: Image.network(
                                        result[index].avatarUrl,
                                        fit: BoxFit.cover,
                                      )) //add image location here
                              ),
                          title: Text(
                            "@" + result[index].username,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.red),
                          ), // movie details

                          dense: true,
                        ),
                        Divider(),
                      ],
                    );
                  });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }
}
