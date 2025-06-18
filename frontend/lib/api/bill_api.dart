import 'package:dio/dio.dart';
import 'base_api.dart';

class BillAPI extends BaseAPI {
  static const String _billsEndpoint = '/api/bills';

  /// Creates a new bill
  Future<Map<String, dynamic>> createBill({
    required int userId,
    required String name,
    required double amount,
    required String date,
  }) async {
    try {
      final response = await dio.post(
        '$_billsEndpoint/set',
        data: {
          'userId': userId,
          'name': name,
          'amount': amount,
          'date': date,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Gets all bills for a user
  Future<List<Map<String, dynamic>>> getUserBills(int userId) async {
    try {
      final response = await dio.get('$_billsEndpoint/$userId');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Deletes a bill
  Future<void> deleteBill(int billId) async {
    try {
      await dio.delete('$_billsEndpoint/delete/$billId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      return Exception('Bill API Error: ${error.response?.data?['message'] ?? error.message}');
    }
    return Exception('Unexpected error: $error');
  }
}
