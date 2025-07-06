import 'package:stacked_services/stacked_services.dart';
import 'package:finsplore/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:finsplore/app/app.locator.dart';

enum BottomSheetType {
  notice,
}

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}