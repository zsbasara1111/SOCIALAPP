import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';
import 'hobby_detail_page.dart';

/// 爱好选择页面 - 注册流程中的快速选择
class HobbySelectionPage extends ConsumerWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const HobbySelectionPage({
    super.key,
    this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedCount = hobbyState.totalSelectedCount;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部进度指示和跳过按钮
            _buildHeader(context, onSkip),

            // 标题区域
            _buildTitle(context, selectedCount),

            // 分类网格
            Expanded(
              child: _buildCategoryGrid(context, ref, hobbyState),
            ),

            // 底部按钮
            _buildBottomBar(context, selectedCount),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航
  Widget _buildHeader(BuildContext context, VoidCallback? onSkip) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 返回按钮
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppTheme.textPrimary,
          ),

          // 进度指示器
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMd,
              vertical: AppTheme.spaceXs,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Text(
              '步骤 2/4',
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // 跳过按钮
          TextButton(
            onPressed: onSkip,
            child: Text(
              '跳过',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建标题区域
  Widget _buildTitle(BuildContext context, int selectedCount) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择你的爱好',
            style: AppTheme.displaySmall.copyWith(
              fontFamily: AppTheme.fontFamilyDisplay,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '选择你喜欢的作品，找到志同道合的朋友',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          // 已选择数量提示
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMd,
              vertical: AppTheme.spaceXs,
            ),
            decoration: BoxDecoration(
              color: selectedCount >= 3
                  ? AppTheme.primary.withOpacity(0.1)
                  : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selectedCount >= 3 ? Icons.check_circle : Icons.info_outline,
                  size: 16,
                  color: selectedCount >= 3 ? AppTheme.success : AppTheme.textTertiary,
                ),
                const SizedBox(width: AppTheme.spaceXs),
                Text(
                  selectedCount >= 3
                      ? '已选择 $selectedCount 项，可以继续了'
                      : '至少选择 3 项爱好',
                  style: AppTheme.labelMedium.copyWith(
                    color: selectedCount >= 3 ? AppTheme.success : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构成分类网格
  Widget _buildCategoryGrid(
    BuildContext context,
    WidgetRef ref,
    HobbyState hobbyState,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppTheme.spaceMd,
        mainAxisSpacing: AppTheme.spaceMd,
      ),
      itemCount: HobbyCategories.all.length,
      itemBuilder: (context, index) {
        final category = HobbyCategories.all[index];
        final selectedCount = hobbyState.getSelectedCountByCategory(category.id);
        final hasSelection = selectedCount > 0;

        return GestureDetector(
          onTap: () {
            ref.read(hobbyProvider.notifier).setCurrentEditingCategory(category.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HobbyDetailPage(category: category),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: hasSelection ? category.color.withOpacity(0.1) : AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: hasSelection
                  ? Border.all(color: category.color, width: 2)
                  : null,
              boxShadow: AppTheme.shadowSm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceSm),
                // 分类名称
                Text(
                  category.name,
                  style: AppTheme.labelLarge.copyWith(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                // 已选择数量或提示
                hasSelection
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$selectedCount',
                          style: AppTheme.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      )
                    : Text(
                        '点击添加',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textTertiary,
                          fontSize: 11,
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 构建底部按钮栏
  Widget _buildBottomBar(BuildContext context, int selectedCount) {
    final canContinue = selectedCount >= 3;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 快速添加热门推荐
            if (selectedCount < 3)
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '不知道选什么？试试热门推荐',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _addRandomPopularItems(context),
                      icon: const Icon(Icons.auto_awesome, size: 16),
                      label: const Text('一键添加'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

            // 继续按钮
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canContinue
                    ? () {
                        onNext?.call();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.surfaceVariant,
                  disabledForegroundColor: AppTheme.textTertiary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: Text(
                  '继续',
                  style: AppTheme.labelLarge.copyWith(
                    color: canContinue ? Colors.white : AppTheme.textTertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 一键添加热门推荐
  void _addRandomPopularItems(BuildContext context) {
    // 这里会通过 context 获取 ref
    // 实际使用时需要在 ConsumerWidget 中调用
  }
}
