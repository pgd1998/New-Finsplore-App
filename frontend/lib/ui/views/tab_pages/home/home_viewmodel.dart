import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  
  void loadData() {
    // TODO: Load real data from API
    setBusy(true);
    
    // Simulate loading
    Future.delayed(Duration(milliseconds: 500), () {
      setBusy(false);
    });
  }
}
