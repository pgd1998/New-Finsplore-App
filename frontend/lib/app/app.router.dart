// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:finsplore/ui/views/startup/startup_view.dart';
import 'package:finsplore/ui/views/main_screen/main_screen_view.dart';
import 'package:finsplore/ui/views/tab_pages/home/home_view.dart';
import 'package:finsplore/ui/views/signin/signin_view.dart';
import 'package:finsplore/ui/views/signup/signup_view.dart';
import 'package:finsplore/ui/views/tab_pages/tracking/tracking_view.dart';
import 'package:finsplore/ui/views/tab_pages/account/account_view.dart';
import 'package:finsplore/ui/views/tab_pages/analytics/analytics_view.dart';
import 'package:finsplore/ui/views/transactions/all_transactions/all_transactions_view.dart';
import 'package:finsplore/ui/views/goals/goal_management/goal_management_view.dart';
import 'package:finsplore/ui/views/net_balance/net_balance_view.dart';
import 'package:finsplore/ui/views/transactions/transaction_details/transaction_details_view.dart';
import 'package:finsplore/ui/views/goals/goal_details/goal_details_view.dart';
import 'package:finsplore/ui/views/goals/add_new_goal/add_new_goal_view.dart';
import 'package:finsplore/ui/views/assets_liabilities/assets_liabilities_list/assets_liabilities_list_view.dart';

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
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;

  final _routes = <RouteDef>[
    RouteDef(Routes.startupView, page: StartupView),
    RouteDef(Routes.mainScreenView, page: MainScreenView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.signinView, page: SigninView),
    RouteDef(Routes.signupView, page: SignupView),
    RouteDef(Routes.trackingView, page: TrackingView),
    RouteDef(Routes.accountView, page: AccountView),
    RouteDef(Routes.analyticsView, page: AnalyticsView),
    RouteDef(Routes.allTransactionsView, page: AllTransactionsView),
    RouteDef(Routes.goalManagementView, page: GoalManagementView),
    RouteDef(Routes.netBalanceView, page: NetBalanceView),
    RouteDef(Routes.transactionDetailsView, page: TransactionDetailsView),
    RouteDef(Routes.goalDetailsView, page: GoalDetailsView),
    RouteDef(Routes.addNewGoalView, page: AddNewGoalView),
    RouteDef(Routes.assetsLiabilitiesListView, page: AssetsLiabilitiesListView),
  ];

  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;

  final _pagesMap = <Type, StackedRouteFactory>{
    StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartupView(),
        settings: data,
      );
    },
    MainScreenView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MainScreenView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    SigninView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SigninView(),
        settings: data,
      );
    },
    SignupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SignupView(),
        settings: data,
      );
    },
    TrackingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const TrackingView(),
        settings: data,
      );
    },
    AccountView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AccountView(),
        settings: data,
      );
    },
    AnalyticsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AnalyticsView(),
        settings: data,
      );
    },
    AllTransactionsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AllTransactionsView(),
        settings: data,
      );
    },
    GoalManagementView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const GoalManagementView(),
        settings: data,
      );
    },
    NetBalanceView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NetBalanceView(),
        settings: data,
      );
    },
    TransactionDetailsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const TransactionDetailsView(),
        settings: data,
      );
    },
    GoalDetailsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const GoalDetailsView(),
        settings: data,
      );
    },
    AddNewGoalView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddNewGoalView(),
        settings: data,
      );
    },
    AssetsLiabilitiesListView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AssetsLiabilitiesListView(),
        settings: data,
      );
    },
  };
}

extension NavigatorStateExtension on NavigationService {
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
}
