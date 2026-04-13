import 'package:flutter_riverpod/flutter_riverpod.dart';

/// VIP套餐类型
enum VipPlan {
  monthly,
  quarterly,
  yearly,
}

/// VIP套餐扩展
extension VipPlanExtension on VipPlan {
  String get displayName {
    switch (this) {
      case VipPlan.monthly:
        return '月度会员';
      case VipPlan.quarterly:
        return '季度会员';
      case VipPlan.yearly:
        return '年度会员';
    }
  }

  String get subtitle {
    switch (this) {
      case VipPlan.monthly:
        return '适合初次体验';
      case VipPlan.quarterly:
        return '最受欢迎';
      case VipPlan.yearly:
        return '最划算，省40%';
    }
  }

  double get price {
    switch (this) {
      case VipPlan.monthly:
        return 38.0;
      case VipPlan.quarterly:
        return 98.0;
      case VipPlan.yearly:
        return 298.0;
    }
  }

  double get originalPrice {
    switch (this) {
      case VipPlan.monthly:
        return 38.0;
      case VipPlan.quarterly:
        return 114.0;
      case VipPlan.yearly:
        return 456.0;
    }
  }

  int get durationDays {
    switch (this) {
      case VipPlan.monthly:
        return 30;
      case VipPlan.quarterly:
        return 90;
      case VipPlan.yearly:
        return 365;
    }
  }

  bool get isMostPopular => this == VipPlan.quarterly;
  bool get isBestValue => this == VipPlan.yearly;
}

/// VIP权益
class VipBenefit {
  final String id;
  final String title;
  final String description;
  final String icon;

  const VipBenefit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// VIP权益列表
const List<VipBenefit> vipBenefits = [
  VipBenefit(
    id: 'unlimited_matches',
    title: '无限匹配',
    description: '每日无限制匹配，找到对的人',
    icon: 'favorite',
  ),
  VipBenefit(
    id: 'precise_filter',
    title: '精准筛选',
    description: '按年龄、城市、爱好多维度筛选',
    icon: 'tune',
  ),
  VipBenefit(
    id: 'see_who_liked',
    title: '查看喜欢',
    description: '查看谁喜欢了你，不错过缘分',
    icon: 'visibility',
  ),
  VipBenefit(
    id: 'priority_recommend',
    title: '优先推荐',
    description: '在他人匹配中优先展示',
    icon: 'stars',
  ),
  VipBenefit(
    id: 'read_receipt',
    title: '已读回执',
    description: '知道对方是否已读消息',
    icon: 'done_all',
  ),
  VipBenefit(
    id: 'incognito_mode',
    title: '隐身模式',
    description: '浏览他人资料不留痕迹',
    icon: 'visibility_off',
  ),
  VipBenefit(
    id: 'ai_assistant',
    title: 'AI话题助手',
    description: '智能生成聊天话题和开场白',
    icon: 'auto_awesome',
  ),
  VipBenefit(
    id: 'red_heart',
    title: '红心约会',
    description: '互点红心解锁约会邀请功能',
    icon: 'favorite',
  ),
];

/// VIP状态
class VipState {
  final bool isVip;
  final DateTime? expireDate;
  final bool isAutoRenew;
  final VipPlan? currentPlan;
  final bool isLoading;
  final String? error;

  const VipState({
    this.isVip = false,
    this.expireDate,
    this.isAutoRenew = false,
    this.currentPlan,
    this.isLoading = false,
    this.error,
  });

  VipState copyWith({
    bool? isVip,
    DateTime? expireDate,
    bool? isAutoRenew,
    VipPlan? currentPlan,
    bool? isLoading,
    String? error,
  }) {
    return VipState(
      isVip: isVip ?? this.isVip,
      expireDate: expireDate ?? this.expireDate,
      isAutoRenew: isAutoRenew ?? this.isAutoRenew,
      currentPlan: currentPlan ?? this.currentPlan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// 剩余天数
  int get remainingDays {
    if (expireDate == null) return 0;
    final now = DateTime.now();
    final difference = expireDate!.difference(now);
    return difference.inDays.clamp(0, 999);
  }

  /// 是否即将过期（7天内）
  bool get isExpiringSoon => isVip && remainingDays <= 7;

  /// 过期日期格式化
  String get expireDateFormatted {
    if (expireDate == null) return '';
    return '${expireDate!.year}年${expireDate!.month}月${expireDate!.day}日';
  }
}

/// VIP状态管理
class VipNotifier extends StateNotifier<VipState> {
  VipNotifier() : super(const VipState()) {
    // 初始化时加载VIP状态
    _loadVipStatus();
  }

  /// 从服务器加载VIP状态
  Future<void> _loadVipStatus() async {
    // TODO: 从Supabase加载VIP状态
    // 模拟加载
    await Future.delayed(const Duration(milliseconds: 500));

    // 模拟VIP状态（开发测试用）
    // state = VipState(
    //   isVip: true,
    //   expireDate: DateTime.now().add(const Duration(days: 30)),
    //   currentPlan: VipPlan.monthly,
    // );
  }

  /// 购买VIP
  Future<bool> purchaseVip(VipPlan plan) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用支付SDK
      // 1. 创建订单
      // 2. 调起支付
      // 3. 验证支付结果
      // 4. 更新VIP状态

      // 模拟支付成功
      await Future.delayed(const Duration(seconds: 2));

      final now = DateTime.now();
      state = state.copyWith(
        isVip: true,
        expireDate: now.add(Duration(days: plan.durationDays)),
        currentPlan: plan,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '购买失败，请重试',
      );
      return false;
    }
  }

  /// 设置自动续费
  Future<void> setAutoRenew(bool value) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: 调用服务器设置自动续费
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(
        isAutoRenew: value,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '设置失败',
      );
    }
  }

  /// 取消自动续费
  Future<void> cancelAutoRenew() async {
    await setAutoRenew(false);
  }

  /// 检查VIP是否过期
  void checkExpiration() {
    if (state.expireDate != null &&
        DateTime.now().isAfter(state.expireDate!)) {
      state = state.copyWith(
        isVip: false,
        expireDate: null,
        currentPlan: null,
      );
    }
  }

  /// 刷新VIP状态
  Future<void> refreshStatus() async {
    await _loadVipStatus();
  }
}

/// VIP提供者
final vipProvider = StateNotifierProvider<VipNotifier, VipState>((ref) {
  return VipNotifier();
});

/// VIP状态提供者（简化版，只返回是否VIP）
final isVipProvider = Provider<bool>((ref) {
  return ref.watch(vipProvider).isVip;
});

/// VIP剩余天数提供者
final vipRemainingDaysProvider = Provider<int>((ref) {
  return ref.watch(vipProvider).remainingDays;
});
