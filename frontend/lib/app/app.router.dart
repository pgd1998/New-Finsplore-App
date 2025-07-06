import 'package:flutter/material.dart';
import 'package:finsplore/ui/views/startup/startup_view.dart';
import 'package:finsplore/ui/views/signin/signin_view.dart';
import 'package:finsplore/ui/views/signup/signup_view.dart';
import 'package:finsplore/ui/views/main_screen/main_screen_view.dart';

class Routes {
  static const String startupView = '/startup-view';
  static const String signinView = '/signin-view';
  static const String signupView = '/signup-view';
  static const String mainScreenView = '/main-screen-view';
}

class StackedRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.startupView:
        return MaterialPageRoute(builder: (_) => const StartupView());
      case Routes.signinView:
        return MaterialPageRoute(builder: (_) => const SigninView());
      case Routes.signupView:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case Routes.mainScreenView:
        return MaterialPageRoute(builder: (_) => const MainScreenView());
      default:
        return MaterialPageRoute(builder: (_) => const StartupView());
    }
  }
}