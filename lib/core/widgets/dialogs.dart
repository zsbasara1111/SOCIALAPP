import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'buttons.dart';

/// VIP充值提示弹窗
class VipPromptDialog extends StatelessWidget {
  final bool isTimesUp;
  final bool isPremiumFeature;
  final VoidCallback? onUpgradeBasic;
  final VoidCallback? onUpgradePremium;
  final VoidCallback? onLater;

  const VipPromptDialog({
    super.key,
    this.isTimesUp = true,
    this.isPremiumFeature = false,
    this.onUpgradeBasic,
    this.onUpgradePremium,
    this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text(
              isPremiumFeature ? '🎯 精准匹配功能' : '今日匹配次数已用完',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              isPremiumFeature
                  ? '从爱好列表中选择1-8个选项\n只有全部匹配的用户才会展示'
                  : '升级VIP，解锁更多匹配机会',
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.space2Xl),

            // 普通VIP选项
            if (!isPremiumFeature) ...[
              _buildVipOption(
                tier: '普通VIP',
                price: '￥59/月',
                benefits: const [
                  '✓ 同好匹配 无限次',
                  '✓ 同城匹配 50次/天',
                  '✓ 查看谁喜欢我',
                ],
                onTap: onUpgradeBasic,
              ),
              const SizedBox(height: AppTheme.spaceLg),
            ],

            // 高级VIP选项
            _buildVipOption(
              tier: '高级VIP',
              price: '￥99/月',
              benefits: isPremiumFeature
                  ? const [
                      '✓ 解锁精准匹配',
                      '✓ 包含普通VIP全部功能',
                      '✓ 优先客服支持',
                    ]
                  : const [
                      '✓ 包含普通VIP全部功能',
                      '✓ 解锁【精准匹配】功能',
                      '✓ 选定1-8个必选项精确匹配',
                    ],
              onTap: onUpgradePremium,
              isPremium: true,
            ),
            const SizedBox(height: AppTheme.space2Xl),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onLater?.call();
                    },
                    child: const Text('稍后'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: PrimaryButton(
                    text: '立即升级',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onUpgradePremium?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipOption({
    required String tier,
    required String price,
    required List<String> benefits,
    VoidCallback? onTap,
    bool isPremium = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: BoxDecoration(
          gradient: isPremium ? AppTheme.vipGradient : null,
          color: isPremium ? null : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isPremium ? Colors.transparent : AppTheme.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tier,
                  style: AppTheme.titleLarge.copyWith(
                    color: isPremium ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: AppTheme.titleLarge.copyWith(
                    color: isPremium ? Colors.white : AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSm),
            ...benefits.map((benefit) {
              return Padding(
                padding: const EdgeInsets.only(top: AppTheme.spaceXs),
                child: Text(
                  benefit,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isPremium
                        ? Colors.white.withOpacity(0.9)
                        : AppTheme.textSecondary,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 确认弹窗
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.space2Xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDanger ? AppTheme.error : null,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 成功提示弹窗
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppTheme.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLg),
            Text(
              title,
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.space2Xl),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: '好的',
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
