// FIXED SIGNIN VIEWMODEL
import 'package:flutter/material.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:finsplore/ui/views/signup/signup_view.dart';
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
      print('Starting signin process...');
      print('Email: ${emailController.text}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('stayLoggedIn', _rememberMe);

      bool success = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      print('Signin result: $success');

      if (success) {
        print('Signin successful, navigating to main screen...');
        // Clear the form
        _clearForm();
        // Navigate to main screen
        _navService.replaceWith(Routes.mainScreenView);
        setBusy(false);
        return true;
      } else {
        print('Signin failed');
        setBusy(false);
        return false;
      }
    } catch (e) {
      print('Sign in error: $e');
      setBusy(false);
      return false;
    }
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
  }

  // check if the user has already connected via shared preferences
  Future<bool> isUserConnected() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool('stayLoggedIn') ?? false;
  }

  void navigateToForgotPassword() {
    // Navigate to forgot password page if implemented
  }

  void navigateToMainScreen() {
    _navService.replaceWith(Routes.mainScreenView);
  }

  void navigateToSignUp() {
    _navService.navigateTo(Routes.signupView);
  }

  void navigateToLandingPage() {
    _navService.replaceWith(Routes.startupView);
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<bool> _getStayLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('stayLoggedIn') ?? false;
  }

  Future<bool> _isJwtTokenValid() async {
    final authService = locator<AuthenticationService>();
    return authService.hasValidToken;
  }

  void checkSession() async {
    final bool stayLoggedIn = await _getStayLoggedIn();

    if (!stayLoggedIn) {
      await _secureStorage.deleteAll();
      return;
    }

    final bool loggedIn = await _isJwtTokenValid();

    if (loggedIn) {
      navigateToMainScreen();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
