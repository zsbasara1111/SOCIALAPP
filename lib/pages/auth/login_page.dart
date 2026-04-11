import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';

/// 登录页面
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.space3Xl),
              Text(
                '欢迎回来',
                style: AppTheme.displaySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSm),
              Text(
                '登录后继续寻找志同道合的朋友',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.space3Xl),

              // 手机号输入
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '请输入手机号',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceXl),

              // 登录按钮
              PrimaryButton(
                text: '获取验证码',
                onPressed: () {
                  // TODO: 发送验证码
                },
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // 其他登录方式
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: 前往注册
                  },
                  child: Text(
                    '还没有账号？立即注册',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
