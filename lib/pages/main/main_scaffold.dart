import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

/// 主页面 Scaffold (带底部导航)
class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// 底部导航栏
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: AppTheme.shadowSm,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceLg,
            vertical: AppTheme.spaceSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 匹配
              _buildNavItem(
                icon: Icons.people_outline,
                activeIcon: Icons.people,
                label: '匹配',
                isActive: navigationShell.currentIndex == 0,
                onTap: () => navigationShell.goBranch(0),
              ),
              // 动态
              _buildNavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: '动态',
                isActive: navigationShell.currentIndex == 1,
                onTap: () => navigationShell.goBranch(1),
              ),
              // 中间占位 (发布按钮)
              const SizedBox(width: 64),
              // 消息
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: '消息',
                isActive: navigationShell.currentIndex == 3,
                badgeCount: 3,
                onTap: () => navigationShell.goBranch(3),
              ),
              // 我的
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                isActive: navigationShell.currentIndex == 4,
                onTap: () => navigationShell.goBranch(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 导航项
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppTheme.primary : AppTheme.textTertiary,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: AppTheme.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.labelSmall.copyWith(
              color: isActive ? AppTheme.primary : AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  /// 发布按钮
  Widget _buildFab(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: AppTheme.shadowMd,
      ),
      child: FloatingActionButton(
        onPressed: () {
          // TODO: 显示发布选项
          _showPublishOptions(context);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  /// 显示发布选项
  void _showPublishOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppTheme.spaceXl),
            _buildPublishOption(
              icon: Icons.edit,
              title: '发布动态',
              subtitle: '分享你的生活瞬间',
              onTap: () {
                Navigator.pop(context);
                context.goCreatePost();
              },
            ),
            const SizedBox(height: AppTheme.spaceLg),
            _buildPublishOption(
              icon: Icons.photo_camera,
              title: '发布照片',
              subtitle: '上传精美照片',
              onTap: () {
                Navigator.pop(context);
                context.goCreatePost();
              },
            ),
            const SizedBox(height: AppTheme.space2Xl),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Icon(icon, color: AppTheme.primary),
      ),
      title: Text(title, style: AppTheme.titleMedium),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
      ),
      onTap: onTap,
    );
  }
}
