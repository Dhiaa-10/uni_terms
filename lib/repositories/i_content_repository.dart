import '../models/spec_model.dart';
import '../models/term_model.dart';

abstract class IContentRepository {
  /// Returns all specs (majors) from the backend.
  Future<List<SpecModel>> getSpecs();

  /// Returns the most recently added terms.
  Future<List<TermModel>> getLatestTerms();

  /// Returns all terms that belong to [specId].
  Future<List<TermModel>> getTermsBySpec(int specId);
}
