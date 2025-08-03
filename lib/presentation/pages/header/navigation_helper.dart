import 'package:flutter/cupertino.dart';

void scrollToSection(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}
