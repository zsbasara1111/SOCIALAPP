import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/widgets.dart';

/// VIP中心页面
class VipCenterPage extends StatelessWidget {
  const VipCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('VIP中心'),
        backgroundColor: AppTheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          children: [
            // 普通VIP
            VipCard(
              tier: '普通VIP',
              price: '¥59/月',
              period: '',
              benefits: const [
                '同好匹配 无限次',
                '同城匹配 50次/天',
                '查看谁喜欢我',
              ],
              onSubscribe: () {},
            ),
            const SizedBox(height: AppTheme.spaceLg),
            // 高级VIP
            VipCard(
              tier: '高级VIP',
              price: '¥99/月',
              period: '',
              benefits: const [
                '包含普通VIP全部功能',
                '解锁【精准匹配】功能',
                '优先客服支持',
              ],
              isPopular: true,
              onSubscribe: () {},
            ),
          ],
        ),
      ),
    );
  }
}
