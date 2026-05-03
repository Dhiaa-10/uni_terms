import '../models/term_model.dart';

abstract class IFavoritesRepository {
  /// Returns the user's favorite terms from the backend.
  Future<List<TermModel>> getFavorites();

  /// Toggles the favorite status of [termId].
  /// Returns true if the term is now a favorite, false if removed.
  Future<bool> toggleFavorite(int termId);
}
