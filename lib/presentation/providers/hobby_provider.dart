import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/hobby_category.dart';

/// 用户选择的爱好项目
class UserHobbyItem {
  final String categoryId;
  final String itemName;

  const UserHobbyItem({
    required this.categoryId,
    required this.itemName,
  });
}

/// 爱好状态
class HobbyState {
  final List<UserHobbyItem> selectedItems;
  final String? currentEditingCategory;
  final bool isLoading;
  final String? error;
  final List<HobbyCategory> customCategories;

  const HobbyState({
    this.selectedItems = const [],
    this.currentEditingCategory,
    this.isLoading = false,
    this.error,
    this.customCategories = const [],
  });

  HobbyState copyWith({
    List<UserHobbyItem>? selectedItems,
    String? currentEditingCategory,
    bool? isLoading,
    String? error,
    List<HobbyCategory>? customCategories,
  }) {
    return HobbyState(
      selectedItems: selectedItems ?? this.selectedItems,
      currentEditingCategory: currentEditingCategory ?? this.currentEditingCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      customCategories: customCategories ?? this.customCategories,
    );
  }

  /// 获取某个分类下已选择的数量
  int getSelectedCountByCategory(String categoryId) {
    return selectedItems.where((item) => item.categoryId == categoryId).length;
  }

  /// 获取某个分类下已选择的项目名称列表
  List<String> getSelectedItemsByCategory(String categoryId) {
    return selectedItems
        .where((item) => item.categoryId == categoryId)
        .map((item) => item.itemName)
        .toList();
  }

  /// 是否已选择某个项目
  bool isItemSelected(String categoryId, String itemName) {
    return selectedItems.any(
      (item) => item.categoryId == categoryId && item.itemName == itemName,
    );
  }

  /// 获取总选择数量
  int get totalSelectedCount => selectedItems.length;

  /// 获取已选择的分类ID列表（去重）
  List<String> get selectedCategoryIds {
    return selectedItems.map((item) => item.categoryId).toSet().toList();
  }
}

/// 爱好状态管理
class HobbyNotifier extends StateNotifier<HobbyState> {
  HobbyNotifier() : super(const HobbyState());

  /// 预设颜色轮盘，用于自定义分类
  static const List<Color> _customCategoryColors = [
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFF6366F1),
    Color(0xFF84CC16),
    Color(0xFF0EA5E9),
  ];

  /// 预设图标轮盘，用于自定义分类
  static const List<IconData> _customCategoryIcons = [
    Icons.star_outline,
    Icons.favorite_outline,
    Icons.lightbulb_outline,
    Icons.emoji_objects_outlined,
    Icons.extension_outlined,
    Icons.local_fire_department_outlined,
    Icons.rocket_outlined,
    Icons.workspace_premium_outlined,
    Icons.card_giftcard_outlined,
    Icons.flag_outlined,
  ];

  /// 添加爱好项目
  void addHobbyItem(String categoryId, String itemName) {
    // 检查是否已存在
    if (state.isItemSelected(categoryId, itemName)) return;

    final newItem = UserHobbyItem(
      categoryId: categoryId,
      itemName: itemName,
    );

    state = state.copyWith(
      selectedItems: [...state.selectedItems, newItem],
    );
  }

  /// 移除爱好项目
  void removeHobbyItem(String categoryId, String itemName) {
    state = state.copyWith(
      selectedItems: state.selectedItems
          .where(
            (item) => !(item.categoryId == categoryId && item.itemName == itemName),
          )
          .toList(),
    );
  }

  /// 切换爱好项目选择状态
  void toggleHobbyItem(String categoryId, String itemName) {
    if (state.isItemSelected(categoryId, itemName)) {
      removeHobbyItem(categoryId, itemName);
    } else {
      addHobbyItem(categoryId, itemName);
    }
  }

  /// 设置当前编辑的分类
  void setCurrentEditingCategory(String? categoryId) {
    state = state.copyWith(currentEditingCategory: categoryId);
  }

  /// 清除所有选择
  void clearAll() {
    state = state.copyWith(selectedItems: []);
  }

  /// 批量设置已选择的爱好（用于从服务器加载）
  void setSelectedItems(List<UserHobbyItem> items) {
    state = state.copyWith(selectedItems: items);
  }

  /// 批量添加热门项目
  void addPopularItems(String categoryId, [int count = 3]) {
    final category = HobbyCategories.getById(categoryId);
    if (category == null) return;

    final popularItems = category.popularItems.take(count);
    for (final item in popularItems) {
      addHobbyItem(categoryId, item);
    }
  }

  /// 添加自定义分类
  void addCustomCategory(String name, {IconData? icon}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    // 生成唯一 id
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final id = 'custom_$timestamp';

    // 从轮盘中循环取颜色和图标
    final colorIndex = state.customCategories.length % _customCategoryColors.length;
    final iconIndex = state.customCategories.length % _customCategoryIcons.length;

    final newCategory = HobbyCategory(
      id: id,
      name: trimmed,
      icon: icon ?? _customCategoryIcons[iconIndex],
      color: _customCategoryColors[colorIndex],
      popularItems: const [],
    );

    state = state.copyWith(
      customCategories: [...state.customCategories, newCategory],
    );
  }

  /// 移除自定义分类（同时移除该分类下已选择的作品）
  void removeCustomCategory(String id) {
    final newCategories = state.customCategories.where((c) => c.id != id).toList();
    final newItems = state.selectedItems.where((item) => item.categoryId != id).toList();
    state = state.copyWith(
      customCategories: newCategories,
      selectedItems: newItems,
    );
  }
}

/// 爱好提供者
final hobbyProvider = StateNotifierProvider<HobbyNotifier, HobbyState>((ref) {
  return HobbyNotifier();
});

/// 当前编辑的分类详情提供者
final currentEditingCategoryProvider = Provider<HobbyCategory?>((ref) {
  final state = ref.watch(hobbyProvider);
  if (state.currentEditingCategory == null) return null;
  return HobbyCategories.getById(state.currentEditingCategory!);
});

/// 已选择的分类数量提供者
final selectedCategoryCountProvider = Provider<int>((ref) {
  final state = ref.watch(hobbyProvider);
  return state.selectedCategoryIds.length;
});

/// 特定分类已选择的项目列表提供者
final selectedItemsByCategoryProvider = Provider.family<List<String>, String>((ref, categoryId) {
  final state = ref.watch(hobbyProvider);
  return state.getSelectedItemsByCategory(categoryId);
});

/// 所有分类提供者（预设 + 自定义）
final allHobbyCategoriesProvider = Provider<List<HobbyCategory>>((ref) {
  final state = ref.watch(hobbyProvider);
  return [...HobbyCategories.all, ...state.customCategories];
});

/// 根据 ID 查找分类（支持自定义分类）
final hobbyCategoryByIdProvider = Provider.family<HobbyCategory?, String>((ref, id) {
  final all = ref.watch(allHobbyCategoriesProvider);
  try {
    return all.firstWhere((c) => c.id == id);
  } catch (e) {
    return null;
  }
});
