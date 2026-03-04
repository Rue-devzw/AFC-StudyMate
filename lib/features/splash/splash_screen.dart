import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated splash screen shown on app startup.
/// Navigates via [onComplete] when the intro finishes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────────
  late final AnimationController _bgController;
  late final AnimationController _iconController;
  late final AnimationController _textController;
  late final AnimationController _rayController;
  late final AnimationController _particleController;

  // ── Animations ────────────────────────────────────────────────────────────
  late final Animation<double> _bgOpacity;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _glowPulse;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    // Background fade-in
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgOpacity = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    // Icon entrance – scale + fade
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _iconScale = Tween<double>(begin: 0.3, end: 1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );
    _iconOpacity = CurvedAnimation(
      parent: _iconController,
      curve: const Interval(0, 0.5, curve: Curves.easeIn),
    );

    // Rotating rays + glow pulse
    _rayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _glowPulse = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _rayController, curve: Curves.easeInOut),
    );

    // Particle drift
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Text rise + fade
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );
    _textSlide =
        Tween<Offset>(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOut),
        );
    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1. Fade in background
    await _bgController.forward();

    // 2. Pop in icon
    await _iconController.forward();

    // 3. Reveal text
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await _textController.forward();

    // 4. Hold for effect
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    // 5. Fade out everything & advance
    _rayController.stop();
    _particleController.stop();
    _bgController.reverse().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _rayController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _bgOpacity,
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.4,
            colors: [
              Color(0xFF2C1B5E),
              Color(0xFF0A1045),
              Color(0xFF050820),
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Rotating light rays ─────────────────────────────────────────
            AnimatedBuilder(
              animation: _rayController,
              builder: (context, _) {
                return Transform.rotate(
                  angle: _rayController.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(500, 500),
                    painter: _RaysPainter(
                      opacity: _glowPulse.value * 0.18,
                    ),
                  ),
                );
              },
            ),

            // ── Floating gold particles ─────────────────────────────────────
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ParticlePainter(
                    progress: _particleController.value,
                  ),
                );
              },
            ),

            // ── Icon + text ─────────────────────────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glow circle behind icon
                AnimatedBuilder(
                  animation: _glowPulse,
                  builder: (context, child) {
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4A017).withOpacity(
                              0.25 * _glowPulse.value,
                            ),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: const Color(0xFF9B59B6).withOpacity(
                              0.35 * _glowPulse.value,
                            ),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: FadeTransition(
                    opacity: _iconOpacity,
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App name
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(
                      children: [
                        Text(
                          'AFC StudyMate',
                          style: GoogleFonts.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: const Color(0xFFD4A017).withOpacity(0.6),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your spiritual study companion',
                          style: GoogleFonts.crimsonText(
                            fontSize: 16,
                            color: Colors.white60,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.none,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
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

// ── Custom painters ────────────────────────────────────────────────────────

class _RaysPainter extends CustomPainter {
  _RaysPainter({required this.opacity});
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const rayCount = 16;
    const angleStep = (2 * math.pi) / rayCount;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));

    for (var i = 0; i < rayCount; i++) {
      final angle = i * angleStep;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + math.cos(angle - 0.06) * size.width / 2,
          center.dy + math.sin(angle - 0.06) * size.height / 2,
        )
        ..lineTo(
          center.dx + math.cos(angle + 0.06) * size.width / 2,
          center.dy + math.sin(angle + 0.06) * size.height / 2,
        )
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RaysPainter old) => old.opacity != opacity;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.progress});
  final double progress;

  static final List<_Particle> _particles = List.generate(
    30,
    (i) => _Particle(seed: i),
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress + p.offset) % 1.0;
      final opacity = math.sin(t * math.pi).clamp(0.0, 1.0);
      final x = p.x * size.width;
      final y = size.height - (t * size.height * 1.3);

      final paint = Paint()
        ..color = const Color(0xFFD4A017).withOpacity(opacity * 0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  _Particle({required int seed}) {
    final rng = math.Random(seed);
    x = rng.nextDouble();
    offset = rng.nextDouble();
    radius = 1.0 + rng.nextDouble() * 2.5;
  }

  late double x;
  late double offset;
  late double radius;
}
