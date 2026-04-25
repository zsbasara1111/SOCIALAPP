import 'dart:math';
import 'package:flutter/material.dart';

/// 星球轨道动态按钮
/// 中心星球 + 三条轨道 + 三个小元素（书、音符、游戏手柄）持续不规则转动
class PlanetOrbitButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;

  const PlanetOrbitButton({
    super.key,
    this.onTap,
    this.size = 56,
  });

  @override
  State<PlanetOrbitButton> createState() => _PlanetOrbitButtonState();
}

class _PlanetOrbitButtonState extends State<PlanetOrbitButton>
    with TickerProviderStateMixin {
  late final AnimationController _planetController;
  late final AnimationController _orbit1Controller;
  late final AnimationController _orbit2Controller;
  late final AnimationController _orbit3Controller;

  @override
  void initState() {
    super.initState();
    _planetController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _orbit1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _orbit2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _orbit3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _planetController.dispose();
    _orbit1Controller.dispose();
    _orbit2Controller.dispose();
    _orbit3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF7AB8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _PlanetOrbitPainter(
            planetRotation: _planetController,
            orbit1Angle: _orbit1Controller,
            orbit2Angle: _orbit2Controller,
            orbit3Angle: _orbit3Controller,
          ),
        ),
      ),
    );
  }
}

/// 星球轨道绘制器
class _PlanetOrbitPainter extends CustomPainter {
  final Animation<double> planetRotation;
  final Animation<double> orbit1Angle;
  final Animation<double> orbit2Angle;
  final Animation<double> orbit3Angle;

  _PlanetOrbitPainter({
    required this.planetRotation,
    required this.orbit1Angle,
    required this.orbit2Angle,
    required this.orbit3Angle,
  }) : super(
          repaint: Listenable.merge([
            planetRotation,
            orbit1Angle,
            orbit2Angle,
            orbit3Angle,
          ]),
        );

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final scale = size.width / 56;

    // 轨道配置：半径、颜色、元素
    final orbits = [
      _OrbitConfig(
        radius: 14 * scale,
        dashLength: 3 * scale,
        gapLength: 4 * scale,
        color: Colors.white.withOpacity(0.35),
        angle: orbit1Angle.value * 2 * pi,
        emoji: '📖',
        emojiSize: 8 * scale,
        dotRadius: 6 * scale,
      ),
      _OrbitConfig(
        radius: 20 * scale,
        dashLength: 3 * scale,
        gapLength: 5 * scale,
        color: Colors.white.withOpacity(0.25),
        angle: orbit2Angle.value * 2 * pi,
        emoji: '🎮',
        emojiSize: 8 * scale,
        dotRadius: 6 * scale,
      ),
      _OrbitConfig(
        radius: 26 * scale,
        dashLength: 2 * scale,
        gapLength: 6 * scale,
        color: Colors.white.withOpacity(0.2),
        angle: orbit3Angle.value * 2 * pi,
        emoji: '🎵',
        emojiSize: 8 * scale,
        dotRadius: 6 * scale,
      ),
    ];

    // 绘制轨道
    for (final orbit in orbits) {
      _drawDashedOrbit(canvas, center, orbit);
    }

    // 绘制中心星球
    _drawPlanet(canvas, center, 12 * scale);

    // 绘制轨道上的小元素（按从外到内顺序，避免遮挡）
    for (final orbit in orbits.reversed) {
      _drawOrbitingElement(canvas, center, orbit);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  /// 绘制虚线轨道
  void _drawDashedOrbit(Canvas canvas, Offset center, _OrbitConfig orbit) {
    final paint = Paint()
      ..color = orbit.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final circumference = 2 * pi * orbit.radius;
    final totalDashLength = orbit.dashLength + orbit.gapLength;
    final dashCount = (circumference / totalDashLength).floor();

    final path = Path();
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * totalDashLength / circumference) * 2 * pi;
      final sweepAngle = (orbit.dashLength / circumference) * 2 * pi;
      final rect = Rect.fromCircle(center: center, radius: orbit.radius);
      path.addArc(rect, startAngle, sweepAngle);
    }

    canvas.drawPath(path, paint);
  }

  /// 绘制中心星球
  void _drawPlanet(Canvas canvas, Offset center, double radius) {
    // 星球底色（蓝色系）
    final planetPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD6E8FF),
          const Color(0xFF88B8F0),
        ],
        stops: const [0.2, 1.0],
        center: Alignment(
          cos(planetRotation.value * 2 * pi) * 0.3,
          sin(planetRotation.value * 2 * pi) * 0.3,
        ),
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, planetPaint);

    // 星球高光
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      center - Offset(radius * 0.3, radius * 0.3),
      radius * 0.35,
      highlightPaint,
    );

    // 星球轮廓
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, borderPaint);
  }

  /// 绘制轨道上的小元素
  void _drawOrbitingElement(Canvas canvas, Offset center, _OrbitConfig orbit) {
    final x = center.dx + orbit.radius * cos(orbit.angle);
    final y = center.dy + orbit.radius * sin(orbit.angle);
    final pos = Offset(x, y);

    // 元素背景圆
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, orbit.dotRadius, dotPaint);

    // 元素边框
    final borderPaint = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(pos, orbit.dotRadius, borderPaint);

    // 绘制 emoji
    final textPainter = TextPainter(
      text: TextSpan(
        text: orbit.emoji,
        style: TextStyle(fontSize: orbit.emojiSize),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      pos - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

}

/// 轨道配置
class _OrbitConfig {
  final double radius;
  final double dashLength;
  final double gapLength;
  final Color color;
  final double angle;
  final String emoji;
  final double emojiSize;
  final double dotRadius;

  _OrbitConfig({
    required this.radius,
    required this.dashLength,
    required this.gapLength,
    required this.color,
    required this.angle,
    required this.emoji,
    required this.emojiSize,
    required this.dotRadius,
  });
}
