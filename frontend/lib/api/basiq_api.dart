import 'package:finsplore/model/result.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:dio/dio.dart';

/// API class for Basiq bank connection operations
class BasiqApi {
  final Dio _dio = Dio();
  final AuthenticationService _authService = locator<AuthenticationService>();

  /// Get headers with JWT token for authenticated requests
  Map<String, String> get _headers {
    final token = _authService.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.token != null;

  /// Creates a Basiq user for the current app user
  Future<Map<String, dynamic>?> createBasiqUser() async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/api/basiq/create-user',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error creating Basiq user: $e');
      return null;
    }
  }

  /// Generates an authentication link for bank connection
  Future<Map<String, dynamic>?> generateAuthLink() async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/api/basiq/auth-link',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error generating auth link: $e');
      return null;
    }
  }

  /// Gets connected bank accounts for the user
  Future<Map<String, dynamic>?> getConnectedAccounts() async {
    try {
      final response = await _dio.get(
        'http://127.0.0.1:8080/api/basiq/accounts',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error fetching accounts: $e');
      return null;
    }
  }

  /// Fetches transactions from connected bank accounts
  Future<Map<String, dynamic>?> fetchTransactions() async {
    try {
      final response = await _dio.get(
        'http://127.0.0.1:8080/api/basiq/transactions',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error fetching transactions: $e');
      return null;
    }
  }

  /// Gets account balances from connected banks
  Future<Map<String, dynamic>?> getAccountBalances() async {
    try {
      final response = await _dio.get(
        'http://127.0.0.1:8080/api/basiq/balances',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error fetching balances: $e');
      return null;
    }
  }

  /// Refreshes data from connected bank accounts
  Future<Map<String, dynamic>?> refreshBankData() async {
    try {
      final response = await _dio.post(
        'http://127.0.0.1:8080/api/basiq/refresh',
        options: Options(headers: _headers),
      );
      return response.data;
    } catch (e) {
      print('Error refreshing bank data: $e');
      return null;
    }
  }
}
