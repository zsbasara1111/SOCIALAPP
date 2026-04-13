import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';

/// 个人资料页 - 爱好标签展示组件
class HobbyTagsWidget extends ConsumerWidget {
  final bool showAll;
  final int maxItems;
  final VoidCallback? onTapMore;

  const HobbyTagsWidget({
    super.key,
    this.showAll = false,
    this.maxItems = 8,
    this.onTapMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedCategories = hobbyState.selectedCategoryIds;

    if (selectedCategories.isEmpty) {
      return _buildEmptyState();
    }

    // 收集所有已选择的项目，按分类分组
    final List<_HobbyTagItem> allItems = [];
    for (final categoryId in selectedCategories) {
      final category = HobbyCategories.getById(categoryId);
      if (category == null) continue;

      final items = hobbyState.getSelectedItemsByCategory(categoryId);
      for (final item in items) {
        allItems.add(_HobbyTagItem(
          category: category,
          itemName: item,
        ));
      }
    }

    // 限制显示数量
    final displayItems = showAll ? allItems : allItems.take(maxItems).toList();
    final hasMore = allItems.length > maxItems && !showAll;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.interests,
                  size: 18,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '爱好',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '${allItems.length} 个作品',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spaceMd),

        // 标签云
        Wrap(
          spacing: AppTheme.spaceSm,
          runSpacing: AppTheme.spaceSm,
          children: [
            ...displayItems.map((item) => _buildTag(item)),
            if (hasMore) _buildMoreTag(allItems.length - maxItems),
          ],
        ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          Icon(
            Icons.interests_outlined,
            color: AppTheme.textTertiary,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '还没有添加爱好',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '添加爱好让匹配更精准',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiary,
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
    );
  }

  /// 构建单个标签
  Widget _buildTag(_HobbyTagItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: AppTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        color: item.category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: item.category.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.category.icon,
            size: 14,
            color: item.category.color,
          ),
          const SizedBox(width: 4),
          Text(
            item.itemName,
            style: AppTheme.bodyMedium.copyWith(
              color: item.category.color,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建"更多"标签
  Widget _buildMoreTag(int moreCount) {
    return GestureDetector(
      onTap: onTapMore,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: AppTheme.surfaceVariant,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+$moreCount',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// 爱好标签项
class _HobbyTagItem {
  final HobbyCategory category;
  final String itemName;

  const _HobbyTagItem({
    required this.category,
    required this.itemName,
  });
}

/// 匹配卡片上的爱好标签（简化版）
class MatchCardHobbyTags extends ConsumerWidget {
  final int maxItems;

  const MatchCardHobbyTags({
    super.key,
    this.maxItems = 4,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedCategories = hobbyState.selectedCategoryIds;

    if (selectedCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    // 收集所有已选择的项目
    final List<_HobbyTagItem> allItems = [];
    for (final categoryId in selectedCategories) {
      final category = HobbyCategories.getById(categoryId);
      if (category == null) continue;

      final items = hobbyState.getSelectedItemsByCategory(categoryId);
      for (final item in items) {
        allItems.add(_HobbyTagItem(
          category: category,
          itemName: item,
        ));
      }
    }

    // 随机选择几个显示
    allItems.shuffle();
    final displayItems = allItems.take(maxItems).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayItems.map((item) => _buildMiniTag(item)).toList(),
    );
  }

  Widget _buildMiniTag(_HobbyTagItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        '${item.category.name} · ${item.itemName}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// 共同爱好展示组件（用于匹配成功或聊天界面）
class CommonHobbiesWidget extends StatelessWidget {
  final List<String> commonItems;
  final VoidCallback? onTap;

  const CommonHobbiesWidget({
    super.key,
    required this.commonItems,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (commonItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primary.withOpacity(0.1),
              AppTheme.accent.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '共同爱好',
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${commonItems.length}',
                    style: AppTheme.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Wrap(
              spacing: AppTheme.spaceSm,
              runSpacing: AppTheme.spaceSm,
              children: commonItems.take(5).map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMd,
                    vertical: AppTheme.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Text(
                    item,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
