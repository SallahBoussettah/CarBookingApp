import 'package:flutter/material.dart';

/// Service for handling navigation throughout the app
class NavigationService {
  /// Global navigation key
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Get the current navigation context
  static BuildContext? get context => navigatorKey.currentContext;
  
  /// Navigate to a named route
  static Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
  
  /// Navigate to a named route and remove all previous routes
  static Future<T?> navigateToAndRemoveUntil<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  /// Navigate to a named route and replace the current route
  static Future<T?> navigateToAndReplace<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }
  
  /// Go back to the previous route
  static void goBack<T>([T? result]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop<T>(result);
    }
  }
  
  /// Go back to a specific route
  static void goBackUntil(String routeName) {
    navigatorKey.currentState!.popUntil(
      ModalRoute.withName(routeName),
    );
  }
}