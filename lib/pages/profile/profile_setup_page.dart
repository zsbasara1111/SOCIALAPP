import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 资料完善页面
class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('完善资料'),
        backgroundColor: AppTheme.surface,
      ),
      body: const Center(
        child: Text('资料完善页面'),
      ),
    );
  }
}
