// lib/home_page_model.dart

import 'package:flutter/material.dart';

class HomePageModel extends ChangeNotifier {
  // Add properties and methods for the model as needed
  // For example:
  String title = 'Home Page';

  // You can add methods that modify the state of the model and call `notifyListeners()` when something changes
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners(); // This will update the UI when the title changes
  }
}
