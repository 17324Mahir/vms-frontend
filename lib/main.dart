import 'dart:async';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'data/auth/auth_service.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Fire background non-blocking ping to wake up cloud backend from idle sleep
  unawaited(AuthService.instance.warmUpBackend());
  runApp(const StarkVmsApp());
}

/// Root application widget for Stark Group Vehicle Management System (VMS).
class StarkVmsApp extends StatelessWidget {
  final String initialRoute;

  const StarkVmsApp({
    super.key,
    this.initialRoute = AppRouter.homeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stark Group - Vehicle Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
