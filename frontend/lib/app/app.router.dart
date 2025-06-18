// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:finsplore/ui/views/ai_assistant/ai_assistant_view.dart' as _i19;
import 'package:finsplore/ui/views/assets_liabilities/assets_liabilities_list/assets_liabilities_list_view.dart'
    as _i16;
import 'package:finsplore/ui/views/bills/bills_view.dart' as _i17;
import 'package:finsplore/ui/views/budget/budget_view.dart' as _i18;
import 'package:finsplore/ui/views/goals/add_new_goal/add_new_goal_view.dart'
    as _i15;
import 'package:finsplore/ui/views/goals/goal_details/goal_details_view.dart'
    as _i14;
import 'package:finsplore/ui/views/goals/goal_management/goal_management_view.dart'
    as _i11;
import 'package:finsplore/ui/views/main_screen/main_screen_view.dart' as _i3;
import 'package:finsplore/ui/views/net_balance/net_balance_view.dart' as _i12;
import 'package:finsplore/ui/views/signin/signin_view.dart' as _i5;
import 'package:finsplore/ui/views/signup/signup_view.dart' as _i6;
import 'package:finsplore/ui/views/startup/startup_view.dart' as _i2;
import 'package:finsplore/ui/views/tab_pages/account/account_view.dart' as _i8;
import 'package:finsplore/ui/views/tab_pages/analytics/analytics_view.dart'
    as _i9;
import 'package:finsplore/ui/views/tab_pages/home/home_view.dart' as _i4;
import 'package:finsplore/ui/views/tab_pages/tracking/tracking_view.dart'
    as _i7;
import 'package:finsplore/ui/views/transactions/all_transactions/all_transactions_view.dart'
    as _i10;
import 'package:finsplore/ui/views/transactions/transaction_details/transaction_details_view.dart'
    as _i13;
import 'package:flutter/material.dart' as _i20;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i21;

class Routes {
  static const startupView = '/startup-view';

  static const mainScreenView = '/main-screen-view';

  static const homeView = '/home-view';

  static const signinView = '/signin-view';

  static const signupView = '/signup-view';

  static const trackingView = '/tracking-view';

  static const accountView = '/account-view';

  static const analyticsView = '/analytics-view';

  static const allTransactionsView = '/all-transactions-view';

  static const goalManagementView = '/goal-management-view';

  static const netBalanceView = '/net-balance-view';

  static const transactionDetailsView = '/transaction-details-view';

  static const goalDetailsView = '/goal-details-view';

  static const addNewGoalView = '/add-new-goal-view';

  static const assetsLiabilitiesListView = '/assets-liabilities-list-view';

  static const billsView = '/bills-view';

  static const budgetView = '/budget-view';

  static const aIAssistantView = '/a-iassistant-view';

  static const all = <String>{
    startupView,
    mainScreenView,
    homeView,
    signinView,
    signupView,
    trackingView,
    accountView,
    analyticsView,
    allTransactionsView,
    goalManagementView,
    netBalanceView,
    transactionDetailsView,
    goalDetailsView,
    addNewGoalView,
    assetsLiabilitiesListView,
    billsView,
    budgetView,
    aIAssistantView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.mainScreenView,
      page: _i3.MainScreenView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i4.HomeView,
    ),
    _i1.RouteDef(
      Routes.signinView,
      page: _i5.SigninView,
    ),
    _i1.RouteDef(
      Routes.signupView,
      page: _i6.SignupView,
    ),
    _i1.RouteDef(
      Routes.trackingView,
      page: _i7.TrackingView,
    ),
    _i1.RouteDef(
      Routes.accountView,
      page: _i8.AccountView,
    ),
    _i1.RouteDef(
      Routes.analyticsView,
      page: _i9.AnalyticsView,
    ),
    _i1.RouteDef(
      Routes.allTransactionsView,
      page: _i10.AllTransactionsView,
    ),
    _i1.RouteDef(
      Routes.goalManagementView,
      page: _i11.GoalManagementView,
    ),
    _i1.RouteDef(
      Routes.netBalanceView,
      page: _i12.NetBalanceView,
    ),
    _i1.RouteDef(
      Routes.transactionDetailsView,
      page: _i13.TransactionDetailsView,
    ),
    _i1.RouteDef(
      Routes.goalDetailsView,
      page: _i14.GoalDetailsView,
    ),
    _i1.RouteDef(
      Routes.addNewGoalView,
      page: _i15.AddNewGoalView,
    ),
    _i1.RouteDef(
      Routes.assetsLiabilitiesListView,
      page: _i16.AssetsLiabilitiesListView,
    ),
    _i1.RouteDef(
      Routes.billsView,
      page: _i17.BillsView,
    ),
    _i1.RouteDef(
      Routes.budgetView,
      page: _i18.BudgetView,
    ),
    _i1.RouteDef(
      Routes.aIAssistantView,
      page: _i19.AIAssistantView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.MainScreenView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.MainScreenView(),
        settings: data,
      );
    },
    _i4.HomeView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.HomeView(),
        settings: data,
      );
    },
    _i5.SigninView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.SigninView(),
        settings: data,
      );
    },
    _i6.SignupView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.SignupView(),
        settings: data,
      );
    },
    _i7.TrackingView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.TrackingView(),
        settings: data,
      );
    },
    _i8.AccountView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.AccountView(),
        settings: data,
      );
    },
    _i9.AnalyticsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.AnalyticsView(),
        settings: data,
      );
    },
    _i10.AllTransactionsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.AllTransactionsView(),
        settings: data,
      );
    },
    _i11.GoalManagementView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i11.GoalManagementView(),
        settings: data,
      );
    },
    _i12.NetBalanceView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.NetBalanceView(),
        settings: data,
      );
    },
    _i13.TransactionDetailsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.TransactionDetailsView(),
        settings: data,
      );
    },
    _i14.GoalDetailsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i14.GoalDetailsView(),
        settings: data,
      );
    },
    _i15.AddNewGoalView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i15.AddNewGoalView(),
        settings: data,
      );
    },
    _i16.AssetsLiabilitiesListView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i16.AssetsLiabilitiesListView(),
        settings: data,
      );
    },
    _i17.BillsView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i17.BillsView(),
        settings: data,
      );
    },
    _i18.BudgetView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i18.BudgetView(),
        settings: data,
      );
    },
    _i19.AIAssistantView: (data) {
      return _i20.MaterialPageRoute<dynamic>(
        builder: (context) => const _i19.AIAssistantView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i21.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMainScreenView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.mainScreenView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSigninView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signinView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTrackingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.trackingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.accountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAnalyticsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.analyticsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAllTransactionsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.allTransactionsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGoalManagementView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.goalManagementView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToNetBalanceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.netBalanceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTransactionDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.transactionDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGoalDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.goalDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddNewGoalView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addNewGoalView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAssetsLiabilitiesListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.assetsLiabilitiesListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBillsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.billsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBudgetView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.budgetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAIAssistantView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.aIAssistantView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainScreenView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.mainScreenView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSigninView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signinView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTrackingView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.trackingView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAccountView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.accountView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAnalyticsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.analyticsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAllTransactionsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.allTransactionsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGoalManagementView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.goalManagementView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithNetBalanceView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.netBalanceView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithTransactionDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.transactionDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGoalDetailsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.goalDetailsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddNewGoalView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addNewGoalView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAssetsLiabilitiesListView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.assetsLiabilitiesListView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBillsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.billsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithBudgetView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.budgetView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAIAssistantView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.aIAssistantView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
