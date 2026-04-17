import 'dart:math';
import 'package:flutter/material.dart';

/// 爱心特效覆盖层
/// 当聊天双方红心互点达5分钟时播放
class HeartBurstOverlay extends StatefulWidget {
  final VoidCallback? onComplete;

  const HeartBurstOverlay({
    super.key,
    this.onComplete,
  });

  @override
  State<HeartBurstOverlay> createState() => _HeartBurstOverlayState();
}

class _HeartBurstOverlayState extends State<HeartBurstOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: Colors.pink.withOpacity(
            0.1 * (1 - _controller.value).clamp(0, 1),
          ),
          child: Stack(
            children: [
              // 中央大爱心
              Center(
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0, end: 2.5).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0, 0.4, curve: Curves.elasticOut),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF6B9D),
                      size: 120,
                    ),
                  ),
                ),
              ),
              // 环绕小爱心
              for (int i = 0; i < 12; i++) _buildFloatingHeart(i),
              // 提示文字
              Center(
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 160),
                      child: Text(
                        '互相抱有好感！',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF6B9D),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingHeart(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = index * (2 * pi / 12);
        final delay = index * 0.03;
        final duration = 0.5;

        var t = (_controller.value - delay) / duration;
        t = t.clamp(0.0, 1.0);
        final eased = Curves.easeOut.transform(t);

        final size = MediaQuery.of(context).size;
        final centerX = size.width / 2;
        final centerY = size.height / 2;
        final distance = 180.0;

        final offsetX = eased * distance * cos(angle);
        final offsetY = eased * distance * sin(angle) - eased * 120;
        final opacity = (1 - eased).clamp(0.0, 1.0);

        final heartSize = 20 + (index % 3) * 8.0;
        final colors = const [
          Color(0xFFFF6B9D),
          Color(0xFFFF8E53),
          Color(0xFFE91E63),
          Color(0xFFFF4081),
        ];

        return Positioned(
          left: centerX + offsetX - heartSize / 2,
          top: centerY + offsetY - heartSize / 2,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.favorite,
              color: colors[index % colors.length],
              size: heartSize,
            ),
          ),
        );
      },
    );
  }
}
