
//@dart=2.9
import 'package:frontend/bloc/mural_bloc/movie_model.dart';
import 'package:frontend/services/movie_search_service.dart';
import 'package:flutter/material.dart';


class MovieSearchDelegate extends SearchDelegate<MovieModel> {
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
    return StreamBuilder<List<MovieModel>>(
      stream: searchService.results,
      builder: (context, AsyncSnapshot<List<MovieModel>> snapshot) {
        if (snapshot.hasData) {
          final List<MovieModel> result = snapshot.data;
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
                              child: result[index].poster == 'N/A'
                                  ? Container(
                                      width: 30,
                                      height: 50,
                                      color: Colors.amber,
                                    )
                                  : Image(
                                      image: NetworkImage(result[index].poster),
                                    ) //add image location here
                              ),
                          title: Text(result[index].title), // movie details
                          subtitle: Text(result[index].year), // movie details
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
