import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/payment_service.dart';
import '../../providers/vip_provider.dart';
import 'payment_result_page.dart';

/// 支付方式选择页面
class PaymentMethodPage extends ConsumerStatefulWidget {
  final VipPlan plan;

  const PaymentMethodPage({
    super.key,
    required this.plan,
  });

  @override
  ConsumerState<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends ConsumerState<PaymentMethodPage> {
  PaymentMethod selectedMethod = PaymentMethod.alipay;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final supportedMethods = paymentService.getSupportedMethods();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.textPrimary,
        ),
        title: Text(
          '确认支付',
          style: AppTheme.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 商品信息
          _buildProductInfo(plan),

          // 支付方式
          Expanded(
            child: _buildPaymentMethods(supportedMethods),
          ),

          // 底部支付按钮
          _buildBottomBar(plan),
        ],
      ),
    );
  }

  /// 构建商品信息
  Widget _buildProductInfo(VipPlan plan) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceLg),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.vipGold.withOpacity(0.2),
            AppTheme.vipGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: AppTheme.vipGold.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.workspace_premium,
                color: AppTheme.vipGold,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Text(
                plan.displayName,
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Text(
            '¥${plan.price.toInt()}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppTheme.vipGold,
            ),
          ),
          if (plan.originalPrice != plan.price) ...[
            const SizedBox(height: AppTheme.spaceXs),
            Text(
              '原价 ¥${plan.originalPrice.toInt()}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            '开通后立享8项VIP专属权益',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建支付方式列表
  Widget _buildPaymentMethods(List<PaymentMethod> methods) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Row(
              children: [
                Text(
                  '支付方式',
                  style: AppTheme.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.surfaceVariant,
            indent: AppTheme.spaceLg,
            endIndent: AppTheme.spaceLg,
          ),
          ...methods.map((method) => _buildMethodItem(method)),
        ],
      ),
    );
  }

  /// 构建单个支付方式项
  Widget _buildMethodItem(PaymentMethod method) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: isProcessing
          ? null
          : () {
              setState(() {
                selectedMethod = method;
              });
            },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // 支付图标
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getMethodColor(method).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Icon(
                _getMethodIcon(method),
                color: _getMethodColor(method),
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMd),

            // 支付方式名称
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.displayName,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (method == PaymentMethod.applePay)
                    Text(
                      '安全快捷的Apple支付',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                    ),
                ],
              ),
            ),

            // 选中状态
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建底部支付栏
  Widget _buildBottomBar(VipPlan plan) {
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
        child: Row(
          children: [
            // 总价
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '实付金额',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '¥${plan.price.toInt()}',
                  style: AppTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.vipGold,
                  ),
                ),
              ],
            ),

            const SizedBox(width: AppTheme.spaceLg),

            // 支付按钮
            Expanded(
              child: ElevatedButton(
                onPressed: isProcessing ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.vipGold,
                  foregroundColor: const Color(0xFF1A1D23),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF1A1D23)),
                        ),
                      )
                    : Text(
                        '确认支付',
                        style: AppTheme.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理支付
  Future<void> _handlePayment() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final order = await ref.read(vipProvider.notifier).purchaseVip(
            widget.plan,
            method: selectedMethod,
          );

      if (mounted) {
        // 跳转到支付结果页面
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PaymentResultPage(
              order: order,
              plan: widget.plan,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('支付失败: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  /// 获取支付方式颜色
  Color _getMethodColor(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.alipay:
        return const Color(0xFF1677FF);
      case PaymentMethod.wechat:
        return const Color(0xFF07C160);
      case PaymentMethod.applePay:
        return AppTheme.textPrimary;
    }
  }

  /// 获取支付方式图标
  IconData _getMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.alipay:
        return Icons.account_balance_wallet;
      case PaymentMethod.wechat:
        return Icons.chat;
      case PaymentMethod.applePay:
        return Icons.apple;
    }
  }
}
