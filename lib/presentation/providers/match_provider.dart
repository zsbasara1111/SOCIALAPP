import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'hobby_provider.dart';
import 'user_interactions_provider.dart';

/// 匹配模式枚举
enum MatchMode {
  /// 同好模式 - 随机展示
  hobby,
  /// 同城模式 - 按城市筛选
  city,
  /// 精准模式 - VIP功能，多维度筛选
  precise,
}

/// 匹配模式扩展
extension MatchModeExtension on MatchMode {
  String get displayName {
    switch (this) {
      case MatchMode.hobby:
        return '同好';
      case MatchMode.city:
        return '同城';
      case MatchMode.precise:
        return '精准';
    }
  }

  String get description {
    switch (this) {
      case MatchMode.hobby:
        return '发现共同爱好';
      case MatchMode.city:
        return '遇见附近的人';
      case MatchMode.precise:
        return '精准筛选匹配';
    }
  }

  IconData get icon {
    switch (this) {
      case MatchMode.hobby:
        return Icons.favorite_outline;
      case MatchMode.city:
        return Icons.location_on_outlined;
      case MatchMode.precise:
        return Icons.tune;
    }
  }

  bool get isVipOnly => this == MatchMode.precise;
}

/// 匹配用户模型
class MatchUser {
  final String id;
  final String nickname;
  final String? avatarUrl;
  final int? age;
  final String? city;
  final String? bio;
  final List<UserHobbyItem> hobbies;
  final List<String> photoUrls;
  final bool isOnline;
  final DateTime? lastActive;

  const MatchUser({
    required this.id,
    required this.nickname,
    this.avatarUrl,
    this.age,
    this.city,
    this.bio,
    this.hobbies = const [],
    this.photoUrls = const [],
    this.isOnline = false,
    this.lastActive,
  });
}

/// 匹配状态
class MatchState {
  final MatchMode currentMode;
  final List<MatchUser> userQueue;
  final MatchUser? currentUser;
  final bool isLoading;
  final bool isMatch;
  final MatchUser? matchedUser;
  final String? error;

  // 匹配统计
  final int dailyMatchCount;
  final int maxDailyMatches;
  final bool isVip;

  // 同城筛选
  final String? selectedCity;

  // 精准筛选条件
  final PreciseFilter preciseFilter;

  const MatchState({
    this.currentMode = MatchMode.hobby,
    this.userQueue = const [],
    this.currentUser,
    this.isLoading = false,
    this.isMatch = false,
    this.matchedUser,
    this.error,
    this.dailyMatchCount = 0,
    this.maxDailyMatches = 20,
    this.isVip = false,
    this.selectedCity,
    this.preciseFilter = const PreciseFilter(),
  });

  MatchState copyWith({
    MatchMode? currentMode,
    List<MatchUser>? userQueue,
    MatchUser? currentUser,
    bool? isLoading,
    bool? isMatch,
    MatchUser? matchedUser,
    String? error,
    int? dailyMatchCount,
    int? maxDailyMatches,
    bool? isVip,
    String? selectedCity,
    PreciseFilter? preciseFilter,
  }) {
    return MatchState(
      currentMode: currentMode ?? this.currentMode,
      userQueue: userQueue ?? this.userQueue,
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      isMatch: isMatch ?? this.isMatch,
      matchedUser: matchedUser ?? this.matchedUser,
      error: error ?? this.error,
      dailyMatchCount: dailyMatchCount ?? this.dailyMatchCount,
      maxDailyMatches: maxDailyMatches ?? this.maxDailyMatches,
      isVip: isVip ?? this.isVip,
      selectedCity: selectedCity ?? this.selectedCity,
      preciseFilter: preciseFilter ?? this.preciseFilter,
    );
  }

  /// 是否还有匹配次数
  bool get hasMatchQuota => dailyMatchCount < maxDailyMatches || isVip;

  /// 剩余匹配次数
  int get remainingMatches => isVip
      ? -1 // VIP无限次
      : maxDailyMatches - dailyMatchCount;

  /// 匹配进度百分比
  double get matchProgress => dailyMatchCount / maxDailyMatches;
}

/// 精准筛选条件
class PreciseFilter {
  final int? minAge;
  final int? maxAge;
  final String? city;
  final List<String>? hobbyCategoryIds;
  final String? gender;

  const PreciseFilter({
    this.minAge,
    this.maxAge,
    this.city,
    this.hobbyCategoryIds,
    this.gender,
  });

  bool get isEmpty =>
      minAge == null &&
      maxAge == null &&
      city == null &&
      (hobbyCategoryIds?.isEmpty ?? true) &&
      gender == null;

  PreciseFilter copyWith({
    int? minAge,
    int? maxAge,
    String? city,
    List<String>? hobbyCategoryIds,
    String? gender,
  }) {
    return PreciseFilter(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      city: city ?? this.city,
      hobbyCategoryIds: hobbyCategoryIds ?? this.hobbyCategoryIds,
      gender: gender ?? this.gender,
    );
  }
}

/// 匹配状态管理
class MatchNotifier extends StateNotifier<MatchState> {
  final Ref _ref;

  MatchNotifier(this._ref) : super(const MatchState());

  /// 切换匹配模式
  void switchMode(MatchMode mode) {
    // 精准模式需要VIP
    if (mode == MatchMode.precise && !state.isVip) {
      // 显示VIP提示
      return;
    }

    state = state.copyWith(
      currentMode: mode,
      userQueue: [],
      currentUser: null,
      error: null,
    );

    // 加载新用户
    loadNextUser();
  }

  /// 加载下一个用户
  Future<void> loadNextUser() async {
    if (state.isLoading) return;

    // 检查匹配次数
    if (!state.hasMatchQuota) {
      state = state.copyWith(
        error: '今日匹配次数已用完，升级VIP享受无限匹配',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 从Supabase获取匹配用户
      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));

      // 模拟获取用户
      final mockUser = _getMockUser();

      state = state.copyWith(
        currentUser: mockUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载失败，请重试',
      );
    }
  }

  /// 喜欢/右滑
  Future<void> likeUser(String userId) async {
    // TODO: 发送喜欢到服务器

    final current = state.currentUser;
    if (current != null) {
      _ref.read(userInteractionsProvider.notifier).addLikedUser(
        InteractionUser(
          id: current.id,
          nickname: current.nickname,
          avatarUrl: current.avatarUrl,
          age: current.age,
          city: current.city,
          interactedAt: DateTime.now(),
        ),
      );
    }

    // 模拟匹配成功（20%概率）
    final isMatch = DateTime.now().millisecond % 5 == 0;

    if (isMatch) {
      state = state.copyWith(
        isMatch: true,
        matchedUser: state.currentUser,
        dailyMatchCount: state.dailyMatchCount + 1,
      );
    } else {
      state = state.copyWith(
        dailyMatchCount: state.dailyMatchCount + 1,
      );
      // 加载下一个
      await loadNextUser();
    }
  }

  /// 不喜欢/左滑
  Future<void> dislikeUser(String userId) async {
    // TODO: 记录不喜欢到服务器

    state = state.copyWith(
      dailyMatchCount: state.dailyMatchCount + 1,
    );

    // 加载下一个
    await loadNextUser();
  }

  /// 清除匹配弹窗
  void clearMatch() {
    state = state.copyWith(
      isMatch: false,
      matchedUser: null,
    );
    loadNextUser();
  }

  /// 设置同城
  void setCity(String? city) {
    state = state.copyWith(selectedCity: city);
  }

  /// 设置精准筛选条件
  void setPreciseFilter(PreciseFilter filter) {
    state = state.copyWith(preciseFilter: filter);
  }

  /// 重置匹配次数（每日重置）
  void resetDailyCount() {
    state = state.copyWith(dailyMatchCount: 0);
  }

  /// 设置VIP状态
  void setVipStatus(bool isVip) {
    state = state.copyWith(isVip: isVip);
  }

  /// 模拟获取用户数据（包含真实头像的帅哥美女）
  MatchUser _getMockUser() {
    final mockUsers = [
      // 女生
      MatchUser(
        id: '1',
        nickname: '小橘子',
        avatarUrl: 'assets/images/avatars/female_01.jpg',
        age: 24,
        city: '上海',
        bio: '喜欢阅读、旅行，寻找志同道合的朋友',
        photoUrls: [
          'assets/images/avatars/female_01.jpg',
          'assets/images/photos/photo_01.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'books', itemName: '《三体》'),
          UserHobbyItem(categoryId: 'travel', itemName: '日本'),
        ],
        isOnline: true,
      ),
      MatchUser(
        id: '2',
        nickname: '小雨',
        avatarUrl: 'assets/images/avatars/female_02.jpg',
        age: 23,
        city: '杭州',
        bio: '摄影师，用镜头记录生活中的美好瞬间',
        photoUrls: [
          'assets/images/avatars/female_02.jpg',
          'assets/images/photos/photo_02.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'photography', itemName: '人像摄影'),
          UserHobbyItem(categoryId: 'travel', itemName: '西藏'),
        ],
        isOnline: true,
      ),
      MatchUser(
        id: '3',
        nickname: '林夕',
        avatarUrl: 'assets/images/avatars/female_03.jpg',
        age: 25,
        city: '成都',
        bio: '美食探店达人，咖啡重度爱好者',
        photoUrls: [
          'assets/images/avatars/female_03.jpg',
          'assets/images/photos/photo_03.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'food', itemName: '咖啡'),
          UserHobbyItem(categoryId: 'art', itemName: '水彩'),
        ],
        isOnline: false,
      ),
      MatchUser(
        id: '4',
        nickname: '安娜',
        avatarUrl: 'assets/images/avatars/female_04.jpg',
        age: 26,
        city: '广州',
        bio: '瑜伽老师，喜欢运动和音乐',
        photoUrls: [
          'assets/images/avatars/female_04.jpg',
          'assets/images/photos/photo_04.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'sports', itemName: '瑜伽'),
          UserHobbyItem(categoryId: 'music', itemName: 'Taylor Swift'),
        ],
        isOnline: true,
      ),
      // 男生
      MatchUser(
        id: '5',
        nickname: '音乐旅人',
        avatarUrl: 'assets/images/avatars/male_01.jpg',
        age: 26,
        city: '北京',
        bio: '音乐是生活的调味剂，吉他手',
        photoUrls: [
          'assets/images/avatars/male_01.jpg',
          'assets/images/photos/photo_05.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'music', itemName: '吉他'),
          UserHobbyItem(categoryId: 'podcast', itemName: '摇滚'),
        ],
        isOnline: false,
      ),
      MatchUser(
        id: '6',
        nickname: '阿杰',
        avatarUrl: 'assets/images/avatars/male_02.jpg',
        age: 28,
        city: '深圳',
        bio: '程序员，摄影爱好者，周末经常出门拍照',
        photoUrls: [
          'assets/images/avatars/male_02.jpg',
          'assets/images/photos/photo_06.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'photography', itemName: '风光摄影'),
          UserHobbyItem(categoryId: 'games', itemName: '塞尔达'),
        ],
        isOnline: true,
      ),
      MatchUser(
        id: '7',
        nickname: '浩然',
        avatarUrl: 'assets/images/avatars/male_03.jpg',
        age: 27,
        city: '北京',
        bio: '运动达人，喜欢篮球和健身',
        photoUrls: [
          'assets/images/avatars/male_03.jpg',
          'assets/images/photos/photo_07.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'sports', itemName: '篮球'),
          UserHobbyItem(categoryId: 'learning', itemName: '健身'),
        ],
        isOnline: true,
      ),
      MatchUser(
        id: '8',
        nickname: '子轩',
        avatarUrl: 'assets/images/avatars/male_04.jpg',
        age: 25,
        city: '上海',
        bio: '电影爱好者，喜欢诺兰和宫崎骏',
        photoUrls: [
          'assets/images/avatars/male_04.jpg',
          'assets/images/photos/photo_08.jpg',
        ],
        hobbies: [
          UserHobbyItem(categoryId: 'movies', itemName: '诺兰'),
          UserHobbyItem(categoryId: 'anime', itemName: '宫崎骏'),
        ],
        isOnline: false,
      ),
    ];

    return mockUsers[DateTime.now().millisecond % mockUsers.length];
  }
}

/// 匹配提供者
final matchProvider = StateNotifierProvider<MatchNotifier, MatchState>((ref) {
  return MatchNotifier(ref);
});

/// 当前匹配模式提供者
final currentMatchModeProvider = Provider<MatchMode>((ref) {
  return ref.watch(matchProvider).currentMode;
});

/// 剩余匹配次数提供者
final remainingMatchesProvider = Provider<int>((ref) {
  return ref.watch(matchProvider).remainingMatches;
});

/// 是否还有匹配次数提供者
final hasMatchQuotaProvider = Provider<bool>((ref) {
  return ref.watch(matchProvider).hasMatchQuota;
});
