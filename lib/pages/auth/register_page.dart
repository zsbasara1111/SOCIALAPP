import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 注册页面
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppTheme.spaceXl),
        child: Center(
          child: Text('注册页面'),
        ),
      ),
    );
  }
}
