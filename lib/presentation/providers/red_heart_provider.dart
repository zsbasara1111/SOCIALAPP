import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 红心记录
class RedHeartRecord {
  final String id;
  final String senderId;
  final String receiverId;
  final DateTime sentAt;
  final bool isMutual; // 是否互点
  final DateTime? mutualAt; // 互点时间
  final bool hasDateInvitation; // 是否已发送约会邀请

  const RedHeartRecord({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.sentAt,
    this.isMutual = false,
    this.mutualAt,
    this.hasDateInvitation = false,
  });

  RedHeartRecord copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    DateTime? sentAt,
    bool? isMutual,
    DateTime? mutualAt,
    bool? hasDateInvitation,
  }) {
    return RedHeartRecord(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      sentAt: sentAt ?? this.sentAt,
      isMutual: isMutual ?? this.isMutual,
      mutualAt: mutualAt ?? this.mutualAt,
      hasDateInvitation: hasDateInvitation ?? this.hasDateInvitation,
    );
  }
}

/// 红心状态
class RedHeartState {
  final List<RedHeartRecord> sentHearts;      // 我发出的红心
  final List<RedHeartRecord> receivedHearts;  // 我收到的红心
  final List<RedHeartRecord> mutualHearts;    // 互点红心
  final Map<String, DateTime> chatActivations;     // 我在聊天中对某用户激活红心的时间
  final Map<String, DateTime> receivedChatActivations; // 对方在聊天中对我激活红心的时间
  final bool isLoading;
  final String? error;

  const RedHeartState({
    this.sentHearts = const [],
    this.receivedHearts = const [],
    this.mutualHearts = const [],
    this.chatActivations = const {},
    this.receivedChatActivations = const {},
    this.isLoading = false,
    this.error,
  });

  RedHeartState copyWith({
    List<RedHeartRecord>? sentHearts,
    List<RedHeartRecord>? receivedHearts,
    List<RedHeartRecord>? mutualHearts,
    Map<String, DateTime>? chatActivations,
    Map<String, DateTime>? receivedChatActivations,
    bool? isLoading,
    String? error,
  }) {
    return RedHeartState(
      sentHearts: sentHearts ?? this.sentHearts,
      receivedHearts: receivedHearts ?? this.receivedHearts,
      mutualHearts: mutualHearts ?? this.mutualHearts,
      chatActivations: chatActivations ?? this.chatActivations,
      receivedChatActivations: receivedChatActivations ?? this.receivedChatActivations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 是否已向某用户发送红心
  bool hasSentHeartTo(String userId) {
    return sentHearts.any((h) => h.receiverId == userId);
  }

  /// 某用户是否向我发送了红心
  bool hasReceivedHeartFrom(String userId) {
    return receivedHearts.any((h) => h.senderId == userId);
  }

  /// 是否与某用户互点红心
  bool isMutualWith(String userId) {
    return mutualHearts.any((h) =>
        h.senderId == userId || h.receiverId == userId);
  }

  /// 获取与某用户的互点记录
  RedHeartRecord? getMutualRecord(String userId) {
    try {
      return mutualHearts.firstWhere((h) =>
          h.senderId == userId || h.receiverId == userId);
    } catch (e) {
      return null;
    }
  }

  /// 是否在聊天中对某用户激活了红心
  bool hasChatActivated(String userId) {
    return chatActivations.containsKey(userId);
  }

  /// 某用户是否在聊天中对我激活了红心
  bool hasReceivedChatActivation(String userId) {
    return receivedChatActivations.containsKey(userId);
  }
}

/// 红心状态管理
class RedHeartNotifier extends StateNotifier<RedHeartState> {
  Timer? _mutualCheckTimer;

  RedHeartNotifier() : super(const RedHeartState()) {
    _loadRedHearts();
    _startMutualCheckTimer();
  }

  @override
  void dispose() {
    _mutualCheckTimer?.cancel();
    super.dispose();
  }

  /// 启动互检定时器，每10秒检查一次
  void _startMutualCheckTimer() {
    _mutualCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkPendingMutuals();
    });
  }

  /// 加载红心记录
  Future<void> _loadRedHearts() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: 从Supabase加载红心记录
      await Future.delayed(const Duration(milliseconds: 500));

      // 模拟数据：已有一个互点红心（user1）
      final mockMutual = RedHeartRecord(
        id: 'rh1',
        senderId: 'currentUser',
        receiverId: 'user1',
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
        isMutual: true,
        mutualAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      // 模拟数据：user2 已经在聊天中对我激活了红心（6分钟前）
      final mockReceivedActivations = {
        'user2': DateTime.now().subtract(const Duration(minutes: 6)),
      };

      state = state.copyWith(
        mutualHearts: [mockMutual],
        receivedChatActivations: mockReceivedActivations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载失败',
      );
    }
  }

  /// 发送红心
  ///
  /// [receiverId] - 接收者ID
  /// 返回是否形成互点
  Future<bool> sendRedHeart(String receiverId) async {
    // 检查是否已经发送过
    if (state.hasSentHeartTo(receiverId)) {
      return state.isMutualWith(receiverId);
    }

    try {
      // TODO: 调用API发送红心
      await Future.delayed(const Duration(milliseconds: 300));

      final record = RedHeartRecord(
        id: 'rh_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'currentUser',
        receiverId: receiverId,
        sentAt: DateTime.now(),
      );

      // 检查是否对方已经向我发送过红心（模拟互点检测）
      final isMutual = state.hasReceivedHeartFrom(receiverId) ||
          // 模拟30%概率互点
          (DateTime.now().millisecond % 10 < 3);

      if (isMutual) {
        final mutualRecord = record.copyWith(
          isMutual: true,
          mutualAt: DateTime.now(),
        );

        state = state.copyWith(
          sentHearts: [...state.sentHearts, mutualRecord],
          mutualHearts: [...state.mutualHearts, mutualRecord],
        );
        return true;
      } else {
        state = state.copyWith(
          sentHearts: [...state.sentHearts, record],
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: '发送失败，请重试');
      return false;
    }
  }

  /// 标记已发送约会邀请
  void markDateInvitationSent(String userId) {
    final updatedMutual = state.mutualHearts.map((h) {
      if (h.senderId == userId || h.receiverId == userId) {
        return h.copyWith(hasDateInvitation: true);
      }
      return h;
    }).toList();

    state = state.copyWith(mutualHearts: updatedMutual);
  }

  /// 取消红心
  Future<void> cancelRedHeart(String receiverId) async {
    try {
      // TODO: 调用API取消红心
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedSent = state.sentHearts
          .where((h) => h.receiverId != receiverId)
          .toList();
      final updatedMutual = state.mutualHearts
          .where((h) => h.receiverId != receiverId && h.senderId != receiverId)
          .toList();

      state = state.copyWith(
        sentHearts: updatedSent,
        mutualHearts: updatedMutual,
      );
    } catch (e) {
      state = state.copyWith(error: '取消失败');
    }
  }

  /// 切换聊天红心状态
  Future<void> toggleChatRedHeart(String userId) async {
    final isActivated = state.hasChatActivated(userId);

    if (isActivated) {
      // 取消激活
      final updatedActivations = Map<String, DateTime>.from(state.chatActivations);
      updatedActivations.remove(userId);
      state = state.copyWith(chatActivations: updatedActivations);
    } else {
      // 激活
      final updatedActivations = Map<String, DateTime>.from(state.chatActivations);
      updatedActivations[userId] = DateTime.now();
      state = state.copyWith(chatActivations: updatedActivations);
      _checkPendingMutuals();
    }
  }

  /// 检查是否有满足5分钟条件的聊天红心互点
  void _checkPendingMutuals() {
    final now = DateTime.now();
    final mutualDuration = const Duration(minutes: 5);

    for (final entry in state.chatActivations.entries) {
      final userId = entry.key;
      final myActivatedAt = entry.value;
      final theirActivatedAt = state.receivedChatActivations[userId];

      // 跳过已经互点的
      if (state.isMutualWith(userId)) continue;

      if (theirActivatedAt != null) {
        final myDuration = now.difference(myActivatedAt);
        final theirDuration = now.difference(theirActivatedAt);
        if (myDuration >= mutualDuration && theirDuration >= mutualDuration) {
          _convertToMutual(userId);
        }
      }
    }
  }

  /// 将聊天红心转为互点记录
  Future<void> _convertToMutual(String userId) async {
    final now = DateTime.now();
    final record = RedHeartRecord(
      id: 'rh_chat_${now.millisecondsSinceEpoch}',
      senderId: 'currentUser',
      receiverId: userId,
      sentAt: now,
      isMutual: true,
      mutualAt: now,
    );

    state = state.copyWith(
      mutualHearts: [...state.mutualHearts, record],
    );
  }

  /// 刷新状态
  Future<void> refresh() async {
    await _loadRedHearts();
  }
}

/// 红心Provider
final redHeartProvider =
    StateNotifierProvider<RedHeartNotifier, RedHeartState>((ref) {
  return RedHeartNotifier();
});

/// 是否与某用户互点红心
final isMutualHeartProvider = Provider.family<bool, String>((ref, userId) {
  return ref.watch(redHeartProvider).isMutualWith(userId);
});

/// 是否已向某用户发送红心
final hasSentHeartProvider = Provider.family<bool, String>((ref, userId) {
  return ref.watch(redHeartProvider).hasSentHeartTo(userId);
});

/// 是否在聊天中对某用户激活了红心
final hasChatRedHeartProvider = Provider.family<bool, String>((ref, userId) {
  return ref.watch(redHeartProvider).hasChatActivated(userId);
});

/// 互点红心列表
final mutualHeartsProvider = Provider<List<RedHeartRecord>>((ref) {
  return ref.watch(redHeartProvider).mutualHearts;
});
