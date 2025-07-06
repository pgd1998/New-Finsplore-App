import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:finsplore/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:animate_do/animate_do.dart';
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
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppThemeCombos.deepTeal.withOpacity(0.95),
                    AppThemeCombos.deepTeal,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernNavItem(0, Icons.home_filled, 'Home', viewModel),
                  _buildModernNavItem(1, Icons.trending_up, 'Tracking', viewModel),
                  const SizedBox(width: 60), // Space for FAB
                  _buildModernNavItem(3, Icons.analytics, 'Analytics', viewModel),
                  _buildModernNavItem(4, Icons.person, 'Account', viewModel),
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              child: SlideInUp(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFCFFDFE), Color(0xFF9CDCB7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeCombos.aqua.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(
                      Icons.add,
                      color: AppThemeCombos.deepTeal,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNavItem(
      int index, IconData icon, String label, MainScreenViewModel viewModel) {
    bool isSelected = viewModel.currentIndex == index;
    return GestureDetector(
      onTap: () => viewModel.setIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppThemeCombos.aqua.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected
                    ? AppThemeCombos.aqua
                    : AppThemeCombos.softWhite.withOpacity(0.7),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppThemeCombos.aqua
                    : AppThemeCombos.softWhite.withOpacity(0.7),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
