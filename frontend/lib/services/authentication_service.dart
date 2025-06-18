import 'package:stacked/stacked.dart';
import 'package:finsplore/api/account_login_api.dart';
import 'package:finsplore/api/account_register_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService with ListenableServiceMixin {
  bool _isSignedIn = false;
  String? _userId;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _token;

  bool get isSignedIn => _isSignedIn;
  String? get userId => _userId;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get token => _token;

  final AccountLoginApi _accountLoginApi = AccountLoginApi();
  final AccountRegisterApi _accountRegisterApi = AccountRegisterApi();

  final _secureStorage = FlutterSecureStorage();

  // Storage keys
  static const String _keyIsSignedIn = 'isSignedIn';
  static const String _keyUserId = 'userId';
  static const String _keyEmail = 'email';
  static const String _keyFirstName = 'firstName';
  static const String _keyLastName = 'lastName';
  static const String _keyToken = 'token';

  // Initialize service - check if user is already logged in
  Future<void> initialize() async {
    final isSignedIn = await _secureStorage.read(key: _keyIsSignedIn);
    if (isSignedIn == 'true') {
      _isSignedIn = true;
      _userId = await _secureStorage.read(key: _keyUserId);
      _email = await _secureStorage.read(key: _keyEmail);
      _firstName = await _secureStorage.read(key: _keyFirstName);
      _lastName = await _secureStorage.read(key: _keyLastName);
      _token = await _secureStorage.read(key: _keyToken);
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      // Call the updated login API
      final response = await _accountLoginApi.login(email, password);
      
      if (response != null && response['token'] != null) {
        // Store authentication data from new backend format
        await _storeAuthData(
          userId: response['userId']?.toString(),
          email: response['email'],
          firstName: response['firstName'],
          lastName: response['lastName'],
          token: response['token'],
        );
        
        _isSignedIn = true;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Sign in error: $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String firstName, String lastName) async {
    try {
      final res = await _accountRegisterApi.register(email, password, firstName, lastName);
      
      // If registration successful, automatically sign in
      if (res) {
        return await signIn(email, password);
      }
      
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    _userId = null;
    _email = null;
    _firstName = null;
    _lastName = null;
    _token = null;
    
    // Clear secure storage
    await _secureStorage.deleteAll();
    
    notifyListeners();
  }

  // Store authentication data securely
  Future<void> _storeAuthData({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? token,
  }) async {
    _userId = userId;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _token = token;

    // Store in secure storage
    await _secureStorage.write(key: _keyIsSignedIn, value: 'true');
    if (userId != null) await _secureStorage.write(key: _keyUserId, value: userId);
    if (email != null) await _secureStorage.write(key: _keyEmail, value: email);
    if (firstName != null) await _secureStorage.write(key: _keyFirstName, value: firstName);
    if (lastName != null) await _secureStorage.write(key: _keyLastName, value: lastName);
    if (token != null) await _secureStorage.write(key: _keyToken, value: token);
  }

  // Get authorization header for API calls
  Map<String, String> getAuthHeaders() {
    if (_token != null) {
      return {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };
    }
    return {
      'Content-Type': 'application/json',
    };
  }

  // Get user display name
  String getDisplayName() {
    if (_firstName != null && _lastName != null) {
      return '$_firstName $_lastName';
    } else if (_firstName != null) {
      return _firstName!;
    } else if (_email != null) {
      return _email!;
    }
    return 'User';
  }

  // Check if token is valid (simple check)
  bool get hasValidToken => _token != null && _token!.isNotEmpty;
}
