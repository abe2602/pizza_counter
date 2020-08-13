import '../model/favorite_movie.dart';
import '../model/movide_detail.dart';
import '../model/movie.dart';

abstract class MovieDataRepository {
  Future<MovieDetail> getMovieDetail(int movieId);
  Future<List<Movie>> getMovieList();
  Future<List<FavoriteMovie>> getFavoritesList();
  Future<void> changeFavoriteStatus(int movieId);
}