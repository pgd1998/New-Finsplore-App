import 'package:dio/dio.dart';
import 'base_api.dart';

class SuggestionAPI extends BaseAPI {
  static const String _suggestionsEndpoint = '/api/suggestions';

  /// Creates a new financial suggestion
  Future<Map<String, dynamic>> createSuggestion({
    required int userId,
    required String suggestionText,
    required double expectedSaveAmount,
  }) async {
    try {
      final response = await dio.post(
        '$_suggestionsEndpoint/create',
        data: {
          'userId': userId,
          'suggestionText': suggestionText,
          'expectedSaveAmount': expectedSaveAmount,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Gets all suggestions for a user
  Future<List<Map<String, dynamic>>> getUserSuggestions(int userId) async {
    try {
      final response = await dio.get('$_suggestionsEndpoint/$userId');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Deletes a suggestion
  Future<void> deleteSuggestion(int suggestionId) async {
    try {
      await dio.delete('$_suggestionsEndpoint/$suggestionId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('Suggestion API Error: ${error.response?.data?['message'] ?? error.message}');
    }
    return Exception('Unexpected error: $error');
  }
}
