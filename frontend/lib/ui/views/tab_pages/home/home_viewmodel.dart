import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.router.dart';
import '../../../../app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void loadData() {
    // TODO: Load real data from API
    setBusy(true);

    // Simulate loading
    Future.delayed(Duration(milliseconds: 500), () {
      setBusy(false);
    });
  }

  void navigateToBills() {
    // TODO: Implement bills navigation
    print('Navigate to Bills');
  }

  void navigateToBudget() {
    // TODO: Implement budget navigation
    print('Navigate to Budget');
  }

  void navigateToAI() {
    // TODO: Implement AI assistant navigation
    print('Navigate to AI Assistant');
  }

  void navigateToGoals() {
    // TODO: Implement goals navigation
    print('Navigate to Goals');
  }
}
