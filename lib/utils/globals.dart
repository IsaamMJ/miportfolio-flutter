import 'package:flutter/material.dart';

class Globals {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final ValueNotifier<int> activeSectionIndex = ValueNotifier<int>(0);
}
