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
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<bool> signUp() async {
    setBusy(true);

    try {
      // Validate mobile number is provided and has proper format
      String mobileNumber = mobileNumberController.text.trim();
      if (mobileNumber.isEmpty) {
        // Show error to user
        print('Mobile number is required');
        setBusy(false);
        return false;
      }
      
      // Basic validation for mobile number format (should start with + and contain digits)
      if (!RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(mobileNumber)) {
        print('Please enter a valid mobile number with country code (e.g., +61412345678)');
        setBusy(false);
        return false;
      }

      print('Starting signup process...');
      print('Email: ${emailController.text}');
      print('First Name: ${firstNameController.text}');
      print('Last Name: ${lastNameController.text}');
      print('Mobile Number: ${mobileNumberController.text}');

      bool success = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text,
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        mobileNumberController.text.trim(),
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
    mobileNumberController.clear();
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
    mobileNumberController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
