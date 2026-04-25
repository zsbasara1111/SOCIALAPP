import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/match_provider.dart';

/// 匹配卡片组件
class MatchCard extends StatefulWidget {
  final MatchUser user;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final void Function(double progress)? onSwipeProgress;

  const MatchCard({
    super.key,
    required this.user,
    this.onLike,
    this.onDislike,
    this.onSwipeProgress,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  // 拖拽偏移量
  double _dragOffset = 0;
  // 卡片旋转角度
  double _rotation = 0;

  @override
  Widget build(BuildContext context) {
    // 计算滑动进度，限制在 -1 到 1 之间
    final progress = (_dragOffset / 150).clamp(-1.0, 1.0);
    // 是否显示动作指示器
    final showAction = progress.abs() > 0.1;
    // 动作图标和颜色
    final isLike = progress > 0;
    final actionColor = isLike ? const Color(0xFFEF4444) : const Color(0xFFEF4444);
    final actionIcon = isLike ? Icons.favorite : Icons.close;

    return GestureDetector(
      onHorizontalDragStart: (_) {
        setState(() {
          _dragOffset = 0;
          _rotation = 0;
        });
        widget.onSwipeProgress?.call(0);
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
          _rotation = _dragOffset * 0.001;
        });
        widget.onSwipeProgress?.call((_dragOffset / 150).clamp(-1.0, 1.0));
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        // 如果滑动距离或速度足够大，触发动作
        if (_dragOffset > 80 || velocity > 200) {
          widget.onLike?.call();
        } else if (_dragOffset < -80 || velocity < -200) {
          widget.onDislike?.call();
        }
        setState(() {
          _dragOffset = 0;
          _rotation = 0;
        });
        widget.onSwipeProgress?.call(0);
      },
      child: AnimatedContainer(
        duration: _dragOffset == 0 ? const Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(_dragOffset, _dragOffset.abs() * 0.1)
          ..rotateZ(_rotation),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: AppTheme.shadowMd,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Stack(
            children: [
              // 照片区域
              _buildPhotoArea(),

              // 滑动遮罩
              if (showAction)
                Container(
                  color: actionColor.withOpacity(progress.abs() * 0.35),
                ),

              // 渐变遮罩
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // 动作指示器（中间大图标）
              if (showAction)
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: progress.abs().clamp(0.0, 1.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: actionColor.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        actionIcon,
                        color: actionColor,
                        size: 50,
                      ),
                    ),
                  ),
                ),

              // 信息区域
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户名和基本信息
                      Row(
                        children: [
                          Text(
                            widget.user.nickname,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamilyDisplay,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (widget.user.age != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${widget.user.age}岁',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          // 在线状态
                          if (widget.user.isOnline)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: AppTheme.spaceSm),

                      // 城市
                      if (widget.user.city != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.user.city!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: AppTheme.spaceMd),

                      // 个人简介
                      if (widget.user.bio != null)
                        Text(
                          widget.user.bio!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      const SizedBox(height: AppTheme.spaceMd),

                      // 爱好标签（简化版）
                      _buildHobbyTags(),
                    ],
                  ),
                ),
              ),

              // 照片指示器
              if (widget.user.photoUrls.length > 1)
                Positioned(
                  top: AppTheme.spaceLg,
                  left: AppTheme.spaceLg,
                  right: AppTheme.spaceLg,
                  child: Row(
                    children: List.generate(
                      widget.user.photoUrls.length,
                      (index) => Expanded(
                        child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建照片区域
  Widget _buildPhotoArea() {
    // 如果没有照片但有头像，显示头像
    if (widget.user.photoUrls.isEmpty) {
      if (widget.user.avatarUrl != null) {
        return Image.network(
          widget.user.avatarUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPhotoPlaceholder(),
        );
      }
      return _buildPhotoPlaceholder();
    }

    // 有照片时显示照片
    return PageView.builder(
      itemCount: widget.user.photoUrls.length,
      itemBuilder: (context, index) {
        return Image.network(
          widget.user.photoUrls[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppTheme.surfaceVariant,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.surfaceVariant,
              child: Icon(
                Icons.image_not_supported,
                color: AppTheme.textTertiary,
              ),
            );
          },
        );
      },
    );
  }

  /// 构建照片占位图
  Widget _buildPhotoPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.surfaceVariant,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: AppTheme.primary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建爱好标签
  Widget _buildHobbyTags() {
    if (widget.user.hobbies.isEmpty) {
      return const SizedBox.shrink();
    }

    // 只显示前3个爱好
    final displayHobbies = widget.user.hobbies.take(3).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayHobbies.map((hobby) {
        // 获取分类颜色（这里简化处理）
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            hobby.itemName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
