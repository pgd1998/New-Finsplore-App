import 'package:stacked/stacked.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:finsplore/app/app.router.dart';

class StartupViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  Future runStartupLogic() async {
    // Initialize authentication service
    await _authenticationService.initialize();
    
    await Future.delayed(Duration(seconds: 2));

    if (_authenticationService.isSignedIn) {
      _navigationService.replaceWithMainScreenView();
    } else {
      _navigationService.replaceWithSigninView();
    }
  }
}
