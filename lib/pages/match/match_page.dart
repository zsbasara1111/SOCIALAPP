import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';

/// 匹配页面
class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('发现'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
        actions: [
          // 匹配模式切换
          Padding(
            padding: const EdgeInsets.only(right: AppTheme.spaceLg),
            child: GestureDetector(
              onTap: () {
                // TODO: 显示匹配模式选择
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMd,
                  vertical: AppTheme.spaceXs,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: AppTheme.primaryDark,
                    ),
                    const SizedBox(width: AppTheme.spaceXs),
                    Text(
                      '同好匹配',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 匹配卡片区域
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: MatchCard(
                name: '小雅',
                age: 21,
                city: '北京',
                matchScore: 8,
                commonHobbies: const ['周杰伦', '《三体》', '原神'],
                onLike: () {},
                onDislike: () {},
              ),
            ),
          ),

          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceXl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 不喜欢按钮
                CircleIconButton(
                  icon: Icons.close,
                  size: 64,
                  backgroundColor: AppTheme.surface,
                  iconColor: AppTheme.textSecondary,
                  onPressed: () {},
                ),
                const SizedBox(width: AppTheme.space2Xl),
                // 红心按钮
                CircleIconButton(
                  icon: Icons.favorite,
                  size: 64,
                  backgroundColor: AppTheme.surface,
                  iconColor: AppTheme.error,
                  onPressed: () {},
                ),
                const SizedBox(width: AppTheme.space2Xl),
                // 喜欢按钮
                CircleIconButton(
                  icon: Icons.favorite,
                  size: 72,
                  backgroundColor: AppTheme.primary,
                  iconColor: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
