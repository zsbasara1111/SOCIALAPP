import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/vip_provider.dart';

/// VIP中心页面
class VipCenterPage extends ConsumerStatefulWidget {
  const VipCenterPage({super.key});

  @override
  ConsumerState<VipCenterPage> createState() => _VipCenterPageState();
}

class _VipCenterPageState extends ConsumerState<VipCenterPage> {
  VipPlan selectedPlan = VipPlan.quarterly;

  @override
  Widget build(BuildContext context) {
    final vipState = ref.watch(vipProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D23),
      body: CustomScrollView(
        slivers: [
          // 顶部VIP信息
          SliverToBoxAdapter(
            child: _buildVipHeader(vipState),
          ),

          // 权益列表
          SliverToBoxAdapter(
            child: _buildBenefitsSection(),
          ),

          // 套餐选择
          SliverToBoxAdapter(
            child: _buildPlansSection(),
          ),

          // FAQ
          SliverToBoxAdapter(
            child: _buildFaqSection(),
          ),

          // 底部安全区域
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // 底部购买按钮
      bottomNavigationBar: _buildBottomBar(vipState),
    );
  }

  /// 构建VIP头部
  Widget _buildVipHeader(VipState vipState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spaceLg,
        60,
        AppTheme.spaceLg,
        AppTheme.spaceXl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.vipGold.withOpacity(0.3),
            const Color(0xFF1A1D23),
          ],
        ),
      ),
      child: Column(
        children: [
          // VIP徽章
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.vipGold, AppTheme.vipGoldLight],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.vipGold.withOpacity(0.4),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 40,
              color: Color(0xFF1A1D23),
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // 标题
          Text(
            vipState.isVip ? 'VIP会员' : '开通VIP',
            style: const TextStyle(
              fontFamily: AppTheme.fontFamilyDisplay,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.vipGold,
            ),
          ),

          const SizedBox(height: AppTheme.spaceSm),

          // 状态描述
          Text(
            vipState.isVip
                ? '会员有效期至 ${vipState.expireDateFormatted}'
                : '解锁无限匹配、精准筛选等8项专属权益',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),

          // 剩余天数（如果是VIP）
          if (vipState.isVip) ...[
            const SizedBox(height: AppTheme.spaceMd),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceMd,
                vertical: AppTheme.spaceXs,
              ),
              decoration: BoxDecoration(
                color: vipState.isExpiringSoon
                    ? const Color(0xFFEF4444).withOpacity(0.2)
                    : AppTheme.vipGold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: Text(
                '剩余 ${vipState.remainingDays} 天',
                style: TextStyle(
                  color: vipState.isExpiringSoon
                      ? const Color(0xFFEF4444)
                      : AppTheme.vipGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建权益区域
  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VIP专属权益',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),

          // 权益网格
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
            ),
            itemCount: vipBenefits.length,
            itemBuilder: (context, index) {
              final benefit = vipBenefits[index];
              return _buildBenefitItem(benefit);
            },
          ),
        ],
      ),
    );
  }

  /// 构建权益项
  Widget _buildBenefitItem(VipBenefit benefit) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.vipGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Icon(
            _getIconData(benefit.icon),
            color: AppTheme.vipGold,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          benefit.title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 构建套餐选择区域
  Widget _buildPlansSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择套餐',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),

          // 套餐卡片
          ...VipPlan.values.map((plan) {
            final isSelected = selectedPlan == plan;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPlan = plan;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [AppTheme.vipGold, AppTheme.vipGoldLight],
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFF252A32),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                ),
                child: Row(
                  children: [
                    // 选择指示器
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A1D23)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1A1D23)
                              : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: AppTheme.vipGold,
                            )
                          : null,
                    ),

                    const SizedBox(width: AppTheme.spaceMd),

                    // 套餐信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                plan.displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF1A1D23)
                                      : Colors.white.withOpacity(0.9),
                                ),
                              ),
                              if (plan.isMostPopular) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF1A1D23)
                                            .withOpacity(0.2)
                                        : AppTheme.vipGold.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '热门',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? const Color(0xFF1A1D23)
                                          : AppTheme.vipGold,
                                    ),
                                  ),
                                ),
                              ],
                              if (plan.isBestValue) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '省40%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? const Color(0xFF1A1D23).withOpacity(0.7)
                                  : Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 价格
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥${plan.price.toInt()}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF1A1D23)
                                : AppTheme.vipGold,
                          ),
                        ),
                        if (plan.originalPrice != plan.price)
                          Text(
                            '¥${plan.originalPrice.toInt()}',
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: isSelected
                                  ? const Color(0xFF1A1D23).withOpacity(0.5)
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 构建FAQ区域
  Widget _buildFaqSection() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '常见问题',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLg),
          _buildFaqItem(
            question: 'VIP会员可以退款吗？',
            answer: '虚拟商品一经购买不支持退款，请您确认后再购买。',
          ),
          _buildFaqItem(
            question: '如何取消自动续费？',
            answer: '您可以在"我的-VIP中心-管理订阅"中随时取消自动续费。',
          ),
          _buildFaqItem(
            question: 'VIP权益会变化吗？',
            answer: '我们会持续优化VIP权益，已购买的用户可享受全部更新权益。',
          ),
        ],
      ),
    );
  }

  /// 构建FAQ项
  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: const Color(0xFF252A32),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部购买栏
  Widget _buildBottomBar(VipState vipState) {
    final plan = selectedPlan;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: const Color(0xFF252A32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 价格
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '¥${plan.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.vipGold,
                      ),
                    ),
                    if (plan.originalPrice != plan.price)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '¥${plan.originalPrice.toInt()}',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  plan.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),

            const SizedBox(width: AppTheme.spaceLg),

            // 购买按钮
            Expanded(
              child: ElevatedButton(
                onPressed: vipState.isLoading
                    ? null
                    : () async {
                        final success = await ref
                            .read(vipProvider.notifier)
                            .purchaseVip(selectedPlan);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('VIP购买成功！'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.vipGold,
                  foregroundColor: const Color(0xFF1A1D23),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: vipState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF1A1D23)),
                        ),
                      )
                    : const Text(
                        '立即开通',
                        style: TextStyle(
                          fontSize: 16,
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

  /// 获取图标
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'tune':
        return Icons.tune;
      case 'visibility':
        return Icons.visibility;
      case 'stars':
        return Icons.stars;
      case 'done_all':
        return Icons.done_all;
      case 'visibility_off':
        return Icons.visibility_off;
      case 'auto_awesome':
        return Icons.auto_awesome;
      default:
        return Icons.star;
    }
  }
}
