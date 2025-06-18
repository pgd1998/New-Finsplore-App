/// Application constants and configuration values.
/// Updated for the unified Finsplore backend structure.
class Consts {
  
  /// Request configuration constants
  static const request = RequestConsts();
  
  /// API configuration constants  
  static const api = ApiConsts();

  /// Authentication constants
  static const auth = AuthConsts();

  /// Storage keys constants
  static const storage = StorageConsts();
}

/// Request-related constants
class RequestConsts {
  const RequestConsts();
  
  /// Default page size for paginated requests
  int get pageSize => 20;
  
  /// Request timeout in milliseconds
  int get timeout => 30000;
  
  /// Maximum retry attempts
  int get maxRetries => 3;
}

/// API endpoint constants
class ApiConsts {
  const ApiConsts();
  
  /// Authentication endpoints
  String get login => '/api/auth/login';
  String get register => '/api/auth/register';
  String get logout => '/api/auth/logout';
  String get refreshToken => '/api/auth/refresh';
  
  /// User endpoints
  String get userProfile => '/api/users/profile';
  String get userUpdate => '/api/users/profile';
  
  /// Transaction endpoints
  String get transactions => '/api/transactions';
  String get transactionSummary => '/api/transactions/summary';
  
  /// Goal endpoints
  String get goals => '/api/goals';
  
  /// Category endpoints
  String get categories => '/api/categories';
}

/// Authentication constants
class AuthConsts {
  const AuthConsts();
  
  /// Token storage key
  String get tokenKey => 'jwt_token';
  
  /// User ID storage key
  String get userIdKey => 'user_id';
  
  /// Email storage key
  String get emailKey => 'user_email';
  
  /// Token expiry key
  String get tokenExpiryKey => 'token_expiry';
}

/// Local storage keys
class StorageConsts {
  const StorageConsts();
  
  /// User preferences
  String get userPreferences => 'user_preferences';
  
  /// App settings
  String get appSettings => 'app_settings';
  
  /// Cached data
  String get cachedData => 'cached_data';
  
  /// Theme preferences
  String get themePreferences => 'theme_preferences';
}
