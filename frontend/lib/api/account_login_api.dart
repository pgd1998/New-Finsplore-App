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
        // The backend returns: {"code": 0, "message": "...", "data": {...}}
        // So we need to access the nested 'data' field
        final responseData = result.data as Map<String, dynamic>;

        // Check if the response has the expected structure
        if (responseData['code'] == 0 && responseData['data'] != null) {
          final userData = responseData['data'] as Map<String, dynamic>;
          final String token = userData['token'] ?? '';

          if (token.isNotEmpty) {
            // Store JWT token securely
            _secureStorage.write(key: 'jwt_token', value: token);

            // Store additional user info if needed
            _secureStorage.write(
                key: 'user_email', value: userData['email'] ?? '');
            _secureStorage.write(
                key: 'user_id', value: userData['userId']?.toString() ?? '');
            _secureStorage.write(
                key: 'user_first_name', value: userData['firstName'] ?? '');
            _secureStorage.write(
                key: 'user_last_name', value: userData['lastName'] ?? '');
            _secureStorage.write(
                key: 'user_display_name', value: userData['displayName'] ?? '');
            _secureStorage.write(
                key: 'user_full_name', value: userData['fullName'] ?? '');

            // Return the user data (not the wrapper)
            return userData;
          }
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
      'displayName': await _secureStorage.read(key: 'user_display_name'),
      'fullName': await _secureStorage.read(key: 'user_full_name'),
    };
  }

  /// Logout user by clearing stored credentials
  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
