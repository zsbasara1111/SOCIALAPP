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

/// 匹配页面 - 首页
class MatchPage extends ConsumerStatefulWidget {
  const MatchPage({super.key});

  @override
  ConsumerState<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends ConsumerState<MatchPage> {
  // 当前卡片滑动进度，-1 表示左滑（不喜欢），1 表示右滑（喜欢）
  double _swipeProgress = 0;

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
              Navigator.of(context).pop();
              ref.read(matchProvider.notifier).clearMatch();
            },
            onChat: () {
              Navigator.of(context).pop();
              ref.read(matchProvider.notifier).clearMatch();
              context.go(RoutePaths.chat);
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
                            ? MatchCard(
                                user: currentUser,
                                onDislike: () {
                                  ref.read(matchProvider.notifier).dislikeUser(currentUser.id);
                                },
                                onLike: () {
                                  ref.read(matchProvider.notifier).likeUser(currentUser.id);
                                },
                                onSwipeProgress: (progress) {
                                  setState(() {
                                    _swipeProgress = progress;
                                  });
                                },
                              )
                            : _buildEmptyCard(),
                  ),
                ),

                // 底部操作按钮
                if (!matchState.isLoading && currentUser != null)
                  _buildActionButtons(context, currentUser.id),
              ],
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
            isHighlighted: _swipeProgress < 0,
            onTap: () {
              ref.read(matchProvider.notifier).dislikeUser(userId);
            },
          ),

          const SizedBox(width: AppTheme.spaceXl),

          // 喜欢按钮
          _buildActionButton(
            icon: Icons.favorite,
            color: const Color(0xFFEF4444),
            isHighlighted: _swipeProgress > 0,
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
    bool isHighlighted = false,
    double size = 64,
  }) {
    final scale = isHighlighted ? 1.15 : 1.0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: size * scale,
        height: size * scale,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isHighlighted ? 0.6 : 0.3),
              blurRadius: isHighlighted ? 20 : 12,
              spreadRadius: isHighlighted ? 4 : 0,
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
