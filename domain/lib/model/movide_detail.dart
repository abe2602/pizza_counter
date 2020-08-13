import 'production_country.dart';
import 'package:meta/meta.dart';

class MovieDetail {
  const MovieDetail({
    @required this.id,
    @required this.voteAverage,
    @required this.title,
    @required this.posterUrl,
    @required this.backdropUrl,
    @required this.releaseDate,
    @required this.genres,
    @required this.productionCountry,
    @required this.isFavorite,
  })  : assert(id != null),
        assert(voteAverage != null),
        assert(title != null),
        assert(posterUrl != null),
        assert(backdropUrl != null),
        assert(releaseDate != null),
        assert(genres != null),
        assert(productionCountry != null),
        assert(isFavorite != null);

  final int id;
  final double voteAverage;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final bool isFavorite;
  final List<String> genres;
  final List<ProductionCountry> productionCountry;
}
