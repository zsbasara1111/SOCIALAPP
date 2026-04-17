import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 交互用户简要信息
class InteractionUser {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final int? age;
  final String? city;
  final DateTime interactedAt;

  const InteractionUser({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.age,
    this.city,
    required this.interactedAt,
  });

  InteractionUser copyWith({
    String? id,
    String? nickname,
    String? avatarUrl,
    int? age,
    String? city,
    DateTime? interactedAt,
  }) {
    return InteractionUser(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      city: city ?? this.city,
      interactedAt: interactedAt ?? this.interactedAt,
    );
  }
}

/// 用户交互状态
class UserInteractionsState {
  final List<InteractionUser> likedUsers;        // 我喜欢的人
  final List<InteractionUser> profileVisitors;   // 看过我的人
  final List<InteractionUser> usersWhoLikedMe;   // 谁喜欢我
  final bool isLoading;
  final String? error;

  const UserInteractionsState({
    this.likedUsers = const [],
    this.profileVisitors = const [],
    this.usersWhoLikedMe = const [],
    this.isLoading = false,
    this.error,
  });

  UserInteractionsState copyWith({
    List<InteractionUser>? likedUsers,
    List<InteractionUser>? profileVisitors,
    List<InteractionUser>? usersWhoLikedMe,
    bool? isLoading,
    String? error,
  }) {
    return UserInteractionsState(
      likedUsers: likedUsers ?? this.likedUsers,
      profileVisitors: profileVisitors ?? this.profileVisitors,
      usersWhoLikedMe: usersWhoLikedMe ?? this.usersWhoLikedMe,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// 用户交互状态管理
class UserInteractionsNotifier extends StateNotifier<UserInteractionsState> {
  UserInteractionsNotifier() : super(const UserInteractionsState()) {
    _loadMockData();
  }

  /// 加载模拟数据（开发测试用）
  void _loadMockData() {
    // 模拟：有2个人看过我，1个人喜欢我
    final now = DateTime.now();
    state = state.copyWith(
      profileVisitors: [
        InteractionUser(
          id: 'v1',
          nickname: '小雨',
          age: 24,
          city: '上海',
          interactedAt: now.subtract(const Duration(hours: 2)),
        ),
        InteractionUser(
          id: 'v2',
          nickname: '旅行者',
          age: 26,
          city: '北京',
          interactedAt: now.subtract(const Duration(days: 1)),
        ),
      ],
      usersWhoLikedMe: [
        InteractionUser(
          id: 'l1',
          nickname: '美食探索家',
          age: 25,
          city: '广州',
          interactedAt: now.subtract(const Duration(minutes: 30)),
        ),
      ],
    );
  }

  /// 记录我喜欢的人（匹配右滑或点喜欢按钮）
  void addLikedUser(InteractionUser user) {
    // 去重：如果已经存在则更新时间
    final exists = state.likedUsers.any((u) => u.id == user.id);
    if (exists) {
      final updated = state.likedUsers.map((u) {
        return u.id == user.id ? user : u;
      }).toList();
      state = state.copyWith(likedUsers: updated);
    } else {
      state = state.copyWith(likedUsers: [...state.likedUsers, user]);
    }
  }

  /// 移除我喜欢的人
  void removeLikedUser(String userId) {
    state = state.copyWith(
      likedUsers: state.likedUsers.where((u) => u.id != userId).toList(),
    );
  }

  /// 记录看过我的人
  void addProfileVisitor(InteractionUser user) {
    if (user.id == 'currentUser') return;
    final exists = state.profileVisitors.any((u) => u.id == user.id);
    if (exists) {
      final updated = state.profileVisitors.map((u) {
        return u.id == user.id ? user : u;
      }).toList();
      state = state.copyWith(profileVisitors: updated);
    } else {
      state = state.copyWith(profileVisitors: [...state.profileVisitors, user]);
    }
  }

  /// 记录喜欢我的人
  void addUserWhoLikedMe(InteractionUser user) {
    if (user.id == 'currentUser') return;
    final exists = state.usersWhoLikedMe.any((u) => u.id == user.id);
    if (exists) {
      final updated = state.usersWhoLikedMe.map((u) {
        return u.id == user.id ? user : u;
      }).toList();
      state = state.copyWith(usersWhoLikedMe: updated);
    } else {
      state = state.copyWith(usersWhoLikedMe: [...state.usersWhoLikedMe, user]);
    }
  }

  /// 清除看过我的人红点（实际就是清空列表，或者标记为已读）
  /// 这里简单处理：保留列表，业务上数量即为真实数字
  void clearProfileVisitors() {
    state = state.copyWith(profileVisitors: const []);
  }

  /// 清除谁喜欢我红点
  void clearUsersWhoLikedMe() {
    state = state.copyWith(usersWhoLikedMe: const []);
  }
}

/// 用户交互 Provider
final userInteractionsProvider =
    StateNotifierProvider<UserInteractionsNotifier, UserInteractionsState>((ref) {
  return UserInteractionsNotifier();
});

/// 我喜欢的人数
final likedUsersCountProvider = Provider<int>((ref) {
  return ref.watch(userInteractionsProvider).likedUsers.length;
});

/// 看过我的人数
final profileVisitorsCountProvider = Provider<int>((ref) {
  return ref.watch(userInteractionsProvider).profileVisitors.length;
});

/// 喜欢我的人数
final usersWhoLikedMeCountProvider = Provider<int>((ref) {
  return ref.watch(userInteractionsProvider).usersWhoLikedMe.length;
});
