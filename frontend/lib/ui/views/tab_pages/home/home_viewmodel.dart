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
    _navigationService.navigateTo(Routes.billsView);
  }

  void navigateToBudget() {
    _navigationService.navigateTo(Routes.budgetView);
  }

  void navigateToAI() {
    _navigationService.navigateTo(Routes.aIAssistantView);
  }

  void navigateToGoals() {
    _navigationService.navigateTo(Routes.goalManagementView);
  }
}
