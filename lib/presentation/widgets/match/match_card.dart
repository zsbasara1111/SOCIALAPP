import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../providers/match_provider.dart';

/// 匹配卡片组件 - Mindate 全屏照片风格
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
  double _dragOffset = 0;
  double _rotation = 0;
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final progress = (_dragOffset / 150).clamp(-1.0, 1.0);
    final showAction = progress.abs() > 0.1;
    final isLike = progress > 0;

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
      // 支持点击左右切换照片
      onTapUp: (details) {
        final width = context.size?.width ?? 0;
        if (widget.user.photoUrls.length > 1) {
          if (details.localPosition.dx < width / 2) {
            setState(() {
              _currentPhotoIndex = (_currentPhotoIndex - 1 + widget.user.photoUrls.length)
                  % widget.user.photoUrls.length;
            });
          } else {
            setState(() {
              _currentPhotoIndex = (_currentPhotoIndex + 1) % widget.user.photoUrls.length;
            });
          }
        }
      },
      child: AnimatedContainer(
        duration: _dragOffset == 0 ? const Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(_dragOffset, _dragOffset.abs() * 0.1)
          ..rotateZ(_rotation),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: AppTheme.shadowLg,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 全屏照片
              _buildPhotoArea(),

              // 滑动遮罩（喜欢/不喜欢颜色提示）
              if (showAction)
                Container(
                  color: isLike
                      ? const Color(0xFF4ADE80).withOpacity(progress.abs() * 0.3)
                      : const Color(0xFFFF6B6B).withOpacity(progress.abs() * 0.3),
                ),

              // 滑动图标提示
              if (showAction)
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: progress.abs().clamp(0.0, 1.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isLike ? const Color(0xFF4ADE80) : const Color(0xFFFF6B6B))
                                .withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        isLike ? Icons.favorite : Icons.close,
                        color: isLike ? const Color(0xFF4ADE80) : const Color(0xFFFF6B6B),
                        size: 40,
                      ),
                    ),
                  ),
                ),

              // 底部渐变遮罩
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
              ),

              // 照片指示器（顶部）
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
                            color: index == _currentPhotoIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 信息叠加层（底部）
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 匹配值徽章（预留位置，可后续接入真实数据）
                      // const SizedBox(height: AppTheme.spaceMd),

                      // 姓名和年龄
                      Row(
                        children: [
                          Text(
                            widget.user.nickname,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamilyDisplay,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (widget.user.age != null) ...[
                            const SizedBox(width: AppTheme.spaceSm),
                            Text(
                              '${widget.user.age}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: AppTheme.spaceXs),

                      // 城市
                      if (widget.user.city != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.user.city!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
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

                      // 爱好标签
                      _buildHobbyTags(),
                    ],
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
    if (widget.user.photoUrls.isEmpty) {
      if (widget.user.avatarUrl != null) {
        return AppImage(
          imagePath: widget.user.avatarUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPhotoPlaceholder(),
        );
      }
      return _buildPhotoPlaceholder();
    }

    return AppImage(
      imagePath: widget.user.photoUrls[_currentPhotoIndex],
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
          child: const Icon(
            Icons.image_not_supported,
            color: AppTheme.textTertiary,
          ),
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

    final displayHobbies = widget.user.hobbies.take(3).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayHobbies.map((hobby) {
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
