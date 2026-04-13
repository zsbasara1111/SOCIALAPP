import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../providers/match_provider.dart';

/// 匹配次数指示器
class MatchQuotaIndicator extends ConsumerWidget {
  const MatchQuotaIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchState = ref.watch(matchProvider);

    // VIP不显示次数限制
    if (matchState.isVip) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.vipGold, AppTheme.vipGoldLight],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium,
              size: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(width: 6),
            Text(
              'VIP无限匹配',
              style: AppTheme.labelMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final remaining = matchState.remainingMatches;
    final progress = matchState.matchProgress;

    return GestureDetector(
      onTap: () => _showQuotaInfo(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: remaining <= 3
              ? const Color(0xFFEF4444).withOpacity(0.1)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: remaining <= 3
                ? const Color(0xFFEF4444).withOpacity(0.3)
                : AppTheme.surfaceVariant,
          ),
        ),
        child: Row(
          children: [
            // 进度条
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppTheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation(
                    remaining <= 3 ? const Color(0xFFEF4444) : AppTheme.primary,
                  ),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),
            // 剩余次数
            Text(
              '剩余 $remaining 次',
              style: AppTheme.labelMedium.copyWith(
                color: remaining <= 3
                    ? const Color(0xFFEF4444)
                    : AppTheme.textSecondary,
              ),
            ),
            // 升级提示
            if (remaining <= 3) ...[
              const SizedBox(width: AppTheme.spaceSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.vipGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '升级',
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.vipGold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 显示次数说明
  void _showQuotaInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            Text(
              '每日匹配次数',
              style: AppTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              '普通用户每天可免费匹配20次，次数用尽后可选择：',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            _buildOption(
              icon: Icons.workspace_premium,
              color: AppTheme.vipGold,
              title: '开通VIP',
              description: '无限匹配次数，精准筛选等更多权益',
              onTap: () {
                Navigator.of(context).pop();
                context.goVipCenter();
              },
            ),
            const SizedBox(height: AppTheme.spaceMd),
            _buildOption(
              icon: Icons.access_time,
              color: AppTheme.primary,
              title: '等待明日重置',
              description: '每日0点自动重置匹配次数',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
