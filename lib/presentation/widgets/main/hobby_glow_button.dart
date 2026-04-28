import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// 爱好库入口按钮 —— 粒子玻璃球效果
/// 参考：https://uiverse.io/adamgiebl/dull-kangaroo-63
///
/// 视觉构成：
/// 1. 圆形按钮，蓝白径向渐变背景
/// 2. 外层青色发光阴影
/// 3. 内部 12 个彩色模糊圆点以不同轨迹飘动（7s 周期）
/// 4. 内层上下边缘 inset 高光
/// 5. 中心"爱好"文字
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // CSS: --duration: 7s
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          // 背景径向渐变：#15d2ff -> #72faff（80% 位置）
          gradient: RadialGradient(
            colors: [Color(0xFF15d2ff), Color(0xFF72faff)],
            stops: [0.0, 0.8],
          ),
          // 外层发光阴影：0 0 14px rgba(87, 223, 255, .5)
          boxShadow: [
            BoxShadow(
              color: Color(0x8057dfff),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        // ClipOval 确保内部粒子超出圆形边界时被裁剪
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 粒子层（下层）
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _ParticlePainter(
                      progress: _controller.value,
                    ),
                  );
                },
              ),
              // inset 阴影层（中层，覆盖在粒子上方）
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: const _InsetShadowPainter(),
              ),
              // 文字层（最上层）
              Text(
                '爱好',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 0.22,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTheme.fontFamily,
                  letterSpacing: 0.5,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 粒子数据
class _ParticleData {
  final Color color;
  final double blur;
  final List<Offset> positions;

  const _ParticleData({
    required this.color,
    required this.blur,
    required this.positions,
  });
}

/// 粒子绘制器
/// 12 个彩色模糊圆点，每个在 3 个位置之间循环移动
class _ParticlePainter extends CustomPainter {
  final double progress;

  _ParticlePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    // CSS 圆点大小 40x40px，在 64px 按钮上按比例约 20px 直径 = 10px 半径
    final dotRadius = size.width * 0.16;

    // 12 个圆点定义，按 CSS 分组：
    // 青色(1,9,10)、绿色(3,4)、粉色(5,6)、蓝色(2,7,8,11,12)
    const particles = [
      // === 青色组 ===
      _ParticleData(
        color: Color(0xB31ae8ff), // rgba(26, 232, 255, .7)
        blur: 4,
        positions: [
          Offset(-20, -24), // 0%
          Offset(-20, -4),  // 33%
          Offset(-8, 16),   // 66%
        ],
      ),
      _ParticleData(
        color: Color(0xB31ae8ff),
        blur: 4,
        positions: [
          Offset(-12, -16),
          Offset(-12, -16), // 33% 与 0% 相同，前 1/3 不动
          Offset(4, -12),
        ],
      ),
      _ParticleData(
        color: Color(0xB31ae8ff),
        blur: 4,
        positions: [
          Offset(8, 8),
          Offset(4, -4),
          Offset(16, 4),
        ],
      ),
      // === 绿色组 ===
      _ParticleData(
        color: Color(0xB31aff1a), // #1aff1a
        blur: 7, // CSS: blur 14px
        positions: [
          Offset(-20, -12),
          Offset(-8, 0),
          Offset(-8, -8),
        ],
      ),
      _ParticleData(
        color: Color(0xB31aff1a),
        blur: 7,
        positions: [
          Offset(12, -16),
          Offset(8, -16),
          Offset(20, -12),
        ],
      ),
      // === 粉色组 ===
      _ParticleData(
        color: Color(0xB3ff1a75), // #ff1a75
        blur: 8, // CSS: blur 16px
        positions: [
          Offset(-16, -8),
          Offset(8, 4),
          Offset(-4, -20),
        ],
      ),
      _ParticleData(
        color: Color(0xB3ff1a75),
        blur: 8,
        positions: [
          Offset(8, 4),
          Offset(-8, -16),
          Offset(4, -24),
        ],
      ),
      // === 蓝色组 ===
      _ParticleData(
        color: Color(0xB31aa3ff), // rgba(26, 163, 255, .7)
        blur: 6, // CSS: blur 12px
        positions: [
          Offset(16, -8),
          Offset(8, -16),
          Offset(4, -24),
        ],
      ),
      _ParticleData(
        color: Color(0xB31aa3ff),
        blur: 6,
        positions: [
          Offset(-16, 8),
          Offset(-16, 8), // 33% 与 0% 相同
          Offset(-8, -24),
        ],
      ),
      _ParticleData(
        color: Color(0xB31aa3ff),
        blur: 6,
        positions: [
          Offset(4, -12),
          Offset(-8, -12),
          Offset(0, -16),
        ],
      ),
      _ParticleData(
        color: Color(0xB31aa3ff),
        blur: 6,
        positions: [
          Offset(-16, -4),
          Offset(-16, -4), // 33% 与 0% 相同
          Offset(4, -4),
        ],
      ),
      _ParticleData(
        color: Color(0xB31aa3ff),
        blur: 7, // CSS: blur 14px
        positions: [
          Offset(4, -4),
          Offset(4, -8),
          Offset(0, -20),
        ],
      ),
    ];

    for (final p in particles) {
      final pos = _lerpPosition(p.positions, progress);
      final paint = Paint()
        ..color = p.color
        // 使用 MaskFilter.blur 模拟 CSS filter: blur()
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.blur);
      canvas.drawCircle(center + pos, dotRadius, paint);
    }
  }

  /// 三阶段位置插值：0% -> 33% -> 66% -> 100%(回到 0%)
  Offset _lerpPosition(List<Offset> positions, double t) {
    if (t < 0.33) {
      return Offset.lerp(positions[0], positions[1], t / 0.33)!;
    } else if (t < 0.66) {
      return Offset.lerp(positions[1], positions[2], (t - 0.33) / 0.33)!;
    } else {
      return Offset.lerp(positions[2], positions[0], (t - 0.66) / 0.34)!;
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

/// 内层 inset 阴影绘制器
/// 模拟 CSS：inset 0 3px 12px rgba(52,223,255,.9), inset 0 -3px 4px rgba(215,250,255,.8)
class _InsetShadowPainter extends CustomPainter {
  const _InsetShadowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 顶部内阴影：青色 #34dfff，模拟从顶部边缘向内扩散
    final topPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -1.8),
        radius: 2.5,
        colors: [
          Color(0x6634dfff),
          Colors.transparent,
        ],
        stops: [0.0, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, topPaint);

    // 底部内阴影：白色 #d7faff，模拟从底部边缘向内扩散
    final bottomPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, 1.8),
        radius: 2.5,
        colors: [
          Color(0x66d7faff),
          Colors.transparent,
        ],
        stops: [0.0, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
