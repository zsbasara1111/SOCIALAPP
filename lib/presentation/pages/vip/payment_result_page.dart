import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/payment_service.dart';
import '../../providers/vip_provider.dart';

/// 支付结果页面
class PaymentResultPage extends ConsumerWidget {
  final PaymentOrder order;
  final VipPlan plan;

  const PaymentResultPage({
    super.key,
    required this.order,
    required this.plan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuccess = order.result == PaymentResult.success;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 结果图标
                    _buildResultIcon(isSuccess),
                    const SizedBox(height: AppTheme.spaceXl),

                    // 结果标题
                    Text(
                      isSuccess ? '支付成功' : '支付失败',
                      style: AppTheme.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSuccess ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    // 结果描述
                    Text(
                      isSuccess
                          ? '恭喜您成为VIP会员，即刻享受专属权益'
                          : (order.errorMessage ?? '支付未完成，请重试'),
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppTheme.spaceXl),

                    // 订单信息
                    _buildOrderInfo(),
                  ],
                ),
              ),
            ),

            // 底部按钮
            _buildBottomBar(context, isSuccess),
          ],
        ),
      ),
    );
  }

  /// 构建结果图标
  Widget _buildResultIcon(bool isSuccess) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: isSuccess
            ? AppTheme.success.withOpacity(0.1)
            : AppTheme.error.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSuccess ? Icons.check_circle : Icons.error_outline,
        size: 64,
        color: isSuccess ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  /// 构建订单信息
  Widget _buildOrderInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow('订单号', order.orderId),
          const SizedBox(height: AppTheme.spaceMd),
          _buildInfoRow('商品', plan.displayName),
          const SizedBox(height: AppTheme.spaceMd),
          _buildInfoRow('支付方式', order.method.displayName),
          const SizedBox(height: AppTheme.spaceMd),
          Divider(color: AppTheme.surfaceVariant),
          const SizedBox(height: AppTheme.spaceMd),
          _buildInfoRow(
            '实付金额',
            '¥${order.amount.toInt()}',
            valueColor: AppTheme.vipGold,
            valueStyle: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppTheme.textPrimary,
              ),
        ),
      ],
    );
  }

  /// 构建底部按钮栏
  Widget _buildBottomBar(BuildContext context, bool isSuccess) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.surfaceVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSuccess) ...[
              // 返回首页按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 返回VIP中心
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.vipGold,
                    foregroundColor: const Color(0xFF1A1D23),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: Text(
                    '查看VIP权益',
                    style: AppTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              // 返回按钮
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    '返回首页',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // 重试按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: Text(
                    '重新支付',
                    style: AppTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              // 返回VIP中心
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Text(
                    '返回VIP中心',
                    style: AppTheme.labelLarge.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
