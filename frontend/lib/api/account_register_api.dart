import 'package:finsplore/api/base_api.dart';
import 'package:finsplore/model/account.dart';

/// API service for user registration.
/// Updated to work with the unified Finsplore backend structure.
class AccountRegisterApi extends BaseApi<Account> {
  AccountRegisterApi()
      : super(Account.fromJson, prefix: "/api/auth/register", useAuth: false);

  /// Register a new user account
  /// Returns true if registration successful, false otherwise
  Future<bool> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      String? middleName,
      String? username,
      String? phoneNumber}) {
    // Create account data matching backend UserRegistrationRequest structure
    final registrationData = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'username': username,
      'mobileNumber': phoneNumber,
    };

    // Remove null values
    registrationData.removeWhere((key, value) => value == null);

    return super.create(Account.fromJson(registrationData)).then((result) {
      if (result.success && result.data != null) {
        // The backend returns: {"code": 0, "message": "...", "data": {...}}
        final responseData = result.data as Map<String, dynamic>;

        // Check if the response has the expected structure
        if (responseData['code'] == 0) {
          print('Registration successful for user: $email');
          print('Response: ${responseData['message']}');
          return true;
        } else {
          print('Registration failed: ${responseData['message']}');
          return false;
        }
      } else {
        print('Registration failed: ${result.message}');
        return false;
      }
    }).catchError((error) {
      print('Registration error: $error');
      return false;
    });
  }

  /// Legacy method for backward compatibility
  Future<bool> registerLegacy(
      String email, String password, String username, String phoneNumber) {
    final accountRegister = Account(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber);
    return super.create(accountRegister).then((result) => result.success);
  }
}
