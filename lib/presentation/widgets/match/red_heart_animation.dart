import 'dart:math';
import 'package:flutter/material.dart';

/// 红心浮动动画组件
class RedHeartAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const RedHeartAnimation({
    super.key,
    this.onComplete,
  });

  @override
  State<RedHeartAnimation> createState() => _RedHeartAnimationState();
}

class _RedHeartAnimationState extends State<RedHeartAnimation>
    with TickerProviderStateMixin {
  late final List<HeartParticle> _particles;
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(12, (index) => HeartParticle.random());
    _controllers = _particles.map((particle) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + particle.delayMillis),
      );
    }).toList();

    // 启动所有动画
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: _particles[i].delayMillis),
        () {
          if (mounted) {
            _controllers[i].forward().then((_) {
              if (i == _controllers.length - 1 && widget.onComplete != null) {
                widget.onComplete!();
              }
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(_particles.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final particle = _particles[index];
            final progress = _controllers[index].value;

            // 计算当前位置
            final currentX = particle.startX +
                particle.driftX * progress;
            final currentY = particle.startY -
                particle.riseDistance * progress;

            // 计算缩放和透明度
            final scale = particle.startScale +
                (particle.endScale - particle.startScale) * progress;
            final opacity = progress < 0.7
                ? 1.0
                : 1.0 - (progress - 0.7) / 0.3;

            return Positioned(
              left: currentX,
              top: currentY,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: scale,
                  child: Icon(
                    Icons.favorite,
                    color: particle.color,
                    size: particle.size,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// 爱心粒子
class HeartParticle {
  final double startX;
  final double startY;
  final double driftX;
  final double riseDistance;
  final double startScale;
  final double endScale;
  final double size;
  final Color color;
  final int delayMillis;

  const HeartParticle({
    required this.startX,
    required this.startY,
    required this.driftX,
    required this.riseDistance,
    required this.startScale,
    required this.endScale,
    required this.size,
    required this.color,
    required this.delayMillis,
  });

  factory HeartParticle.random() {
    final random = Random();
    final colors = [
      const Color(0xFFE91E63),
      const Color(0xFFFF6B9D),
      const Color(0xFFFF1744),
      const Color(0xFFF50057),
      const Color(0xFFD81B60),
      const Color(0xFFEC407A),
    ];

    return HeartParticle(
      startX: random.nextDouble() * 300 - 150 + 150, // 相对中心偏移
      startY: 400 + random.nextDouble() * 100,
      driftX: (random.nextDouble() - 0.5) * 150,
      riseDistance: 200 + random.nextDouble() * 200,
      startScale: 0.5 + random.nextDouble() * 0.5,
      endScale: 0.2 + random.nextDouble() * 0.3,
      size: 20 + random.nextDouble() * 30,
      color: colors[random.nextInt(colors.length)],
      delayMillis: random.nextInt(200),
    );
  }
}

/// 互点红心成功弹窗
class MutualHeartDialog extends StatelessWidget {
  final String userName;
  final VoidCallback? onClose;
  final VoidCallback? onChat;
  final VoidCallback? onDate;

  const MutualHeartDialog({
    super.key,
    required this.userName,
    this.onClose,
    this.onChat,
    this.onDate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2D1F2F),
              Color(0xFF1A1D23),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFE91E63).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 爱心图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE91E63),
                    Color(0xFFFF6B9D),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.4),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            // 标题
            Text(
              '红心互点！',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 描述
            Text(
              '你和 $userName 互相点了红心',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '现在可以发起约会邀请了 💕',
              style: TextStyle(
                color: const Color(0xFFFF6B9D),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // 按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '发起约会',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onChat,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('去聊天'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onClose,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.6),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('继续浏览'),
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
