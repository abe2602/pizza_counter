import 'package:meta/meta.dart';

class Movie {
  const Movie({
    @required this.id,
    @required this.title,
    @required this.posterUrl,
    @required this.isFavorite,
  })  : assert(id != null),
        assert(title != null),
        assert(posterUrl != null),
        assert(isFavorite != null);

  final int id;
  final String posterUrl;
  final String title;
  final bool isFavorite;
}
