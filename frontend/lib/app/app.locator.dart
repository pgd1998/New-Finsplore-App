import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:finsplore/services/authentication_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Register services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => AuthenticationService());
}