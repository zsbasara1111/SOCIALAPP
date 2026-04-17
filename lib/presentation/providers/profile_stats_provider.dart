import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户个人统计状态
class ProfileStatsState {
  final int likedUsersCount;      // 我喜欢的人
  final int visitorsCount;        // 看过我的人
  final int whoLikedMeCount;      // 谁喜欢我
  final bool isLoading;
  final String? error;

  const ProfileStatsState({
    this.likedUsersCount = 0,
    this.visitorsCount = 0,
    this.whoLikedMeCount = 0,
    this.isLoading = false,
    this.error,
  });

  ProfileStatsState copyWith({
    int? likedUsersCount,
    int? visitorsCount,
    int? whoLikedMeCount,
    bool? isLoading,
    String? error,
  }) {
    return ProfileStatsState(
      likedUsersCount: likedUsersCount ?? this.likedUsersCount,
      visitorsCount: visitorsCount ?? this.visitorsCount,
      whoLikedMeCount: whoLikedMeCount ?? this.whoLikedMeCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 个人统计数据管理
class ProfileStatsNotifier extends StateNotifier<ProfileStatsState> {
  ProfileStatsNotifier() : super(const ProfileStatsState()) {
    loadStats();
  }

  /// 从服务器加载统计数据
  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: 从 Supabase 加载真实统计数据
      await Future.delayed(const Duration(milliseconds: 500));

      // 模拟真实数据
      state = state.copyWith(
        likedUsersCount: 18200,
        visitorsCount: 1540,
        whoLikedMeCount: 1930,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载失败',
      );
    }
  }

  /// 刷新统计数据
  Future<void> refresh() async {
    await loadStats();
  }
}

/// 个人统计 Provider
final profileStatsProvider =
    StateNotifierProvider<ProfileStatsNotifier, ProfileStatsState>((ref) {
  return ProfileStatsNotifier();
});

/// 将数字格式化为简洁字符串（如 18200 → 1.8w，1540 → 1.5k）
String formatCompactNumber(int num) {
  if (num >= 10000) {
    final w = num / 10000;
    // 如果是整数万，不显示小数点
    if (w == w.toInt()) {
      return '${w.toInt()}w';
    }
    return '${w.toStringAsFixed(1)}w';
  } else if (num >= 1000) {
    final k = num / 1000;
    if (k == k.toInt()) {
      return '${k.toInt()}k';
    }
    return '${k.toStringAsFixed(1)}k';
  }
  return num.toString();
}
