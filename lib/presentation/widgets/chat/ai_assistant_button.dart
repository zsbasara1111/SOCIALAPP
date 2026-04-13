import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/ai_service.dart';
import '../../providers/ai_assistant_provider.dart';

/// AI助手浮动按钮
class AIAssistantButton extends ConsumerWidget {
  final VoidCallback? onTap;

  const AIAssistantButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(aiExpandedProvider);
    final mode = ref.watch(aiModeProvider);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mode == AIAssistantMode.dating
                ? [
                    const Color(0xFFFF6B9D),
                    const Color(0xFFFF8E53),
                  ]
                : [
                    AppTheme.primary,
                    AppTheme.accent,
                  ],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          boxShadow: [
            BoxShadow(
              color: (mode == AIAssistantMode.dating
                      ? const Color(0xFFFF6B9D)
                      : AppTheme.primary)
                  .withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI图标
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: AppTheme.spaceSm),
            // 文字
            Text(
              isExpanded ? '收起建议' : (mode == AIAssistantMode.dating ? '约会助手' : '话题助手'),
              style: AppTheme.labelLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppTheme.spaceXs),
            // 展开/收起箭头
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// AI助手模式切换器
class AIAssistantModeSelector extends ConsumerWidget {
  const AIAssistantModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(aiModeProvider);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXs),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(
          color: AppTheme.surfaceVariant,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            label: '话题',
            icon: Icons.chat_bubble_outline,
            isSelected: currentMode == AIAssistantMode.normal,
            onTap: () {
              ref.read(aiAssistantProvider.notifier).switchMode(AIAssistantMode.normal);
            },
          ),
          _buildModeButton(
            label: '约会',
            icon: Icons.favorite,
            isSelected: currentMode == AIAssistantMode.dating,
            isDating: true,
            onTap: () {
              ref.read(aiAssistantProvider.notifier).switchMode(AIAssistantMode.dating);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isDating = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isDating
                      ? [
                          const Color(0xFFFF6B9D),
                          const Color(0xFFFF8E53),
                        ]
                      : [
                          AppTheme.primary,
                          AppTheme.accent,
                        ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDating ? const Color(0xFFFF6B9D) : AppTheme.textSecondary),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTheme.labelMedium.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDating ? const Color(0xFFFF6B9D) : AppTheme.textSecondary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
