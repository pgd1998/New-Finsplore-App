import 'package:stacked/stacked.dart';

class MainScreenViewModel extends BaseViewModel {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return; // Avoid unnecessary rebuilds
    if (index == 2) return; // Skip index 2 (reserved for FAB)
    _currentIndex = index;
    notifyListeners();
  }
}
