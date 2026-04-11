import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/widgets/widgets.dart';

/// 设计系统展示页面
class DesignShowcasePage extends StatelessWidget {
  const DesignShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('设计系统 - 奶油甜心风'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('色彩系统', _buildColorSystem()),
            _buildSection('按钮组件', _buildButtons()),
            _buildSection('卡片组件', _buildCards()),
            _buildSection('弹窗组件', _buildDialogs(context)),
            _buildSection('字体系统', _buildTypography()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spaceLg),
        content,
        const SizedBox(height: AppTheme.space3Xl),
        const Divider(),
        const SizedBox(height: AppTheme.spaceXl),
      ],
    );
  }

  Widget _buildColorSystem() {
    final colors = [
      ('主色', AppTheme.primary),
      ('主色浅', AppTheme.primaryLight),
      ('主色深', AppTheme.primaryDark),
      ('辅色', AppTheme.secondary),
      ('点缀', AppTheme.accent),
      ('背景', AppTheme.background),
      ('表面', AppTheme.surface),
      ('文字主', AppTheme.textPrimary),
      ('文字次', AppTheme.textSecondary),
      ('成功', AppTheme.success),
      ('错误', AppTheme.error),
      ('VIP金', AppTheme.vipGold),
    ];

    return Wrap(
      spacing: AppTheme.spaceMd,
      runSpacing: AppTheme.spaceMd,
      children: colors.map((color) {
        return Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.$2,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: color.$1.contains('背景') || color.$1.contains('表面')
                    ? Border.all(color: AppTheme.textTertiary)
                    : null,
              ),
            ),
            const SizedBox(height: AppTheme.spaceXs),
            Text(color.$1, style: AppTheme.labelSmall),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        PrimaryButton(
          text: '主要按钮',
          onPressed: () {},
        ),
        const SizedBox(height: AppTheme.spaceMd),
        PrimaryButton(
          text: '带图标',
          icon: Icons.favorite,
          onPressed: () {},
        ),
        const SizedBox(height: AppTheme.spaceMd),
        const PrimaryButton(
          text: '加载中',
          isLoading: true,
        ),
        const SizedBox(height: AppTheme.spaceMd),
        SecondaryButton(
          text: '次要按钮',
          onPressed: () {},
        ),
        const SizedBox(height: AppTheme.spaceMd),
        GhostButton(
          text: '幽灵按钮',
          onPressed: () {},
        ),
        const SizedBox(height: AppTheme.spaceMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIconButton(
              icon: Icons.close,
              onPressed: () {},
            ),
            const SizedBox(width: AppTheme.spaceMd),
            CircleIconButton(
              icon: Icons.favorite,
              backgroundColor: AppTheme.primary,
              iconColor: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spaceMd),
        const Center(child: FabButton()),
      ],
    );
  }

  Widget _buildCards() {
    return Column(
      children: [
        MatchCard(
          name: '小雅',
          age: 21,
          city: '北京',
          matchScore: 8,
          commonHobbies: const ['周杰伦', '《三体》', '原神'],
        ),
        const SizedBox(height: AppTheme.spaceMd),
        const PostCard(
          userName: '小明',
          content: '今天去看了周杰伦的演唱会，太开心了！',
          location: '北京',
          likeCount: 128,
          commentCount: 32,
        ),
        const SizedBox(height: AppTheme.spaceMd),
        Wrap(
          spacing: AppTheme.spaceSm,
          children: [
            const HobbyTag(label: '周杰伦', isSelected: true),
            const HobbyTag(label: '《三体》'),
            const HobbyTag(label: '旅行'),
            HobbyTag(
              label: 'VIP',
              color: AppTheme.vipGold,
              isSelected: true,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spaceMd),
        VipCard(
          tier: '普通VIP',
          price: '￥59/月',
          period: '',
          benefits: const [
            '同好匹配 无限次',
            '同城匹配 50次/天',
            '查看谁喜欢我',
          ],
          onSubscribe: () {},
        ),
        const SizedBox(height: AppTheme.spaceMd),
        VipCard(
          tier: '高级VIP',
          price: '￥99/月',
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
    );
  }

  Widget _buildDialogs(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: '显示VIP提示弹窗',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => VipPromptDialog(
                onUpgradeBasic: () {},
                onUpgradePremium: () {},
              ),
            );
          },
        ),
        const SizedBox(height: AppTheme.spaceMd),
        PrimaryButton(
          text: '显示精准匹配锁定',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const VipPromptDialog(
                isPremiumFeature: true,
              ),
            );
          },
        ),
        const SizedBox(height: AppTheme.spaceMd),
        SecondaryButton(
          text: '显示确认弹窗',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => ConfirmDialog(
                title: '确认删除',
                message: '删除后将无法恢复，确定要删除吗？',
                confirmText: '删除',
                isDanger: true,
                onConfirm: () {},
              ),
            );
          },
        ),
        const SizedBox(height: AppTheme.spaceMd),
        SecondaryButton(
          text: '显示成功弹窗',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const SuccessDialog(
                title: '支付成功',
                message: '您已成功开通VIP会员',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTypography() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: AppTheme.displayLarge),
        Text('Display Medium', style: AppTheme.displayMedium),
        Text('Display Small', style: AppTheme.displaySmall),
        const SizedBox(height: AppTheme.spaceMd),
        Text('Headline Large', style: AppTheme.headlineLarge),
        Text('Headline Medium', style: AppTheme.headlineMedium),
        Text('Headline Small', style: AppTheme.headlineSmall),
        const SizedBox(height: AppTheme.spaceMd),
        Text('Title Large', style: AppTheme.titleLarge),
        Text('Title Medium', style: AppTheme.titleMedium),
        Text('Title Small', style: AppTheme.titleSmall),
        const SizedBox(height: AppTheme.spaceMd),
        Text('Body Large', style: AppTheme.bodyLarge),
        Text('Body Medium', style: AppTheme.bodyMedium),
        Text('Body Small', style: AppTheme.bodySmall),
        const SizedBox(height: AppTheme.spaceMd),
        Text('Label Large', style: AppTheme.labelLarge),
        Text('Label Medium', style: AppTheme.labelMedium),
        Text('Label Small', style: AppTheme.labelSmall),
      ],
    );
  }
}