import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../providers/match_provider.dart';

/// 匹配模式选择器
class MatchModeSelector extends ConsumerWidget {
  const MatchModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(currentMatchModeProvider);
    final matchState = ref.watch(matchProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: MatchMode.values.map((mode) {
          final isSelected = currentMode == mode;
          final isLocked = mode.isVipOnly && !matchState.isVip;

          return Expanded(
            child: GestureDetector(
              onTap: isLocked
                  ? () => _showVipPrompt(context)
                  : () => ref.read(matchProvider.notifier).switchMode(mode),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spaceMd,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd - 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode.icon,
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : isLocked
                              ? AppTheme.textTertiary
                              : AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mode.displayName,
                      style: AppTheme.labelLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : isLocked
                                ? AppTheme.textTertiary
                                : AppTheme.textSecondary,
                      ),
                    ),
                    if (isLocked) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.lock,
                        size: 12,
                        color: AppTheme.vipGold,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 显示VIP提示
  void _showVipPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: AppTheme.vipGold,
            ),
            const SizedBox(width: 8),
            const Text('VIP专属功能'),
          ],
        ),
        content: const Text(
          '精准匹配是VIP专属功能，开通VIP即可使用多维筛选，找到最适合的人。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('稍后'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goVipCenter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.vipGold,
            ),
            child: const Text('开通VIP'),
          ),
        ],
      ),
    );
  }
}
