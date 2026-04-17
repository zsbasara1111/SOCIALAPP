import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_interactions_provider.dart';

/// 将数字格式化为简洁字符串（如 18200 → 1.8w，1540 → 1.5k，5 → 5）
String formatCompactNumber(int num) {
  if (num >= 10000) {
    final w = num / 10000;
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

/// 个人统计 Provider：直接从用户交互数据中聚合
final profileStatsProvider = Provider<ProfileStatsState>((ref) {
  final interactions = ref.watch(userInteractionsProvider);

  return ProfileStatsState(
    likedUsersCount: interactions.likedUsers.length,
    visitorsCount: interactions.profileVisitors.length,
    whoLikedMeCount: interactions.usersWhoLikedMe.length,
  );
});

/// 用户个人统计状态（只读）
class ProfileStatsState {
  final int likedUsersCount;      // 我喜欢的人
  final int visitorsCount;        // 看过我的人
  final int whoLikedMeCount;      // 谁喜欢我

  const ProfileStatsState({
    this.likedUsersCount = 0,
    this.visitorsCount = 0,
    this.whoLikedMeCount = 0,
  });
}
