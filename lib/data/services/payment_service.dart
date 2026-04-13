import 'dart:math';

/// 支付方式
enum PaymentMethod {
  alipay,    // 支付宝
  wechat,    // 微信支付
  applePay,  // Apple Pay
}

/// 支付方式扩展
extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.alipay:
        return '支付宝';
      case PaymentMethod.wechat:
        return '微信支付';
      case PaymentMethod.applePay:
        return 'Apple Pay';
    }
  }

  String get iconAsset {
    // TODO: 接入真实支付图标资源
    switch (this) {
      case PaymentMethod.alipay:
        return 'assets/icons/alipay.png';
      case PaymentMethod.wechat:
        return 'assets/icons/wechat_pay.png';
      case PaymentMethod.applePay:
        return 'assets/icons/apple_pay.png';
    }
  }
}

/// 支付结果
enum PaymentResult {
  success,
  cancelled,
  failed,
  pending,
}

/// 支付订单信息
class PaymentOrder {
  final String orderId;
  final String productId;
  final String productName;
  final double amount;
  final PaymentMethod method;
  final DateTime createdAt;
  final PaymentResult result;
  final String? transactionId;
  final String? errorMessage;

  const PaymentOrder({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.method,
    required this.createdAt,
    this.result = PaymentResult.pending,
    this.transactionId,
    this.errorMessage,
  });

  PaymentOrder copyWith({
    String? orderId,
    String? productId,
    String? productName,
    double? amount,
    PaymentMethod? method,
    DateTime? createdAt,
    PaymentResult? result,
    String? transactionId,
    String? errorMessage,
  }) {
    return PaymentOrder(
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      result: result ?? this.result,
      transactionId: transactionId ?? this.transactionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 支付服务接口
abstract class IPaymentService {
  /// 获取支持的支付方式
  List<PaymentMethod> getSupportedMethods();

  /// 发起支付
  ///
  /// [productId] - 商品ID
  /// [productName] - 商品名称
  /// [amount] - 支付金额（元）
  /// [method] - 支付方式
  Future<PaymentOrder> initiatePayment({
    required String productId,
    required String productName,
    required double amount,
    required PaymentMethod method,
  });

  /// 查询订单状态
  Future<PaymentOrder> queryOrderStatus(String orderId);

  /// 验证支付结果（服务端验证）
  Future<bool> verifyPayment(PaymentOrder order);
}

/// 支付服务实现
///
/// 当前为模拟实现，用于开发和测试。
/// 正式上线前需要替换为真实支付SDK：
/// - 支付宝：使用 tobias 或 alipay_kit
/// - 微信支付：使用 fluwx
/// - Apple Pay：使用 pay 或 in_app_purchase
class PaymentService implements IPaymentService {
  // 模拟订单存储
  final Map<String, PaymentOrder> _orders = {};

  @override
  List<PaymentMethod> getSupportedMethods() {
    // TODO: 根据平台返回支持的支付方式
    // iOS: 支付宝、微信、Apple Pay
    // Android: 支付宝、微信
    return [PaymentMethod.alipay, PaymentMethod.wechat, PaymentMethod.applePay];
  }

  @override
  Future<PaymentOrder> initiatePayment({
    required String productId,
    required String productName,
    required double amount,
    required PaymentMethod method,
  }) async {
    // 生成订单号
    final orderId = _generateOrderId();

    // 创建订单
    final order = PaymentOrder(
      orderId: orderId,
      productId: productId,
      productName: productName,
      amount: amount,
      method: method,
      createdAt: DateTime.now(),
    );

    _orders[orderId] = order;

    // TODO: 调用真实支付SDK
    // 真实实现步骤：
    // 1. 调用后端创建订单，获取支付参数
    // 2. 调起对应支付SDK
    // 3. 等待支付结果回调
    // 4. 更新订单状态

    // 模拟调起支付和等待结果
    await Future.delayed(const Duration(seconds: 2));

    // 模拟支付结果（90%成功率）
    final isSuccess = Random().nextDouble() < 0.9;

    final updatedOrder = order.copyWith(
      result: isSuccess ? PaymentResult.success : PaymentResult.failed,
      transactionId: isSuccess ? 'TRX${_generateOrderId()}' : null,
      errorMessage: isSuccess ? null : '模拟支付失败',
    );

    _orders[orderId] = updatedOrder;
    return updatedOrder;
  }

  @override
  Future<PaymentOrder> queryOrderStatus(String orderId) async {
    // TODO: 调用后端查询订单状态
    await Future.delayed(const Duration(milliseconds: 500));

    final order = _orders[orderId];
    if (order == null) {
      throw Exception('订单不存在');
    }

    return order;
  }

  @override
  Future<bool> verifyPayment(PaymentOrder order) async {
    // TODO: 调用后端验证支付结果
    // 真实实现中，这一步非常重要：
    // 1. 将订单号和交易号发送到后端
    // 2. 后端向支付平台（支付宝/微信/Apple）验证
    // 3. 返回验证结果

    await Future.delayed(const Duration(milliseconds: 800));

    return order.result == PaymentResult.success && order.transactionId != null;
  }

  /// 生成订单号
  String _generateOrderId() {
    final now = DateTime.now();
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'ORD${now.millisecondsSinceEpoch}$random';
  }
}

/// 支付服务Provider
///
/// 使用Provider模式，方便后续替换为真实实现或Mock
final paymentService = PaymentService();
