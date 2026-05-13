import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/users/presentation/pages/users_page.dart';

class InvoiceApp extends StatelessWidget {
  const InvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const UsersPage(),
    );
  }
}
