import 'package:dio/dio.dart';
import 'simple_api_base.dart';

class TransactionAPI extends SimpleApiBase {
  static const String _transactionsEndpoint = '/api/transactions';

  /// Gets user transactions with optional filters
  Future<List<Map<String, dynamic>>> getUserTransactions({
    String? category,
    String? startDate,
    String? endDate,
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'size': size,
      };

      if (category != null) queryParameters['category'] = category;
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;
      if (search != null) queryParameters['search'] = search;

      final response = await dio.get(
        _transactionsEndpoint,
        queryParameters: queryParameters,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw handleError(e); // Use inherited method
    }
  }

  /// Gets transaction summary for date range
  Future<Map<String, dynamic>> getTransactionSummary({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      final response = await dio.get(
        '$_transactionsEndpoint/summary',
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Gets a single transaction
  Future<Map<String, dynamic>> getTransaction(String transactionId) async {
    try {
      final response = await dio.get('$_transactionsEndpoint/$transactionId');
      return response.data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Updates transaction category
  Future<void> updateTransactionCategory({
    required String transactionId,
    required int categoryId,
  }) async {
    try {
      await dio.put(
        '$_transactionsEndpoint/$transactionId/category',
        data: {'categoryId': categoryId},
      );
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Fetches transactions from bank (Basiq)
  Future<String> fetchTransactions() async {
    try {
      final response = await dio.post('$_transactionsEndpoint/fetch');
      return response.data.toString();
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Gets transactions by category
  Future<List<Map<String, dynamic>>> getTransactionsByCategory({
    required int categoryId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'categoryId': categoryId,
      };
      if (startDate != null) queryParameters['startDate'] = startDate;
      if (endDate != null) queryParameters['endDate'] = endDate;

      final response = await dio.get(
        '$_transactionsEndpoint/category',
        queryParameters: queryParameters,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Gets recent transactions
  Future<List<Map<String, dynamic>>> getRecentTransactions({
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '$_transactionsEndpoint/recent',
        queryParameters: {'limit': limit},
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Gets spending trends
  Future<Map<String, dynamic>> getSpendingTrends({
    String period = 'monthly',
    int limit = 12,
  }) async {
    try {
      final response = await dio.get(
        '$_transactionsEndpoint/trends',
        queryParameters: {
          'period': period,
          'limit': limit,
        },
      );
      return response.data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// Searches transactions
  Future<List<Map<String, dynamic>>> searchTransactions({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await dio.get(
        '$_transactionsEndpoint/search',
        queryParameters: {
          'query': query,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  // Remove the _handleError method since we now inherit handleError from SimpleApiBase
}
