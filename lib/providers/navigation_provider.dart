import 'package:flutter/foundation.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void setCurrentPage(int page) {
    if (_currentPage == page) {
      return;
    }

    _currentPage = page;
    notifyListeners();
  }
}
