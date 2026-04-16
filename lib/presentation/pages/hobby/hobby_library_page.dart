import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/hobby_category.dart';
import '../../providers/hobby_provider.dart';

/// 爱好库编辑页面
/// 左侧分类列表 + 右侧作品管理
class HobbyLibraryPage extends ConsumerStatefulWidget {
  const HobbyLibraryPage({super.key});

  @override
  ConsumerState<HobbyLibraryPage> createState() => _HobbyLibraryPageState();
}

class _HobbyLibraryPageState extends ConsumerState<HobbyLibraryPage> {
  // 当前选中的分类 ID
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final allCategories = ref.watch(allHobbyCategoriesProvider);
    // 默认选中第一个分类
    final selectedId = _selectedCategoryId ??
        (allCategories.isNotEmpty ? allCategories.first.id : null);
    final selectedCategory = allCategories.firstWhere(
      (c) => c.id == selectedId,
      orElse: () => allCategories.isNotEmpty
          ? allCategories.first
          : HobbyCategory(
              id: '',
              name: '',
              icon: Icons.help_outline,
              color: Colors.grey,
            ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '我的爱好库',
          style: AppTheme.titleLarge.copyWith(color: AppTheme.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Row(
          children: [
            // 左侧分类列表
            _buildCategorySidebar(allCategories, selectedId),

            // 右侧作品管理区
            Expanded(
              child: selectedId != null && selectedId.isNotEmpty
                  ? _buildCategoryContent(selectedCategory)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建左侧分类列表
  Widget _buildCategorySidebar(List<HobbyCategory> categories, String? selectedId) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(AppTheme.radiusXl),
        ),
        boxShadow: AppTheme.shadowSm,
      ),
      margin: const EdgeInsets.only(right: AppTheme.spaceSm),
      child: Column(
        children: [
          const SizedBox(height: AppTheme.spaceLg),

          // 标题
          Text(
            '爱好库',
            style: AppTheme.titleMedium.copyWith(
              fontFamily: AppTheme.fontFamilyDisplay,
            ),
          ),

          const SizedBox(height: AppTheme.spaceMd),
          const Divider(height: 1),

          // 分类列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category.id == selectedId;
                return _buildCategoryItem(category, isSelected);
              },
            ),
          ),

          const Divider(height: 1),

          // 添加自定义分类按钮
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: GestureDetector(
              onTap: () => _showAddCategorySheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '分类',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建单个分类项
  Widget _buildCategoryItem(HobbyCategory category, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceSm,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: category.color,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 22,
              color: isSelected ? category.color : AppTheme.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
              style: AppTheme.labelSmall.copyWith(
                color: isSelected ? category.color : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建右侧分类内容区
  Widget _buildCategoryContent(HobbyCategory category) {
    final hobbyState = ref.watch(hobbyProvider);
    final selectedItems = hobbyState.getSelectedItemsByCategory(category.id);
    final selectedCount = selectedItems.length;
    final isCustom = category.id.startsWith('custom_');

    return Container(
      margin: const EdgeInsets.only(
        right: AppTheme.spaceLg,
        top: AppTheme.spaceSm,
        bottom: AppTheme.spaceSm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类头部信息
            _buildContentHeader(category, selectedCount, isCustom),

            const Divider(height: 1),

            // 可滚动内容区
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 预设分类显示热门推荐
                    if (!isCustom && category.popularItems.isNotEmpty) ...[
                      _buildPopularItems(category, selectedItems),
                      const SizedBox(height: AppTheme.spaceXl),
                    ],

                    // 自定义输入
                    _buildCustomInput(category),

                    // 已选择项目
                    if (selectedItems.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spaceXl),
                      _buildSelectedItems(category, selectedItems),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建内容区头部
  Widget _buildContentHeader(
    HobbyCategory category,
    int selectedCount,
    bool isCustom,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 28,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
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
                const SizedBox(height: 4),
                Text(
                  '已添加 $selectedCount 个作品',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // 自定义分类可删除
          if (isCustom)
            IconButton(
              onPressed: () => _confirmDeleteCustomCategory(category),
              icon: Icon(
                Icons.delete_outline,
                color: AppTheme.error,
              ),
              tooltip: '删除分类',
            ),
        ],
      ),
    );
  }

  /// 构建热门推荐
  Widget _buildPopularItems(HobbyCategory category, List<String> selectedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        const SizedBox(height: AppTheme.spaceMd),
        Wrap(
          spacing: AppTheme.spaceSm,
          runSpacing: AppTheme.spaceSm,
          children: category.popularItems.map((item) {
            final isSelected = selectedItems.contains(item);
            return _buildItemChip(
              item: item,
              isSelected: isSelected,
              color: category.color,
              onTap: () {
                ref.read(hobbyProvider.notifier).toggleHobbyItem(
                  category.id,
                  item,
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建自定义输入区
  Widget _buildCustomInput(HobbyCategory category) {
    final controller = TextEditingController();

    return Column(
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
                  fillColor: AppTheme.background,
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
    );
  }

  /// 构建已选择项目列表
  Widget _buildSelectedItems(HobbyCategory category, List<String> selectedItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '已添加作品',
          style: AppTheme.titleMedium.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        Wrap(
          spacing: AppTheme.spaceSm,
          runSpacing: AppTheme.spaceSm,
          children: selectedItems.map((item) {
            return _buildSelectedItemChip(category, item);
          }).toList(),
        ),
      ],
    );
  }

  /// 构建项目标签（可切换选择）
  Widget _buildItemChip({
    required String item,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMd,
          vertical: AppTheme.spaceSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? color : AppTheme.surfaceVariant,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected ? color : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 16,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建已选择项目标签（带删除按钮）
  Widget _buildSelectedItemChip(HobbyCategory category, String item) {
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
              ref.read(hobbyProvider.notifier).removeHobbyItem(
                category.id,
                item,
              );
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

  /// 常用图标列表
  static const List<IconData> _commonIcons = [
    Icons.book_outlined,
    Icons.music_note_outlined,
    Icons.sports_esports_outlined,
    Icons.movie_outlined,
    Icons.tv_outlined,
    Icons.live_tv_outlined,
    Icons.restaurant_outlined,
    Icons.local_cafe_outlined,
    Icons.palette_outlined,
    Icons.sports_basketball_outlined,
    Icons.pets_outlined,
    Icons.animation_outlined,
    Icons.menu_book_outlined,
    Icons.mic_outlined,
    Icons.school_outlined,
    Icons.mic_external_on_outlined,
    Icons.theaters_outlined,
    Icons.emoji_people_outlined,
    Icons.flight_outlined,
    Icons.person_outlined,
    Icons.camera_alt_outlined,
    Icons.computer_outlined,
    Icons.directions_car_outlined,
    Icons.fitness_center_outlined,
    Icons.shopping_bag_outlined,
    Icons.headphones_outlined,
    Icons.camera_roll_outlined,
    Icons.spa_outlined,
    Icons.weekend_outlined,
    Icons.beach_access_outlined,
    Icons.card_giftcard_outlined,
  ];

  /// 显示添加自定义分类底部弹窗
  void _showAddCategorySheet(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          IconData selectedIcon = _commonIcons.first;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
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
                    '添加新分类',
                    style: AppTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '例如：篮球、摄影、模型...',
                      hintStyle: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppTheme.background,
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
                        _addCategory(value.trim(), selectedIcon);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  Text(
                    '选择图标',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  Wrap(
                    spacing: AppTheme.spaceSm,
                    runSpacing: AppTheme.spaceSm,
                    children: _commonIcons.map((icon) {
                      final isSelected = icon == selectedIcon;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withOpacity(0.15)
                                : AppTheme.background,
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.surfaceVariant,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textTertiary,
                            size: 22,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spaceXl),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        final value = controller.text.trim();
                        if (value.isNotEmpty) {
                          _addCategory(value, selectedIcon);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                      ),
                      child: Text(
                        '确认添加',
                        style: AppTheme.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                ],
              ),
            ),
          ),
          );
        },
      ),
    );
  }

  /// 添加自定义分类
  void _addCategory(String name, [IconData? icon]) {
    ref.read(hobbyProvider.notifier).addCustomCategory(name, icon: icon);
    // 自动选中新添加的分类（需要稍微延迟等待状态更新）
    Future.delayed(const Duration(milliseconds: 50), () {
      final categories = ref.read(allHobbyCategoriesProvider);
      final newCategory = categories.lastWhere(
        (c) => c.name == name && c.id.startsWith('custom_'),
        orElse: () => categories.isNotEmpty ? categories.last : categories.first,
      );
      if (mounted) {
        setState(() {
          _selectedCategoryId = newCategory.id;
        });
      }
    });
  }

  /// 确认删除自定义分类
  void _confirmDeleteCustomCategory(HobbyCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('删除分类', style: AppTheme.titleLarge),
        content: Text(
          '确定要删除"${category.name}"分类吗？该分类下的所有作品也会被移除。',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '取消',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textTertiary),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(hobbyProvider.notifier).removeCustomCategory(category.id);
              setState(() {
                _selectedCategoryId = null;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              '删除',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
