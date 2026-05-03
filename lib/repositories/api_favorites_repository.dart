import 'package:get/get.dart';
import '../core/api_constants.dart';
import '../core/api_service.dart';
import '../models/term_model.dart';
import 'i_favorites_repository.dart';

class ApiFavoritesRepository implements IFavoritesRepository {
  final ApiService _api = Get.find<ApiService>();

  @override
  Future<List<TermModel>> getFavorites() async {
    final response = await _api.get(ApiConstants.favorites);
    if (!response.success || response.data == null) return [];

    final data = response.data as Map<String, dynamic>;
    final list =
        (data['data'] ?? data['favorites'] ?? response.data) as List? ?? [];
    return list
        .map((e) => TermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> toggleFavorite(int termId) async {
    final response = await _api.post(ApiConstants.favoritesToggle, body: {
      'term_id': termId,
    });

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      // Backend returns { "favorited": true/false } or { "status": "added"/"removed" }
      if (data.containsKey('favorited')) return data['favorited'] as bool;
      if (data.containsKey('status')) {
        return data['status'] == 'added';
      }
    }
    return false;
  }
}
