import 'package:flutter/material.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

/// 我的页面
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // 顶部用户信息
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.all(AppTheme.spaceXl),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.space2Xl),
                  // 头像
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      '我',
                      style: AppTheme.displayMedium.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  // 昵称
                  Text(
                    '我的昵称',
                    style: AppTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  // ID和城市
                  Text(
                    'ID: 123456 • 北京',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  // VIP卡片
                  VipCard(
                    tier: '普通VIP',
                    price: '¥59/月',
                    period: '',
                    benefits: const [
                      '同好匹配 无限次',
                      '同城匹配 50次/天',
                      '查看谁喜欢我',
                    ],
                    onSubscribe: () {
                      context.goVipCenter();
                    },
                  ),
                ],
              ),
            ),
          ),

          // 菜单列表
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMenuItem(
                  icon: Icons.edit,
                  title: '编辑资料',
                  onTap: () {
                    context.goEditProfile();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.photo_library,
                  title: '我的照片墙',
                  onTap: () {
                    context.goMyPhotos();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.favorite,
                  title: '我喜欢的人',
                  onTap: () {
                    context.goLikedUsers();
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: '设置',
                  onTap: () {
                    context.goSettings();
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title, style: AppTheme.titleMedium),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textTertiary,
        ),
        onTap: onTap,
      ),
    );
  }
}
