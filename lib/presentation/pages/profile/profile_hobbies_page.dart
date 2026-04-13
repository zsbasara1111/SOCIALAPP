import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';
import '../hobby/hobby_detail_page.dart';

/// 个人资料 - 爱好管理页面
class ProfileHobbiesPage extends ConsumerWidget {
  const ProfileHobbiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedCategories = hobbyState.selectedCategoryIds;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '我的爱好',
          style: AppTheme.titleLarge.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 保存爱好到服务器
              _saveHobbies(context, ref);
            },
            child: Text(
              '保存',
              style: AppTheme.labelLarge.copyWith(
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 统计信息
          _buildStatsCard(context, hobbyState),

          // 已选择的分类列表
          Expanded(
            child: selectedCategories.isEmpty
                ? _buildEmptyState(context)
                : _buildSelectedCategoriesList(context, ref, hobbyState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHobbyBottomSheet(context, ref),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add),
        label: const Text('添加爱好'),
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatsCard(BuildContext context, HobbyState hobbyState) {
    final categoryCount = hobbyState.selectedCategoryIds.length;
    final itemCount = hobbyState.totalSelectedCount;

    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceLg),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('$categoryCount', '爱好分类'),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('$itemCount', '作品数量'),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamilyDisplay,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.interests_outlined,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            '还没有添加爱好',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '添加爱好，找到志同道合的朋友',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXl),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('添加爱好'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceXl,
                vertical: AppTheme.spaceMd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建已选择分类列表
  Widget _buildSelectedCategoriesList(
    BuildContext context,
    WidgetRef ref,
    HobbyState hobbyState,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      itemCount: hobbyState.selectedCategoryIds.length,
      itemBuilder: (context, index) {
        final categoryId = hobbyState.selectedCategoryIds[index];
        final category = HobbyCategories.getById(categoryId);
        if (category == null) return const SizedBox.shrink();

        final selectedItems = hobbyState.getSelectedItemsByCategory(categoryId);

        return _buildCategoryCard(context, ref, category, selectedItems);
      },
    );
  }

  /// 构建分类卡片
  Widget _buildCategoryCard(
    BuildContext context,
    WidgetRef ref,
    HobbyCategory category,
    List<String> items,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类头部
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 20,
              ),
            ),
            title: Text(
              category.name,
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            subtitle: Text(
              '${items.length} 个作品',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HobbyDetailPage(category: category),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: AppTheme.textSecondary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // 删除该分类下所有选择
                    for (final item in items) {
                      ref.read(hobbyProvider.notifier).removeHobbyItem(category.id, item);
                    }
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: AppTheme.error,
                  ),
                ),
              ],
            ),
          ),

          // 项目标签
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spaceLg,
              0,
              AppTheme.spaceLg,
              AppTheme.spaceLg,
            ),
            child: Wrap(
              spacing: AppTheme.spaceSm,
              runSpacing: AppTheme.spaceSm,
              children: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMd,
                    vertical: AppTheme.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: category.color.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    item,
                    style: AppTheme.bodyMedium.copyWith(
                      color: category.color,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示添加爱好底部弹窗
  void _showAddHobbyBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusXl),
              ),
            ),
            child: Column(
              children: [
                // 拖动指示器
                Container(
                  margin: const EdgeInsets.symmetric(vertical: AppTheme.spaceMd),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textTertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // 标题
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceLg),
                  child: Text(
                    '选择爱好分类',
                    style: AppTheme.titleLarge,
                  ),
                ),

                // 分类网格
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: AppTheme.spaceMd,
                      mainAxisSpacing: AppTheme.spaceMd,
                    ),
                    itemCount: HobbyCategories.all.length,
                    itemBuilder: (context, index) {
                      final category = HobbyCategories.all[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => HobbyDetailPage(category: category),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                            border: Border.all(
                              color: AppTheme.surfaceVariant,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                              Text(
                                category.name,
                                style: AppTheme.labelLarge.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 保存爱好到服务器
  void _saveHobbies(BuildContext context, WidgetRef ref) {
    // TODO: 实现保存到 Supabase 的逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('爱好保存成功'),
        backgroundColor: AppTheme.success,
      ),
    );
    Navigator.of(context).pop();
  }
}
