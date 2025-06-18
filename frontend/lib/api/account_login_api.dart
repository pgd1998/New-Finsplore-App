import 'package:finsplore/api/base_api.dart';
import 'package:finsplore/model/account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API service for user authentication (login).
/// Updated to work with the unified Finsplore backend structure.
class AccountLoginApi extends BaseApi<Account> {
  AccountLoginApi()
      : super(Account.fromJson, prefix: "/api/auth/login", useAuth: false);

  final _secureStorage = FlutterSecureStorage();

  /// Authenticate user with email and password
  /// Returns the login response data if successful, null otherwise
  Future<Map<String, dynamic>?> login(String email, String password) {
    final loginData = Account(
        email: email,
        password: password,
        username: '', // Not required for login
        phoneNumber: '');

    return super.create(loginData).then((result) {
      if (result.success && result.data != null) {
        // Extract data from the response
        // The backend returns: {"userId": ..., "email": ..., "token": "...", "firstName": ..., "lastName": ...}
        final responseData = result.data as Map<String, dynamic>;
        final String token = responseData['token'] ?? '';

        if (token.isNotEmpty) {
          // Store JWT token securely
          _secureStorage.write(key: 'jwt_token', value: token);

          // Store additional user info if needed
          _secureStorage.write(
              key: 'user_email', value: responseData['email'] ?? '');
          _secureStorage.write(
              key: 'user_id', value: responseData['userId']?.toString() ?? '');
          _secureStorage.write(
              key: 'user_first_name', value: responseData['firstName'] ?? '');
          _secureStorage.write(
              key: 'user_last_name', value: responseData['lastName'] ?? '');

          // Return the complete response data for use in AuthenticationService
          return responseData;
        }
      }

      return null;
    }).catchError((error) {
      print('Login error: $error');
      return null;
    });
  }

  /// Alternative method that returns boolean (for backward compatibility)
  Future<bool> loginSimple(String email, String password) async {
    final result = await login(email, password);
    return result != null;
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }

  /// Get current user's stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  /// Get stored user data
  Future<Map<String, String?>> getStoredUserData() async {
    return {
      'token': await _secureStorage.read(key: 'jwt_token'),
      'email': await _secureStorage.read(key: 'user_email'),
      'userId': await _secureStorage.read(key: 'user_id'),
      'firstName': await _secureStorage.read(key: 'user_first_name'),
      'lastName': await _secureStorage.read(key: 'user_last_name'),
    };
  }

  /// Logout user by clearing stored credentials
  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
