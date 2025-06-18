import 'package:finsplore/ui/common/colors_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finsplore/app/app.bottomsheets.dart';
import 'package:finsplore/app/app.dialogs.dart';
import 'package:finsplore/app/app.locator.dart';
import 'package:finsplore/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (optional)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
    // You might want to show a fallback error screen here
  }

  // Initialize Hive database - commented out for now
  // await Hive.initFlutter();
  // Hive.registerAdapters();
  // await Hive.openBox<TransactionModel>(transactionBox);
  // await Hive.openBox<AssetLiabilityModel>(assetLiabilityBox);
  // await Hive.openBox<GoalModel>(goalBox);
  // await Hive.openBox<AccountModel>(accountBox);

  // Global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

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

      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Page Not Found')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Page not found: ${settings.name}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(Routes.startupView),
                    child: Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },

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

        // App bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppThemeCombos.deepTeal,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
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

        // Card theme - FIXED: Use CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          color: AppThemeCombos.softWhite,
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppThemeCombos.softWhite,
          selectedItemColor: AppThemeCombos.deepTeal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
