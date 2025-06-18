import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:flutter/material.dart';
import 'package:finsplore/app/app.bottomsheets.dart';
import 'package:finsplore/app/app.dialogs.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Init environment variables
    await dotenv.load(fileName: ".env");
    print('Environment loaded successfully');
  } catch (e) {
    print('Error loading .env file: $e');
    print('Continuing without .env file...');
  }

  try {
    // Setup services
    await setupLocator();
    setupDialogUi();
    setupBottomSheetUi();
    print('Services initialized successfully');
  } catch (e) {
    print('Error setting up services: $e');
  }

  // Initialize Hive database - commented out for now
  // await Hive.initFlutter();
  // Hive.registerAdapters();
  // await Hive.openBox<TransactionModel>(transactionBox);
  // await Hive.openBox<AssetLiabilityModel>(assetLiabilityBox);
  // await Hive.openBox<GoalModel>(goalBox);
  // await Hive.openBox<AccountModel>(accountBox);

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
          surface: AppThemeCombos.softWhite,
        ),

        // Text selection theme
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppThemeCombos.mintGreen.withOpacity(0.3),
          selectionHandleColor: AppThemeCombos.teal,
          cursorColor: AppThemeCombos.teal,
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: AppThemeCombos.deepTeal),
          prefixIconColor: AppThemeCombos.teal,
          suffixIconColor: AppThemeCombos.teal,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppThemeCombos.teal, width: 2.0),
          ),
          border: const OutlineInputBorder(),
        ),

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppThemeCombos.deepTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
    );
  }
}
