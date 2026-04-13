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

  const HobbyState({
    this.selectedItems = const [],
    this.currentEditingCategory,
    this.isLoading = false,
    this.error,
  });

  HobbyState copyWith({
    List<UserHobbyItem>? selectedItems,
    String? currentEditingCategory,
    bool? isLoading,
    String? error,
  }) {
    return HobbyState(
      selectedItems: selectedItems ?? this.selectedItems,
      currentEditingCategory: currentEditingCategory ?? this.currentEditingCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
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
