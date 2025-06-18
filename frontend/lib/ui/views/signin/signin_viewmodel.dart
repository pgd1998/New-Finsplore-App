import 'package:flutter/material.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SigninViewModel extends BaseViewModel {
  final _secureStorage = FlutterSecureStorage();

  final _authService = locator<AuthenticationService>();
  final _navService = locator<NavigationService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SharedPreferences? _prefs;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  bool obscurePassword = true;

  void setRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  Future<bool> signIn() async {
    setBusy(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('stayLoggedIn', _rememberMe);
      bool success = await _authService.signIn(
          emailController.text, passwordController.text);
      setBusy(false);
      return success;
    } catch (e) {
      setBusy(false);
      return false;
    }
  }

  // check if the user has already connected via shared preferences
  Future<bool> isUserConnected() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool('stayLoggedIn') ?? false; // default to false
  }

  void navigateToForgotPassword() {
    // Navigate to forgot password page if implemented
  }

  void navigateToMainScreen() {
    _navService.replaceWithMainScreenView();
  }

  void navigateToSignUp() {
    // Navigate to sign up page if implemented
    _navService.navigateTo(Routes.signupView);
  }

  void navigateToLandingPage() {
    // Navigate to landing page if implemented
    _navService.replaceWithSignupBasiqAuthLandingView();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<bool> _getStayLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('stayLoggedIn') ?? false; // default to false
  }

  Future<bool> _isJwtTokenValid() async {
    final authService = locator<AuthenticationService>();
    return authService.hasValidToken;
  }

  void checkSession() async {
    final bool stayLoggedIn = await _getStayLoggedIn();

    if (!stayLoggedIn) {
      await _secureStorage.deleteAll(); // wipe tokens for security
      return;
    }

    final bool loggedIn = await _isJwtTokenValid();

    if (loggedIn) {
      navigateToMainScreen();
    }
  }
}
