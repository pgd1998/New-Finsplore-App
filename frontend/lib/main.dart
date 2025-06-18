import 'package:finsplore/hive/hive_registrar.g.dart';
import 'package:finsplore/local_storage/db_model/transaction_model.dart';
import 'package:finsplore/local_storage/db_model/goal_model.dart';
import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:flutter/material.dart';
import 'package:finsplore/app/app.bottomsheets.dart';
import 'package:finsplore/app/app.dialogs.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:finsplore/local_storage/hive_boxes.dart';
import 'package:finsplore/local_storage/db_model/asset_liability_model.dart';
import 'package:finsplore/local_storage/db_model/account_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Init environment variables
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  // Initialize Hive database
  await Hive.initFlutter();
  Hive.registerAdapters();

  await Hive.openBox<TransactionModel>(transactionBox);
  await Hive.openBox<AssetLiabilityModel>(assetLiabilityBox);
  await Hive.openBox<GoalModel>(goalBox);
  await Hive.openBox<AccountModel>(accountBox);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finsplore - Financial Management',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
      theme: ThemeData(
        // Primary colors
        primaryColor: AppThemeCombos.deepTeal,
        scaffoldBackgroundColor: AppThemeCombos.softWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppThemeCombos.deepTeal,
          primary: AppThemeCombos.deepTeal,
          secondary: AppThemeCombos.teal,
          tertiary: AppThemeCombos.mintGreen,
          background: AppThemeCombos.softWhite,
        ),

        // Text selection theme
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppThemeCombos.mintGreen.withOpacity(0.3),
          selectionHandleColor: AppThemeCombos.teal,
          cursorColor: AppThemeCombos.teal,
        ),

        // Date picker theme
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppThemeCombos.softWhite,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: AppThemeCombos.teal,
          headerForegroundColor: Colors.white,
          dayBackgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppThemeCombos.deepTeal
                : AppThemeCombos.softWhite,
          ),
          todayBackgroundColor: WidgetStateProperty.all(
              AppThemeCombos.mintGreen.withOpacity(0.3)),
          todayForegroundColor:
              WidgetStateProperty.all(AppThemeCombos.deepTeal),
          dayForegroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.selected) ? Colors.white : null,
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: AppThemeCombos.deepTeal),
          prefixIconColor: AppThemeCombos.teal,
          suffixIconColor: AppThemeCombos.teal,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppThemeCombos.teal, width: 2.0),
          ),
          border: OutlineInputBorder(),
        ),

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeCombos.deepTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
    );
  }
}
