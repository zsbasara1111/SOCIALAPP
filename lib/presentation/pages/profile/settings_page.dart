import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 设置页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '设置',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        children: [
          _buildSection('通知设置', [
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: '消息通知',
              value: true,
              onChanged: (value) {},
            ),
            _buildSwitchItem(
              icon: Icons.favorite_border,
              title: '匹配提醒',
              value: true,
              onChanged: (value) {},
            ),
          ]),
          const SizedBox(height: AppTheme.spaceLg),
          _buildSection('隐私设置', [
            _buildArrowItem(
              icon: Icons.visibility_outlined,
              title: '资料可见性',
              onTap: () {},
            ),
            _buildArrowItem(
              icon: Icons.block_outlined,
              title: '黑名单',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: AppTheme.spaceLg),
          _buildSection('其他', [
            _buildArrowItem(
              icon: Icons.help_outline,
              title: '帮助与反馈',
              onTap: () {},
            ),
            _buildArrowItem(
              icon: Icons.description_outlined,
              title: '用户协议',
              onTap: () {},
            ),
            _buildArrowItem(
              icon: Icons.privacy_tip_outlined,
              title: '隐私政策',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: AppTheme.spaceXl),
          // 退出登录
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: AppTheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spaceSm),
                  Text(
                    '退出登录',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppTheme.spaceSm,
            bottom: AppTheme.spaceMd,
          ),
          child: Text(
            title,
            style: AppTheme.labelLarge.copyWith(
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 22),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Text(
              title,
              style: AppTheme.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildArrowItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceLg,
          vertical: AppTheme.spaceMd,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(width: AppTheme.spaceMd),
            Expanded(
              child: Text(
                title,
                style: AppTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('退出登录', style: AppTheme.titleLarge),
        content: Text(
          '确定要退出登录吗？',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textTertiary),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: 执行退出登录
              Navigator.of(context).pop();
            },
            child: Text(
              '退出',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
