import 'package:stacked/stacked.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class AccountViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  String get userName => _authService.getDisplayName();
  String get userEmail => _authService.email ?? 'user@example.com';

  void initialize() {
    // Load user data
  }

  Future<void> logout() async {
    setBusy(true);
    await _authService.signOut();
    _navigationService.clearStackAndShow(Routes.signinView);
    setBusy(false);
  }
}
