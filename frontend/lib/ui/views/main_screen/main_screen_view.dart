import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
// import '../../widgets/add_new/add_new_item_button.dart';
// import '../../buttons/floating_chatbot_button.dart';
// import '../../widgets/common/nav_bar/nav_bar.dart';
import 'main_screen_viewmodel.dart';

// Tabs
import '../tab_pages/home/home_view.dart';
import '../tab_pages/tracking/tracking_view.dart';
import '../tab_pages/account/account_view.dart';
import '../tab_pages/analytics/analytics_view.dart';

class MainScreenView extends StackedView<MainScreenViewModel> {
  const MainScreenView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainScreenViewModel viewModel,
    Widget? child,
  ) {
    Widget getTabView() {
      switch (viewModel.currentIndex) {
        case 0:
          return const HomeView();
        case 1:
          return const TrackingView();
        case 3:
          return const AnalyticsView();
        case 4:
          return const AccountView();
        default:
          return const Center(child: Text("Unknown Tab"));
      }
    }

    DateTime? currentBackPressTime;

    Future<bool> onWillPop() async {
      final now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppThemeCombos.deepTeal,
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Press back again to exit",
              style: TextStyle(color: AppThemeCombos.aqua),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      SystemNavigator.pop();
      return true;
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await onWillPop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(child: getTabView()),
                ],
              ),
            ),
            // TODO: Add FloatingChatBotButton when copied
          ],
        ),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // TODO: Add BottomNavBar when copied
            Container(
              height: 80,
              color: AppThemeCombos.deepTeal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home, 'Home', viewModel),
                  _buildNavItem(1, Icons.trending_up, 'Tracking', viewModel),
                  SizedBox(width: 60), // Space for FAB
                  _buildNavItem(3, Icons.analytics, 'Analytics', viewModel),
                  _buildNavItem(4, Icons.person, 'Account', viewModel),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppThemeCombos.aqua,
                child: Icon(Icons.add, color: AppThemeCombos.deepTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, MainScreenViewModel viewModel) {
    bool isSelected = viewModel.currentIndex == index;
    return GestureDetector(
      onTap: () => viewModel.setIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? AppThemeCombos.aqua
                : AppThemeCombos.softWhite.withOpacity(0.6),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppThemeCombos.aqua
                  : AppThemeCombos.softWhite.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  MainScreenViewModel viewModelBuilder(BuildContext context) =>
      MainScreenViewModel();
}
