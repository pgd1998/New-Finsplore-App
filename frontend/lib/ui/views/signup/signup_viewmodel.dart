import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> signUp() async {
    setBusy(true);
    
    try {
      bool success = await _authService.signUp(
        emailController.text,
        passwordController.text,
        firstNameController.text,
        lastNameController.text,
      );
      
      if (success) {
        _navigationService.replaceWithMainScreenView();
      } else {
        // Show error message
        // TODO: Add error handling
      }
    } catch (e) {
      // Handle error
      print('Sign up error: $e');
    }
    
    setBusy(false);
  }

  void navigateToSignIn() {
    _navigationService.replaceWithSigninView();
  }
}
