import 'package:meta/meta.dart';

class FavoriteMovie {
  const FavoriteMovie({
    @required this.posterUrl,
  }) : assert(posterUrl != null);

  final String posterUrl;
}
