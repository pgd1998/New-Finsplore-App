import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'signup_viewmodel.dart';

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({super.key});

  @override
  Widget builder(BuildContext context, SignupViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 48),
              Text('Sign Up', style: AppTextStyles.heading.copyWith(fontSize: 48)),
              SizedBox(height: 30),
              Text('Create your account', style: AppTextStyles.subheading),
              SizedBox(height: 24),
              
              // First Name
              Text('First Name', style: AppTextStyles.label),
              TextField(
                controller: viewModel.firstNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your first name',
                  prefixIcon: Icon(Icons.person_outline, color: AppThemeCombos.deepTeal),
                ),
              ),
              SizedBox(height: 16),
              
              // Last Name
              Text('Last Name', style: AppTextStyles.label),
              TextField(
                controller: viewModel.lastNameController,
                decoration: InputDecoration(
                  hintText: 'Enter your last name',
                  prefixIcon: Icon(Icons.person_outline, color: AppThemeCombos.deepTeal),
                ),
              ),
              SizedBox(height: 16),
              
              // Email
              Text('Email Address', style: AppTextStyles.label),
              TextField(
                controller: viewModel.emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined, color: AppThemeCombos.deepTeal),
                ),
              ),
              SizedBox(height: 16),
              
              // Mobile Number
              Text('Mobile Number *', style: AppTextStyles.label),
              TextField(
                controller: viewModel.mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter your mobile number (e.g. +61412345678)',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppThemeCombos.deepTeal),
                  helperText: 'Required: Include country code (e.g., +61 for Australia)',
                  helperStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 16),
              
              // Password
              Text('Password', style: AppTextStyles.label),
              TextField(
                controller: viewModel.passwordController,
                obscureText: viewModel.obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline, color: AppThemeCombos.deepTeal),
                  suffixIcon: IconButton(
                    icon: Icon(
                      viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppThemeCombos.deepTeal,
                    ),
                    onPressed: viewModel.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Sign Up Button
              ElevatedButton(
                onPressed: viewModel.signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeCombos.deepTeal,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: AppThemeCombos.aqua),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Sign In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: AppTextStyles.body),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: viewModel.navigateToSignIn,
                    child: Text(
                      'Sign In',
                      style: AppTextStyles.link.copyWith(color: AppThemeCombos.teal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  SignupViewModel viewModelBuilder(BuildContext context) => SignupViewModel();
}
