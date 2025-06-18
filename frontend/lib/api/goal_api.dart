import 'package:dio/dio.dart';
import 'base_api.dart';

class GoalAPI extends BaseAPI {
  static const String _goalEndpoint = '/api/goal';

  /// Sets user financial goal
  Future<Map<String, dynamic>> setGoal({
    required int userId,
    required double amount,
  }) async {
    try {
      final response = await dio.patch(
        '$_goalEndpoint/set',
        data: {
          'userId': userId,
          'amount': amount,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Gets user financial goal
  Future<Map<String, dynamic>> getGoal(int userId) async {
    try {
      final response = await dio.get('$_goalEndpoint/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('Goal API Error: ${error.response?.data?['message'] ?? error.message}');
    }
    return Exception('Unexpected error: $error');
  }
}
