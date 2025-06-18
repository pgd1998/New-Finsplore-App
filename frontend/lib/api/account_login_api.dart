import 'package:finsplore/api/base_api.dart';
import 'package:finsplore/model/account.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API service for user authentication (login).
/// Updated to work with the unified Finsplore backend structure.
class AccountLoginApi extends BaseApi<Account> {
  AccountLoginApi() : super(Account.fromJson, prefix: "/api/auth/login", useAuth: false);

  final _secureStorage = FlutterSecureStorage();

  /// Authenticate user with email and password
  /// Returns true if login successful, false otherwise
  Future<bool> login(String email, String password) {
    final loginData = Account(
      email: email, 
      password: password, 
      username: '', // Not required for login
      phoneNumber: ''
    );
    
    return super.create(loginData).then((result) {
      if (result.success && result.data != null) {
        // Extract token from the response
        // The backend returns: {"userId": ..., "email": ..., "token": "...", ...}
        final responseData = result.data as Map<String, dynamic>;
        final String token = responseData['token'] ?? '';
        
        if (token.isNotEmpty) {
          // Store JWT token securely
          _secureStorage.write(key: 'jwt_token', value: token);
          
          // Store additional user info if needed
          _secureStorage.write(key: 'user_email', value: responseData['email'] ?? '');
          _secureStorage.write(key: 'user_id', value: responseData['userId']?.toString() ?? '');
          
          return true;
        }
      }
      
      return false;
    }).catchError((error) {
      print('Login error: $error');
      return false;
    });
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
  
  /// Logout user by clearing stored credentials
  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
