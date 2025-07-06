import 'package:stacked_services/stacked_services.dart';
import 'package:finsplore/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:finsplore/app/app.locator.dart';

enum DialogType {
  infoAlert,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.infoAlert: (context, request, completer) =>
        InfoAlertDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}