import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import 'hobby_selection_page.dart';
import '../profile/profile_hobbies_page.dart';

/// 爱好系统展示页面 - 用于快速测试
class HobbyShowcasePage extends ConsumerWidget {
  const HobbyShowcasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '爱好系统',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 系统介绍
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '作品级爱好匹配系统',
                    style: AppTheme.headlineSmall.copyWith(
                      color: Colors.white,
                      fontFamily: AppTheme.fontFamilyDisplay,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Text(
                    '通过具体的作品找到志同道合的朋友，无论是《三体》还是周杰伦，都能找到同好。',
                    style: AppTheme.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // 功能入口列表
            Text(
              '功能入口',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),

            _buildFeatureCard(
              context,
              icon: Icons.favorite_outline,
              color: AppTheme.primary,
              title: '爱好选择',
              subtitle: '注册流程中的爱好选择页面',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HobbySelectionPage(
                      onNext: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('继续到资料完善页')),
                        );
                      },
                      onSkip: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppTheme.spaceMd),

            _buildFeatureCard(
              context,
              icon: Icons.manage_accounts,
              color: AppTheme.accent,
              title: '爱好管理',
              subtitle: '个人资料页中的爱好管理',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileHobbiesPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // 统计信息
            Text(
              '系统统计',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    value: '19',
                    label: '爱好分类',
                    icon: Icons.category,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: _buildStatCard(
                    value: '95+',
                    label: '热门作品',
                    icon: Icons.local_fire_department,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: _buildStatCard(
                    value: '∞',
                    label: '自定义',
                    icon: Icons.add_circle_outline,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.shadowSm,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primary,
            size: 24,
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            value,
            style: AppTheme.headlineSmall.copyWith(
              fontFamily: AppTheme.fontFamilyDisplay,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
