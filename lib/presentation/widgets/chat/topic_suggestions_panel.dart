import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/ai_service.dart';
import '../../providers/ai_assistant_provider.dart';

/// 话题建议面板
class TopicSuggestionsPanel extends ConsumerWidget {
  final List<String> userHobbies;
  final List<String> matchHobbies;
  final Function(String)? onTopicTap;

  const TopicSuggestionsPanel({
    super.key,
    required this.userHobbies,
    required this.matchHobbies,
    this.onTopicTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiAssistantProvider);

    if (!state.isExpanded) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          _buildHeader(context, ref, state),

          const SizedBox(height: AppTheme.spaceMd),

          // 话题列表
          if (state.isLoading)
            _buildLoadingState()
          else if (state.error != null)
            _buildErrorState(context, ref, state.error!)
          else if (state.topics.isEmpty)
            _buildEmptyState(context, ref)
          else
            _buildTopicsList(context, ref, state),
        ],
      ),
    );
  }

  /// 构建头部
  Widget _buildHeader(BuildContext context, WidgetRef ref, AIAssistantState state) {
    return Row(
      children: [
        // AI图标
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.accent,
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: AppTheme.spaceMd),

        // 标题
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '话题建议',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '基于你们的共同爱好生成',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),

        // 刷新按钮
        if (!state.isLoading && state.topics.isNotEmpty)
          GestureDetector(
            onTap: () {
              _refreshTopics(context, ref);
            },
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spaceSm),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                Icons.refresh,
                size: 18,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  /// 构建加载状态
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Text(
            '正在生成建议...',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建错误状态
  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 32,
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            error,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          GestureDetector(
            onTap: () => _refreshTopics(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceLg,
                vertical: AppTheme.spaceSm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                '重试',
                style: AppTheme.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _refreshTopics(context, ref),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.surfaceVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppTheme.primary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spaceSm),
            Text(
              '点击生成话题建议',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建话题列表
  Widget _buildTopicsList(BuildContext context, WidgetRef ref, AIAssistantState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: state.topics.map((topic) {
        return _buildTopicCard(context, ref, topic);
      }).toList(),
    );
  }

  /// 构建单个话题卡片
  Widget _buildTopicCard(
    BuildContext context,
    WidgetRef ref,
    dynamic topic,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(aiAssistantProvider.notifier).useTopic();
        if (onTopicTap != null) {
          onTopicTap!(topic.description);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primary.withOpacity(0.1),
              AppTheme.accent.withOpacity(0.05),
            ],
          ),
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题行
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: Icon(
                    Icons.chat_bubble,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSm),
                Expanded(
                  child: Text(
                    topic.title,
                    style: AppTheme.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceSm),

            // 描述
            Text(
              topic.description,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: AppTheme.spaceSm),

            // 使用提示
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '点击使用',
                  style: AppTheme.labelSmall.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 12,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 刷新话题
  void _refreshTopics(BuildContext context, WidgetRef ref) {
    ref.read(aiAssistantProvider.notifier).generateTopics(
          userHobbies: userHobbies,
          matchHobbies: matchHobbies,
        );
  }
}
