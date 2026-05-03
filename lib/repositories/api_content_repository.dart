import 'package:get/get.dart';
import '../core/api_constants.dart';
import '../core/api_service.dart';
import '../models/spec_model.dart';
import '../models/term_model.dart';
import 'i_content_repository.dart';

class ApiContentRepository implements IContentRepository {
  final ApiService _api = Get.find<ApiService>();

  @override
  Future<List<SpecModel>> getSpecs() async {
    final response = await _api.get(ApiConstants.specs);
    if (!response.success || response.data == null) return [];

    List list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final inner = data['data'] ?? data;
      if (inner is List) {
        list = inner;
      } else if (inner is Map) {
        list = (inner['specs'] ?? inner['data'] ?? []) as List;
      } else {
        list = [];
      }
    } else {
      return [];
    }

    return list
        .map((e) => SpecModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TermModel>> getLatestTerms() async {
    final response = await _api.get(ApiConstants.latestTerms);
    if (!response.success || response.data == null) return [];

    List list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      list = (data['data'] ?? data['terms'] ?? data['items'] ?? data['results'] ?? data['list'] ?? []) as List;
    } else {
      return [];
    }

    return list
        .map((e) => TermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TermModel>> getTermsBySpec(int specId) async {
    final response = await _api.get(ApiConstants.specTerms(specId));
    if (!response.success || response.data == null) return [];

    List list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      list = (data['data'] ?? data['terms'] ?? data['items'] ?? data['results'] ?? data['list'] ?? []) as List;
    } else {
      return [];
    }

    return list
        .map((e) => TermModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
