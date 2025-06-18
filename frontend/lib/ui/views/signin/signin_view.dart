import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'signin_viewmodel.dart';
import 'package:finsplore/ui/common/ui_helpers.dart';
import 'package:finsplore/ui/common/app_text_styles.dart';

class SigninView extends StackedView<SigninViewModel> {
  const SigninView({super.key});

  @override
  void onViewModelReady(SigninViewModel viewModel) {
    // Check for valid session when the page loads
    viewModel.checkSession();
  }

  @override
  Widget builder(
      BuildContext context, SigninViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  Text('Sign In',
                      style: AppTextStyles.heading.copyWith(fontSize: 48)),
                  verticalSpaceMedium,
                  const SizedBox(height: 30),
                  Text('Hi, Welcome Back! 👋', style: AppTextStyles.subheading),
                  verticalSpaceSmall,
                  Text('Continue your journey to your goal',
                      style: AppTextStyles.body),
                  verticalSpaceMedium,
                  Text('Email Address', style: AppTextStyles.label),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.email_outlined,
                            color: AppThemeCombos.deepTeal, size: 20),
                      ),
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                    controller: viewModel.emailController,
                  ),
                  verticalSpaceSmall,
                  Text('Password', style: AppTextStyles.label),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.lock_outline,
                          color: AppThemeCombos.deepTeal,
                          size: 20, // Smaller icon size
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppThemeCombos.deepTeal,
                          size: 20,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                    controller: viewModel.passwordController,
                    obscureText: viewModel.obscurePassword,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            activeColor: AppThemeCombos.deepTeal,
                            value: viewModel.rememberMe,
                            onChanged: viewModel.setRememberMe,
                          ),
                          Text(' Remember Me', style: AppTextStyles.body),
                        ],
                      ),
                      GestureDetector(
                        onTap: viewModel.navigateToForgotPassword,
                        child: Text('Forgot Password?',
                            style: AppTextStyles.link
                                .copyWith(color: AppThemeCombos.teal)),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppThemeCombos.deepTeal)),
                    onPressed: () async {
                      bool success = await viewModel.signIn();
                      if (success && await viewModel.isUserConnected()) {
                        viewModel.navigateToMainScreen();
                      } else if (success &&
                          !await viewModel.isUserConnected()) {
                        // User is signed in but not connected, navigate to landing page
                        viewModel.navigateToLandingPage();
                      } else {
                        // ignore: use_build_context_synchronously
                        _showError(context, 'Login Failed',
                            'Invalid credentials or lost connection. Please try again.');
                      }
                    },
                    child: Center(
                        child: Text('Sign In',
                            style: TextStyle(color: AppThemeCombos.aqua))),
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: AppTextStyles.body),
                      horizontalSpaceTiny,
                      GestureDetector(
                        onTap: viewModel.navigateToSignUp,
                        child: Text('Sign Up',
                            style: AppTextStyles.link
                                .copyWith(color: AppThemeCombos.teal)),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 24), // for breathing room when keyboard is up
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  SigninViewModel viewModelBuilder(BuildContext context) => SigninViewModel();
}
