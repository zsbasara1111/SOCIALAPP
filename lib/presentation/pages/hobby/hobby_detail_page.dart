import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';

/// 爱好详情页面 - 选择具体项目
class HobbyDetailPage extends ConsumerWidget {
  final HobbyCategory category;

  const HobbyDetailPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedItems = hobbyState.getSelectedItemsByCategory(category.id);
    final selectedCount = selectedItems.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部导航
            _buildHeader(context, selectedCount),

            // 分类信息
            _buildCategoryInfo(context),

            // 热门推荐
            _buildPopularItems(context, ref, selectedItems),

            // 自定义输入
            _buildCustomInput(context, ref),

            // 已选择项目
            if (selectedItems.isNotEmpty)
              _buildSelectedItems(context, ref, selectedItems),

            const Spacer(),

            // 底部按钮
            _buildBottomBar(context, selectedCount),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航
  Widget _buildHeader(BuildContext context, int selectedCount) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppTheme.textPrimary,
          ),
          const Spacer(),
          // 已选择计数
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMd,
              vertical: AppTheme.spaceXs,
            ),
            decoration: BoxDecoration(
              color: selectedCount > 0
                  ? category.color.withOpacity(0.1)
                  : AppTheme.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Text(
              '已选择 $selectedCount 项',
              style: AppTheme.labelMedium.copyWith(
                color: selectedCount > 0 ? category.color : AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构成分类信息
  Widget _buildCategoryInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      child: Row(
        children: [
          // 分类图标
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 32,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          // 分类名称和描述
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTheme.headlineSmall.copyWith(
                    fontFamily: AppTheme.fontFamilyDisplay,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceXs),
                Text(
                  '选择你喜欢的${category.name}作品',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建热门推荐
  Widget _buildPopularItems(
    BuildContext context,
    WidgetRef ref,
    List<String> selectedItems,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: AppTheme.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: AppTheme.warning,
                  size: 18,
                ),
                const SizedBox(width: AppTheme.spaceXs),
                Text(
                  '热门推荐',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
            child: Wrap(
              spacing: AppTheme.spaceSm,
              runSpacing: AppTheme.spaceSm,
              children: category.popularItems.map((item) {
                final isSelected = selectedItems.contains(item);
                return _buildItemChip(
                  context,
                  ref,
                  item: item,
                  isSelected: isSelected,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建项目标签
  Widget _buildItemChip(
    BuildContext context,
    WidgetRef ref, {
    required String item,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(hobbyProvider.notifier).toggleHobbyItem(category.id, item);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withOpacity(0.15)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? category.color : AppTheme.surfaceVariant,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected ? category.color : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 16,
                color: category.color,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建自定义输入
  Widget _buildCustomInput(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '自定义添加',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '输入你喜欢的${category.name}作品...',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceLg,
                      vertical: AppTheme.spaceMd,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      ref.read(hobbyProvider.notifier).addHobbyItem(
                        category.id,
                        value.trim(),
                      );
                      controller.clear();
                    }
                  },
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              IconButton(
                onPressed: () {
                  final value = controller.text.trim();
                  if (value.isNotEmpty) {
                    ref.read(hobbyProvider.notifier).addHobbyItem(
                      category.id,
                      value,
                    );
                    controller.clear();
                  }
                },
                icon: Container(
                  padding: const EdgeInsets.all(AppTheme.spaceSm),
                  decoration: BoxDecoration(
                    color: category.color,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建已选择项目列表
  Widget _buildSelectedItems(
    BuildContext context,
    WidgetRef ref,
    List<String> selectedItems,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '已选择',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Wrap(
            spacing: AppTheme.spaceSm,
            runSpacing: AppTheme.spaceSm,
            children: selectedItems.map((item) {
              return _buildSelectedItemChip(context, ref, item);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 构建已选择项目标签（带删除按钮）
  Widget _buildSelectedItemChip(
    BuildContext context,
    WidgetRef ref,
    String item,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMd,
        vertical: AppTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: category.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item,
            style: AppTheme.bodyMedium.copyWith(
              color: category.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () {
              ref.read(hobbyProvider.notifier).removeHobbyItem(category.id, item);
            },
            child: Icon(
              Icons.close,
              size: 16,
              color: category.color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildBottomBar(BuildContext context, int selectedCount) {
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
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCount > 0 ? category.color : AppTheme.surfaceVariant,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
            child: Text(
              selectedCount > 0 ? '完成 ($selectedCount)' : '返回',
              style: AppTheme.labelLarge.copyWith(
                color: selectedCount > 0 ? Colors.white : AppTheme.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
