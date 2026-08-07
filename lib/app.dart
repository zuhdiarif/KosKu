import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kosmo/theme/kosmo_theme.dart';
import 'package:kosmo/utils/routes.dart';
import 'package:kosmo/providers/theme_provider.dart';

class KosmoApp extends StatelessWidget {
  const KosmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Kosmo',
      debugShowCheckedModeBanner: false,
      theme: KosmoTheme.lightTheme,
      darkTheme: KosmoTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
