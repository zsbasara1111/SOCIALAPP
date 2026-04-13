import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../providers/match_provider.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/match/match_mode_selector.dart';
import '../../widgets/match/match_card.dart';
import '../../widgets/match/match_success_dialog.dart';
import '../../widgets/match/match_quota_indicator.dart';
import '../../widgets/match/red_heart_animation.dart';
import '../../providers/red_heart_provider.dart';

/// 匹配页面 - 首页
class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({super.key});

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  bool _showHeartAnimation = false;
  bool _showMutualDialog = false;
  String? _mutualUserName;

  @override
  void initState() {
    super.initState();
    // 初始加载用户
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchProvider.notifier).loadNextUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final currentUser = matchState.currentUser;

    // 监听匹配成功
    if (matchState.isMatch && matchState.matchedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MatchSuccessDialog(
            matchedUser: matchState.matchedUser!,
            onClose: () {
              ref.read(matchProvider.notifier).clearMatch();
            },
            onChat: () {
              ref.read(matchProvider.notifier).clearMatch();
              context.go(RoutePaths.chat);
            },
          ),
        );
      });
    }

    // 监听互点弹窗
    if (_showMutualDialog && _mutualUserName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MutualHeartDialog(
            userName: _mutualUserName!,
            onClose: () {
              setState(() {
                _showMutualDialog = false;
                _mutualUserName = null;
              });
              Navigator.of(context).pop();
            },
            onChat: () {
              setState(() {
                _showMutualDialog = false;
                _mutualUserName = null;
              });
              Navigator.of(context).pop();
              context.go(RoutePaths.chat);
            },
            onDate: () {
              setState(() {
                _showMutualDialog = false;
                _mutualUserName = null;
              });
              Navigator.of(context).pop();
              _showDateInvitationSheet(context, currentUser!);
            },
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 顶部导航
                _buildAppBar(context, matchState),

                // 匹配模式选择器
                const MatchModeSelector(),

                const SizedBox(height: AppTheme.spaceMd),

                // 匹配次数指示器
                const MatchQuotaIndicator(),

                // 匹配卡片区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceLg,
                      vertical: AppTheme.spaceMd,
                    ),
                    child: matchState.isLoading
                        ? _buildLoadingCard()
                        : currentUser != null
                            ? MatchCard(user: currentUser)
                            : _buildEmptyCard(),
                  ),
                ),

                // 底部操作按钮
                if (!matchState.isLoading && currentUser != null)
                  _buildActionButtons(context, currentUser.id),
              ],
            ),

            // 红心动画层
            if (_showHeartAnimation)
              RedHeartAnimation(
                onComplete: () {
                  setState(() {
                    _showHeartAnimation = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  /// 构建顶部导航
  Widget _buildAppBar(BuildContext context, MatchState matchState) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 标题
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceXs),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Text(
                '发现',
                style: AppTheme.headlineSmall.copyWith(
                  fontFamily: AppTheme.fontFamilyDisplay,
                ),
              ),
            ],
          ),

          // 筛选按钮（仅在精准模式显示）
          if (matchState.currentMode == MatchMode.precise)
            IconButton(
              onPressed: () {
                _showPreciseFilterSheet(context);
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  Icons.tune,
                  color: AppTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 构建加载中的卡片
  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowMd,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppTheme.primary),
        ),
      ),
    );
  }

  /// 构建空状态卡片
  Widget _buildEmptyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        boxShadow: AppTheme.shadowMd,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Text(
              '暂时没有更多用户',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSm),
            Text(
              '稍后再来看看吧',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context, String userId) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 不喜欢按钮
          _buildActionButton(
            icon: Icons.close,
            color: const Color(0xFFEF4444),
            onTap: () {
              ref.read(matchProvider.notifier).dislikeUser(userId);
            },
          ),

          const SizedBox(width: AppTheme.spaceXl),

          // 红心约会按钮
          _buildRedHeartButton(context, userId),

          const SizedBox(width: AppTheme.spaceXl),

          // 喜欢按钮
          _buildActionButton(
            icon: Icons.favorite,
            color: const Color(0xFF10B981),
            onTap: () {
              ref.read(matchProvider.notifier).likeUser(userId);
            },
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 64,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: size * 0.4,
        ),
      ),
    );
  }

  /// 构建红心按钮
  Widget _buildRedHeartButton(BuildContext context, String userId) {
    final hasSent = ref.watch(hasSentHeartProvider(userId));
    final isMutual = ref.watch(isMutualHeartProvider(userId));

    return GestureDetector(
      onTap: hasSent || isMutual
          ? null
          : () async {
              _showRedHeartAnimation(context, userId);
            },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isMutual
              ? const Color(0xFFFFD700)
              : (hasSent
                  ? const Color(0xFFF5F5F5)
                  : Colors.white),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isMutual
                      ? const Color(0xFFFFD700)
                      : const Color(0xFFE91E63))
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          isMutual ? Icons.favorite : Icons.favorite,
          color: isMutual
              ? const Color(0xFFE91E63)
              : (hasSent
                  ? const Color(0xFFBDBDBD)
                  : const Color(0xFFE91E63)),
          size: 28,
        ),
      ),
    );
  }

  /// 显示红心动画并发送红心
  Future<void> _showRedHeartAnimation(BuildContext context, String userId) async {
    final currentUser = ref.read(matchProvider).currentUser;
    if (currentUser == null) return;

    setState(() {
      _showHeartAnimation = true;
    });

    // 发送红心
    final isMutual = await ref.read(redHeartProvider.notifier).sendRedHeart(userId);

    if (mounted) {
      if (isMutual) {
        setState(() {
          _mutualUserName = currentUser.nickname;
          _showMutualDialog = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('已发送红心'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  /// 显示约会邀请底部弹窗
  void _showDateInvitationSheet(BuildContext context, MatchUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DateInvitationSheet(user: user),
    );
  }

  /// 显示精准筛选底部弹窗
  void _showPreciseFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PreciseFilterSheet(),
    );
  }
}

/// 约会邀请弹窗
class _DateInvitationSheet extends ConsumerStatefulWidget {
  final MatchUser user;

  const _DateInvitationSheet({required this.user});

  @override
  ConsumerState<_DateInvitationSheet> createState() => _DateInvitationSheetState();
}

class _DateInvitationSheetState extends ConsumerState<_DateInvitationSheet> {
  String? selectedTemplate;
  bool isSending = false;

  final List<Map<String, String>> _templates = [
    {
      'title': '一起喝咖啡',
      'desc': '找个安静的咖啡馆，聊聊彼此的兴趣爱好',
    },
    {
      'title': '看展/演出',
      'desc': '一起去美术馆或看一场演出，共享艺术时光',
    },
    {
      'title': '户外散步',
      'desc': '在公园里走走，享受阳光和自然',
    },
    {
      'title': '美食探索',
      'desc': '一起去尝试一家新餐厅，分享美食体验',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 拖动指示器
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // 标题
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE91E63),
                      Color(0xFFFF6B9D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Text(
                  '向 ${widget.user.nickname} 发起约会',
                  style: AppTheme.headlineSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spaceMd),

          Text(
            '选择一个约会场景，开启你们的第一次线下见面',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),

          const SizedBox(height: AppTheme.spaceXl),

          // 约会模板列表
          ..._templates.map((template) {
            final isSelected = selectedTemplate == template['title'];
            return GestureDetector(
              onTap: isSending
                  ? null
                  : () {
                      setState(() {
                        selectedTemplate = template['title'];
                      });
                    },
              child: Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE91E63).withOpacity(0.1)
                      : AppTheme.background,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFE91E63)
                        : AppTheme.surfaceVariant,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template['title']!,
                            style: AppTheme.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFFE91E63)
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            template['desc']!,
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE91E63)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE91E63)
                              : AppTheme.surfaceVariant,
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
          }),

          const SizedBox(height: AppTheme.spaceLg),

          // 发送按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedTemplate == null || isSending
                  ? null
                  : () async {
                      setState(() {
                        isSending = true;
                      });

                      // 标记已发送约会邀请
                      await Future.delayed(const Duration(seconds: 1));
                      ref
                          .read(redHeartProvider.notifier)
                          .markDateInvitationSent(widget.user.id);

                      if (mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '已向 ${widget.user.nickname} 发送约会邀请：$selectedTemplate',
                            ),
                            backgroundColor: const Color(0xFFE91E63),
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                disabledBackgroundColor:
                    const Color(0xFFE91E63).withOpacity(0.3),
              ),
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text(
                      '发送邀请',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 精准筛选弹窗
class PreciseFilterSheet extends ConsumerStatefulWidget {
  const PreciseFilterSheet({super.key});

  @override
  ConsumerState<PreciseFilterSheet> createState() => _PreciseFilterSheetState();
}

class _PreciseFilterSheetState extends ConsumerState<PreciseFilterSheet> {
  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final filter = matchState.preciseFilter;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 拖动指示器
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // 标题
          Text(
            '精准筛选',
            style: AppTheme.headlineSmall,
          ),

          const SizedBox(height: AppTheme.spaceXl),

          // 年龄段
          Text(
            '年龄范围',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spaceMd),
          RangeSlider(
            values: RangeValues(
              (filter.minAge ?? 18).toDouble(),
              (filter.maxAge ?? 35).toDouble(),
            ),
            min: 18,
            max: 60,
            divisions: 42,
            labels: RangeLabels(
              '${filter.minAge ?? 18}岁',
              '${filter.maxAge ?? 35}岁',
            ),
            onChanged: (values) {
              ref.read(matchProvider.notifier).setPreciseFilter(
                filter.copyWith(
                  minAge: values.start.round(),
                  maxAge: values.end.round(),
                ),
              );
            },
          ),

          const SizedBox(height: AppTheme.spaceLg),

          // 城市选择
          Text(
            '城市',
            style: AppTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Wrap(
            spacing: AppTheme.spaceSm,
            runSpacing: AppTheme.spaceSm,
            children: ['北京', '上海', '广州', '深圳', '杭州', '成都'].map((city) {
              final isSelected = filter.city == city;
              return ChoiceChip(
                label: Text(city),
                selected: isSelected,
                onSelected: (selected) {
                  ref.read(matchProvider.notifier).setPreciseFilter(
                    filter.copyWith(city: selected ? city : null),
                  );
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppTheme.spaceXl),

          // 应用按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(matchProvider.notifier).loadNextUser();
              },
              child: const Text('应用筛选'),
            ),
          ),
        ],
      ),
    );
  }
}
