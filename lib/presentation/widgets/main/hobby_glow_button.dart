import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 爱好库入口发光按钮
/// 旋转多层渐变光环 + 中心"爱好"脉冲文字
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
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 旋转发光环
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
    );
  }

  /// 构建单个脉冲文字
  Widget _buildLetter(String letter, {required double delaySeconds}) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final cycleDuration = 2.0; // 动画周期 2 秒
        final delay = delaySeconds / cycleDuration; // 转换为 0-1 范围
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
                fontSize: widget.size * 0.22,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontFamily,
                height: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }

  /// 计算脉冲透明度
  /// 0%-20%: 0.4 -> 1.0
  /// 20%-40%: 1.0 -> 0.7
  /// 40%-100%: 0.7 -> 0.4
  double _calculateOpacity(double t) {
    if (t < 0.2) {
      return 0.4 + (t / 0.2) * 0.6;
    } else if (t < 0.4) {
      return 1.0 - ((t - 0.2) / 0.2) * 0.3;
    } else {
      return 0.7 - ((t - 0.4) / 0.6) * 0.3;
    }
  }

  /// 计算脉冲缩放
  /// 0%-20%: 1.0 -> 1.15
  /// 20%-40%: 1.15 -> 1.0
  /// 40%-100%: 1.0
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
/// 模拟 CSS inset box-shadow 多层内发光效果
class _GlowRingPainter extends CustomPainter {
  final double progress;

  _GlowRingPainter({required this.progress}) : super(repaint: null);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // 颜色在两种状态之间振荡：0%/100% <-> 50%
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

    // 旋转从 90° 开始，与 CSS 关键帧一致
    final rotation = pi / 2 + progress * 2 * pi;

    canvas.save();

    // 裁剪为圆形，确保发光不溢出按钮边界
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);

    // 旋转画布
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    // 外层发光 - 深蓝/暗蓝，大半径，远偏移
    _drawGlowCircle(
      canvas,
      center: center,
      radius: radius * 0.9,
      color: outerColor,
      intensity: 0.35,
      offset: const Offset(0, 18),
      spread: 0.85,
    );

    // 中层发光 - 紫/品红，中半径，中偏移
    _drawGlowCircle(
      canvas,
      center: center,
      radius: radius * 0.75,
      color: midColor,
      intensity: 0.3,
      offset: const Offset(0, 10),
      spread: 0.75,
    );

    // 内层发光 - 白色，小半径，近偏移
    _drawGlowCircle(
      canvas,
      center: center,
      radius: radius * 0.55,
      color: Colors.white,
      intensity: 0.25,
      offset: const Offset(0, 4),
      spread: 0.6,
    );

    canvas.restore();

    //  subtle 白色边框，增强轮廓感
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius - 0.5, borderPaint);
  }

  /// 绘制单个发光圆
  /// 使用径向渐变模拟 CSS 的 inset box-shadow
  void _drawGlowCircle(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double intensity,
    required Offset offset,
    required double spread,
  }) {
    final glowCenter = center + offset;

    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          color.withOpacity(intensity),
          color.withOpacity(intensity * 0.6),
          Colors.transparent,
        ],
        stops: [0.0, spread * 0.5, spread],
      ).createShader(
        Rect.fromCircle(center: glowCenter, radius: radius),
      );

    canvas.drawCircle(glowCenter, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _GlowRingPainter oldDelegate) => true;
}
