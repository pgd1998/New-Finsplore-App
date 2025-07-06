// FIXED SIGNUP VIEWMODEL
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

  Future<bool> signUp() async {
    setBusy(true);

    try {
      print('Starting signup process...');
      print('Email: ${emailController.text}');
      print('First Name: ${firstNameController.text}');
      print('Last Name: ${lastNameController.text}');

      bool success = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text,
        firstNameController.text.trim(),
        lastNameController.text.trim(),
      );

      print('Signup result: $success');

      if (success) {
        print('Signup successful, navigating to main screen...');
        // Clear the form
        _clearForm();
        // Navigate to main screen
        _navigationService.replaceWith(Routes.mainScreenView);
        setBusy(false);
        return true;
      } else {
        print('Signup failed');
        setBusy(false);
        return false;
      }
    } catch (e) {
      print('Sign up error: $e');
      setBusy(false);
      return false;
    }
  }

  void _clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void navigateToSignIn() {
    _navigationService.replaceWith(Routes.signinView);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
