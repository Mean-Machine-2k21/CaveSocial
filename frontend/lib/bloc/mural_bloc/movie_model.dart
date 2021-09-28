import 'package:flutter/material.dart';

class MovieModel {
  final imdbID;
  final poster;
  final title;
  final type;
  final year;

  MovieModel({
    @required this.imdbID,
    @required this.poster,
    @required this.title,
    @required this.type,
    @required this.year,
  });
}
