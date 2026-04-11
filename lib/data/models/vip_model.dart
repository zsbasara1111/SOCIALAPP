import 'package:freezed_annotation/freezed_annotation.dart';

part 'vip_model.freezed.dart';
part 'vip_model.g.dart';

/// VIP订阅记录模型
@freezed
class VipSubscriptionModel with _$VipSubscriptionModel {
  const factory VipSubscriptionModel({
    required String id,
    required String userId,
    required String tier, // 'basic' 或 'premium'
    required double price,
    required int durationMonths,
    required DateTime startDate,
    required DateTime endDate,
    @Default(false) bool isAutoRenew,
    String? paymentMethod,
    String? transactionId,
    @Default('active') String status,
    required DateTime createdAt,
  }) = _VipSubscriptionModel;

  factory VipSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$VipSubscriptionModelFromJson(json);
}

/// VIP等级
enum VipTier {
  none,
  basic, // 普通VIP
  premium, // 高级VIP
}

/// VIP等级扩展
extension VipTierExtension on VipTier {
  String get displayName {
    switch (this) {
      case VipTier.none:
        return '普通用户';
      case VipTier.basic:
        return '普通VIP';
      case VipTier.premium:
        return '高级VIP';
    }
  }

  bool get canUsePreciseMatch => this == VipTier.premium;

  bool get hasUnlimitedHobbyMatch => this != VipTier.none;

  int get cityMatchDailyLimit {
    switch (this) {
      case VipTier.none:
        return 10;
      case VipTier.basic:
      case VipTier.premium:
        return 50;
    }
  }

  int get preciseMatchDailyLimit {
    switch (this) {
      case VipTier.none:
      case VipTier.basic:
        return 0;
      case VipTier.premium:
        return 30;
    }
  }
}

/// VIP套餐信息
@freezed
class VipPackageModel with _$VipPackageModel {
  const factory VipPackageModel({
    required String tier,
    required String name,
    required String price,
    required String period,
    required List<String> benefits,
    @Default(false) bool isPopular,
  }) = _VipPackageModel;

  factory VipPackageModel.fromJson(Map<String, dynamic> json) =>
      _$VipPackageModelFromJson(json);
}

/// 标准VIP套餐数据
class VipPackages {
  static final basic = VipPackageModel(
    tier: 'basic',
    name: '普通VIP',
    price: '¥59',
    period: '/月',
    benefits: const [
      '同好匹配 无限次',
      '同城匹配 50次/天',
      '查看谁喜欢我',
    ],
    isPopular: false,
  );

  static final premium = VipPackageModel(
    tier: 'premium',
    name: '高级VIP',
    price: '¥99',
    period: '/月',
    benefits: const [
      '包含普通VIP全部功能',
      '解锁【精准匹配】功能',
      '优先客服支持',
    ],
    isPopular: true,
  );
}
