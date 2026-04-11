import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 手机验证页面
class PhoneVerificationPage extends StatelessWidget {
  final String phone;

  const PhoneVerificationPage({
    super.key,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '输入验证码',
              style: AppTheme.displaySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSm),
            Text(
              '验证码已发送至 $phone',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
