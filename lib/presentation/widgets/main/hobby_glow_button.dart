import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 爱好库入口发光按钮
/// 精确模拟 CSS box-shadow: inset 多层内发光旋转效果
/// 参考：https://uiverse.io/dexter-st/bright-lizard-8
class HobbyGlowButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;

  const HobbyGlowButton({
    super.key,
    this.onTap,
    this.size = 64,
  });

  @override
  State<HobbyGlowButton> createState() => _HobbyGlowButtonState();
}

class _HobbyGlowButtonState extends State<HobbyGlowButton>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipOval(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 旋转发光层
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _GlowRingPainter(
                      progress: _rotationController.value,
                    ),
                  );
                },
              ),
              // 中心文字"爱好"，带脉冲动画
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLetter('爱', delaySeconds: 0),
                  _buildLetter('好', delaySeconds: 0.3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建单个脉冲文字
  Widget _buildLetter(String letter, {required double delaySeconds}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final delay = delaySeconds / 2.0;
        var t = (_pulseController.value + delay) % 1.0;

        final opacity = _calculateOpacity(t);
        final scale = _calculateScale(t);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.size * 0.23,
                fontWeight: FontWeight.w600,
                fontFamily: AppTheme.fontFamily,
                height: 1.0,
                letterSpacing: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  /// 计算脉冲透明度：0%->20% 淡入，20%->40% 淡出，40%->100% 保持
  double _calculateOpacity(double t) {
    if (t < 0.2) {
      return 0.4 + (t / 0.2) * 0.6;
    } else if (t < 0.4) {
      return 1.0 - ((t - 0.2) / 0.2) * 0.3;
    } else {
      return 0.7 - ((t - 0.4) / 0.6) * 0.3;
    }
  }

  /// 计算脉冲缩放：0%->20% 放大到 1.15，20%->40% 缩回 1.0
  double _calculateScale(double t) {
    if (t < 0.2) {
      return 1.0 + (t / 0.2) * 0.15;
    } else if (t < 0.4) {
      return 1.15 - ((t - 0.2) / 0.2) * 0.15;
    } else {
      return 1.0;
    }
  }
}

/// 发光环绘制器
///
/// 核心原理：CSS box-shadow: inset 是在元素内边缘产生向内扩散的阴影。
/// 要模拟这个效果，必须把 RadialGradient 的中心放在圆的下方外部，
/// 这样圆底部靠近 gradient 中心（最亮），向上逐渐 fade，
/// 正好还原"内阴影从底部边缘向内扩散"的视觉效果。
class _GlowRingPainter extends CustomPainter {
  final double progress;

  _GlowRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // 颜色在两种状态之间平滑振荡
    final colorT = sin(progress * 2 * pi) * 0.5 + 0.5;

    final midColor = Color.lerp(
      const Color(0xFFad5fff),
      const Color(0xFFd60a47),
      colorT,
    )!;
    final outerColor = Color.lerp(
      const Color(0xFF471eec),
      const Color(0xFF311e80),
      colorT,
    )!;

    // CSS 动画从 rotate(90deg) 开始
    final rotation = pi / 2 + progress * 2 * pi;

    // 1. 先画深色圆底，让发光在白色背景上足够明显
    final bgPaint = Paint()..color = const Color(0xFF0D0D1A);
    canvas.drawCircle(center, radius, bgPaint);

    canvas.save();

    // 2. 旋转画布（不 clip，让发光层自由旋转）
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 3. 外层发光 - 深蓝/暗蓝
    // CSS: 0 60px 60px 0 #471eec inset
    // offset=60, blur=60。在 radius=90 的圆上，offset 比例 0.67。
    // gradient 中心放在圆下方 1.5r 处，半径 2.2r，确保圆底部最亮、向上 fade。
    final outerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 1.5),
        radius: 2.2,
        colors: [
          outerColor.withOpacity(0.85),
          outerColor.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, outerPaint);

    // 4. 中层发光 - 紫/品红
    // CSS: 0 20px 30px 0 #ad5fff inset
    // offset=20, blur=30。offset 比例 0.22。
    final midPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 1.2),
        radius: 1.8,
        colors: [
          midColor.withOpacity(0.8),
          midColor.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, midPaint);

    // 5. 内层发光 - 白色
    // CSS: 0 10px 20px 0 #fff inset
    // offset=10, blur=20。offset 比例 0.11。
    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, 1.05),
        radius: 1.5,
        colors: [
          Colors.white.withOpacity(0.75),
          Colors.white.withOpacity(0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, innerPaint);

    canvas.restore();

    // 6. subtle 白色边框，增强圆形轮廓
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius - 0.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowRingPainter oldDelegate) => true;
}
