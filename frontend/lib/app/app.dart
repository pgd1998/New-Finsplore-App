import 'package:finsplore/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:finsplore/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:finsplore/ui/views/tab_pages/home/home_view.dart';
import 'package:finsplore/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:finsplore/ui/views/main_screen/main_screen_view.dart';
import 'package:finsplore/services/authentication_service.dart';
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
import 'package:finsplore/ui/views/bills/bills_view.dart';
import 'package:finsplore/ui/views/budget/budget_view.dart';
import 'package:finsplore/ui/views/ai_assistant/ai_assistant_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: MainScreenView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: SigninView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: TrackingView),
    MaterialRoute(page: AccountView),
    MaterialRoute(page: AnalyticsView),
    MaterialRoute(page: AllTransactionsView),
    MaterialRoute(page: GoalManagementView),
    MaterialRoute(page: NetBalanceView),
    MaterialRoute(page: TransactionDetailsView),
    MaterialRoute(page: GoalDetailsView),
    MaterialRoute(page: AddNewGoalView),
    MaterialRoute(page: AssetsLiabilitiesListView),
    MaterialRoute(page: BillsView),
    MaterialRoute(page: BudgetView),
    MaterialRoute(page: AIAssistantView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: AuthenticationService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
