import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  /// Uses the current breakpoint name for device type detection
  static bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  static bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  static bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  /// Example of padding based on device type
  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return 80.0;
    if (isTablet(context)) return 60.0;
    if (isMobile(context)) return 40.0;
    return 24.0;
  }

  /// Dynamically returns font size based on device type
  static double getResponsiveFontSize(
      BuildContext context, {
        required double mobile,
        required double tablet,
        required double desktop,
      }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Get responsive value based on screen width
  static T getResponsiveValue<T>(
      BuildContext context, {
        required T mobile,
        required T tablet,
        required T desktop,
      }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Get screen width percentage
  static double getWidthPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  /// Get screen height percentage
  static double getHeightPercentage(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
}