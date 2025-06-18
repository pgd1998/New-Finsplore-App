import 'package:dio/dio.dart';
import 'base_api.dart';

class BudgetAPI extends BaseAPI {
  static const String _budgetEndpoint = '/api/budget';

  /// Sets user budget
  Future<Map<String, dynamic>> setBudget({
    required int userId,
    required double amount,
  }) async {
    try {
      final response = await dio.patch(
        '$_budgetEndpoint/set',
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

  /// Gets user budget
  Future<Map<String, dynamic>> getBudget(int userId) async {
    try {
      final response = await dio.get('$_budgetEndpoint/$userId');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('Budget API Error: ${error.response?.data?['message'] ?? error.message}');
    }
    return Exception('Unexpected error: $error');
  }
}
