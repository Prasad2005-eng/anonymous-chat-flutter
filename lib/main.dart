import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anonymous Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// Logo Options Widget
class GlowLogo extends StatelessWidget {
  final int logoType; // 1-5 for different logo designs
  final double size;
  final Color? color;

  const GlowLogo({Key? key, this.logoType = 1, this.size = 80, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (logoType) {
      case 1: // Glowing Chat Bubble
        return _GlowingChatBubble(size: size, color: color);
      case 2: // Network Node
        return _NetworkNode(size: size, color: color);
      case 3: // Neon G
        return _NeonG(size: size, color: color);
      case 4: // Light Burst
        return _LightBurst(size: size, color: color);
      case 5: // Infinity Glow
        return _InfinityGlow(size: size, color: color);
      default:
        return _GlowingChatBubble(size: size, color: color);
    }
  }
}

// Logo 1: Glowing Chat Bubble
class _GlowingChatBubble extends StatelessWidget {
  final double size;
  final Color? color;
  const _GlowingChatBubble({required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7C3AED).withOpacity(0.6),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFA855F7).withOpacity(0.4),
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.chat_bubble_rounded,
          size: size * 0.5,
          color: color ?? Color(0xFF7C3AED),
        ),
      ),
    );
  }
}

// Logo 2: Network Node (Connected Dots forming G) - IMPROVED
class _NetworkNode extends StatelessWidget {
  final double size;
  final Color? color;
  const _NetworkNode({required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Color(0xFF00D9FF).withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00D9FF).withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 50,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.2),
        child: CustomPaint(
          painter: _NetworkNodePainter(color: color ?? Color(0xFF00D9FF)),
          size: Size(size, size),
        ),
      ),
    );
  }
}

class _NetworkNodePainter extends CustomPainter {
  final Color color;
  _NetworkNodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double nodeSize = size.width * 0.08;

    // Draw network nodes forming connected pattern
    List<Offset> nodes = [
      Offset(centerX, centerY - size.height * 0.25),
      Offset(centerX + size.width * 0.2, centerY - size.height * 0.12),
      Offset(centerX + size.width * 0.2, centerY + size.height * 0.12),
      Offset(centerX, centerY + size.height * 0.25),
      Offset(centerX - size.width * 0.2, centerY + size.height * 0.12),
      Offset(centerX - size.width * 0.2, centerY - size.height * 0.12),
      Offset(centerX, centerY),
    ];

    // Draw connections with gradient effect
    for (int i = 0; i < nodes.length; i++) {
      int nextIndex = (i + 1) % nodes.length;
      canvas.drawLine(nodes[i], nodes[nextIndex], linePaint);
    }

    // Draw center connections
    canvas.drawLine(nodes[0], nodes[6], linePaint);
    canvas.drawLine(nodes[2], nodes[6], linePaint);
    canvas.drawLine(nodes[4], nodes[6], linePaint);

    // Draw nodes with glow
    for (int i = 0; i < nodes.length; i++) {
      // Outer glow
      nodePaint.color = color.withOpacity(0.3);
      canvas.drawCircle(nodes[i], nodeSize * 1.8, nodePaint);

      // Main node
      nodePaint.color = color;
      canvas.drawCircle(nodes[i], nodeSize * 1.2, nodePaint);

      // Inner highlight
      nodePaint.color = Colors.white;
      canvas.drawCircle(nodes[i], nodeSize * 0.6, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_NetworkNodePainter oldDelegate) => false;
}

// Logo 3: Neon G
class _NeonG extends StatelessWidget {
  final double size;
  final Color? color;
  const _NeonG({required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEC4899).withOpacity(0.6),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFF7C3AED).withOpacity(0.4),
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFF7C3AED)],
              ).createShader(Rect.fromLTWH(0, 0, size, size)),
          ),
        ),
      ),
    );
  }
}

// Logo 4: Light Burst
class _LightBurst extends StatelessWidget {
  final double size;
  final Color? color;
  const _LightBurst({required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFF3CD).withOpacity(0.8),
                  Color(0xFFFBBF24).withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
          CustomPaint(
            painter: _LightBurstPainter(color: color ?? Color(0xFFFBBF24)),
            size: Size(size, size),
          ),
          Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFFBBF24)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFBBF24).withOpacity(0.8),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LightBurstPainter extends CustomPainter {
  final Color color;
  _LightBurstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 3;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    for (int i = 0; i < 16; i++) {
      double angle = (i * pi / 8);
      double x1 = centerX + cos(angle) * (size.width * 0.25);
      double y1 = centerY + sin(angle) * (size.height * 0.25);
      double x2 = centerX + cos(angle) * (size.width * 0.45);
      double y2 = centerY + sin(angle) * (size.height * 0.45);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_LightBurstPainter oldDelegate) => false;
}

// Logo 5: Infinity Glow
class _InfinityGlow extends StatelessWidget {
  final double size;
  final Color? color;
  const _InfinityGlow({required this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.6),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _InfinityPainter(color: color ?? Color(0xFF7C3AED)),
        size: Size(size, size),
      ),
    );
  }
}

class _InfinityPainter extends CustomPainter {
  final Color color;
  _InfinityPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double centerY = size.height / 2;
    double width = size.width * 0.7;
    double height = size.height * 0.3;

    path.moveTo(size.width * 0.15, centerY);
    path.cubicTo(
      size.width * 0.15,
      centerY - height,
      size.width * 0.35,
      centerY - height,
      size.width * 0.5,
      centerY,
    );
    path.cubicTo(
      size.width * 0.65,
      centerY + height,
      size.width * 0.85,
      centerY + height,
      size.width * 0.85,
      centerY,
    );
    path.cubicTo(
      size.width * 0.85,
      centerY - height,
      size.width * 0.65,
      centerY - height,
      size.width * 0.5,
      centerY,
    );
    path.cubicTo(
      size.width * 0.35,
      centerY + height,
      size.width * 0.15,
      centerY + height,
      size.width * 0.15,
      centerY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_InfinityPainter oldDelegate) => false;
}

// Network/Mesh Background for Chat
class NetworkBackground extends StatefulWidget {
  final Widget child;
  const NetworkBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<NetworkBackground> createState() => _NetworkBackgroundState();
}

class _NetworkBackgroundState extends State<NetworkBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1e3c72),
                Color(0xFF2a5298),
                Color(0xFF7e22ce),
                Color(0xFF9333ea),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: NetworkPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NetworkPainter extends CustomPainter {
  final double animation;
  NetworkPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final nodePaint = Paint()..style = PaintingStyle.fill;

    Random random = Random(42);
    List<Offset> nodes = [];

    // Create network nodes
    for (int i = 0; i < 40; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;

      // Animate nodes slightly
      double offsetX = sin((animation * 2 * pi) + i) * 10;
      double offsetY = cos((animation * 2 * pi) + i * 0.5) * 10;

      nodes.add(Offset(x + offsetX, y + offsetY));
    }

    // Draw connections
    paint.color = Colors.cyan.withOpacity(0.15);
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        double distance = (nodes[i] - nodes[j]).distance;
        if (distance < 150) {
          double opacity = (1 - distance / 150) * 0.2;
          paint.color = Colors.cyan.withOpacity(opacity);
          canvas.drawLine(nodes[i], nodes[j], paint);
        }
      }
    }

    // Draw nodes with glow
    for (var node in nodes) {
      // Glow effect
      nodePaint.color = Color(0xFFa855f7).withOpacity(0.4);
      canvas.drawCircle(node, 6, nodePaint);

      nodePaint.color = Color(0xFFe879f9).withOpacity(0.6);
      canvas.drawCircle(node, 4, nodePaint);

      // Core
      nodePaint.color = Color(0xFFfbbf24);
      canvas.drawCircle(node, 2, nodePaint);
    }

    // Add some bright glowing nodes
    for (int i = 0; i < 8; i++) {
      int nodeIndex = (i * 5) % nodes.length;
      Offset node = nodes[nodeIndex];

      double pulse = sin(animation * 2 * pi + i) * 0.5 + 0.5;

      nodePaint.color = Color(0xFFa855f7).withOpacity(0.3 * pulse);
      canvas.drawCircle(node, 15 * pulse, nodePaint);

      nodePaint.color = Color(0xFFe879f9).withOpacity(0.6 * pulse);
      canvas.drawCircle(node, 8 * pulse, nodePaint);
    }
  }

  @override
  bool shouldRepaint(NetworkPainter oldDelegate) => true;
}

// Animated Geometric Background
class GeometricBackground extends StatefulWidget {
  final Widget child;
  const GeometricBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<GeometricBackground> createState() => _GeometricBackgroundState();
}

class _GeometricBackgroundState extends State<GeometricBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2D1B69),
                Color(0xFF6B4BA3),
                Color(0xFFD946A6),
                Color(0xFFFF8C42),
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: GeometricPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class GeometricPainter extends CustomPainter {
  final double animation;
  GeometricPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    Random random = Random(42);

    for (int i = 0; i < 30; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double triangleSize = 40 + random.nextDouble() * 80;

      double offset = sin((animation * 2 * pi) + i) * 20;
      y += offset;

      paint.color = [
        Color(0xFF4FACFE).withOpacity(0.3),
        Color(0xFF00F2FE).withOpacity(0.3),
        Color(0xFFFEAC5E).withOpacity(0.3),
        Color(0xFFFA8BFF).withOpacity(0.3),
      ][i % 4];

      if (i % 3 == 0) {
        _drawTriangle(canvas, Offset(x, y), triangleSize, paint);
      } else if (i % 3 == 1) {
        canvas.drawCircle(Offset(x, y), triangleSize / 3, paint);
      } else {
        paint.style = PaintingStyle.fill;
        paint.color = paint.color.withOpacity(0.05);
        _drawTriangle(canvas, Offset(x, y), triangleSize, paint);
        paint.style = PaintingStyle.stroke;
      }
    }

    for (int i = 0; i < 5; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height + (animation * 100);
      y = y % size.height;

      paint.color = Colors.white.withOpacity(0.6);
      paint.strokeWidth = 2;
      canvas.drawCircle(Offset(x, y), 3, paint..style = PaintingStyle.fill);

      paint.color = Colors.white.withOpacity(0.3);
      canvas.drawCircle(
        Offset(x, y),
        15,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2);
    path.lineTo(center.dx - size / 2, center.dy + size / 2);
    path.lineTo(center.dx + size / 2, center.dy + size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(GeometricPainter oldDelegate) => true;
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  int _currentLogo = 1; // Chat Bubble Logo (not network node)

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(_glowController);

    _scaleController.forward();

    Future.delayed(Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GeometricBackground(
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.9 + (_glowAnimation.value * 0.1),
                      child: GlowLogo(
                        logoType: _currentLogo, // TRY: 1, 2, 3, 4, or 5
                        size: 120,
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),
                Text(
                  'Glow',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.white, Color(0xFFE0E7FF)],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Anonymous Chat',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.white70, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Chat privately with anyone',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _roomCodeController = TextEditingController();
  final _nicknameController = TextEditingController();
  bool _isCreating = true;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      6,
      (_) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  void _createRoom() {
    if (_nicknameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a nickname', Colors.orange);
      return;
    }
    Navigator.push(
      context,
      _createRoute(
        ChatScreen(
          roomCode: _generateRoomCode(),
          nickname: _nicknameController.text.trim(),
        ),
      ),
    );
  }

  void _joinRoom() {
    if (_roomCodeController.text.trim().isEmpty ||
        _nicknameController.text.trim().isEmpty) {
      _showSnackBar('Please fill all fields', Colors.orange);
      return;
    }
    Navigator.push(
      context,
      _createRoute(
        ChatScreen(
          roomCode: _roomCodeController.text.trim().toUpperCase(),
          nickname: _nicknameController.text.trim(),
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut;
        var tween = Tween(
          begin: Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: Duration(milliseconds: 400),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GeometricBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF4FACFE).withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            size: 50,
                            color: Color(0xFF6B4BA3),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Glow',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Anonymous Chat',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🔒', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text(
                              'Chat privately with anyone',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 40,
                              offset: Offset(0, 20),
                            ),
                            BoxShadow(
                              color: Color(0xFF4FACFE).withOpacity(0.2),
                              blurRadius: 60,
                              spreadRadius: -10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F7FA),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _isCreating = true),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: _isCreating
                                              ? LinearGradient(
                                                  colors: [
                                                    Color(0xFF5E72EB),
                                                    Color(0xFF8E54E9),
                                                  ],
                                                )
                                              : null,
                                          color: _isCreating
                                              ? null
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: _isCreating
                                              ? [
                                                  BoxShadow(
                                                    color: Color(
                                                      0xFF5E72EB,
                                                    ).withOpacity(0.4),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_circle_outline_rounded,
                                              color: _isCreating
                                                  ? Colors.white
                                                  : Color(0xFF6B7280),
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Create',
                                              style: TextStyle(
                                                color: _isCreating
                                                    ? Colors.white
                                                    : Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _isCreating = false),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: !_isCreating
                                              ? LinearGradient(
                                                  colors: [
                                                    Color(0xFF5E72EB),
                                                    Color(0xFF8E54E9),
                                                  ],
                                                )
                                              : null,
                                          color: !_isCreating
                                              ? null
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: !_isCreating
                                              ? [
                                                  BoxShadow(
                                                    color: Color(
                                                      0xFF5E72EB,
                                                    ).withOpacity(0.4),
                                                    blurRadius: 15,
                                                    offset: Offset(0, 6),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.login_rounded,
                                              color: !_isCreating
                                                  ? Colors.white
                                                  : Color(0xFF6B7280),
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Join',
                                              style: TextStyle(
                                                color: !_isCreating
                                                    ? Colors.white
                                                    : Color(0xFF6B7280),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            AnimatedSize(
                              duration: Duration(milliseconds: 300),
                              child: Column(
                                children: [
                                  if (!_isCreating)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 16),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.vpn_key_rounded,
                                            color: Color(0xFF5E72EB),
                                            size: 22,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: TextField(
                                              controller: _roomCodeController,
                                              decoration: InputDecoration(
                                                labelText: 'Room Code',
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF9CA3AF),
                                                  fontSize: 13,
                                                ),
                                                hintText: 'Enter code',
                                                hintStyle: TextStyle(
                                                  color: Color(0xFFD1D5DB),
                                                ),
                                                border: InputBorder.none,
                                                counterText: '',
                                              ),
                                              textCapitalization:
                                                  TextCapitalization.characters,
                                              maxLength: 6,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 2,
                                                fontSize: 16,
                                                color: Color(0xFF1F2937),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F7FA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person_rounded,
                                          color: Color(0xFF8E54E9),
                                          size: 22,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: TextField(
                                            controller: _nicknameController,
                                            decoration: InputDecoration(
                                              labelText: 'Your Nickname',
                                              labelStyle: TextStyle(
                                                color: Color(0xFF9CA3AF),
                                                fontSize: 13,
                                              ),
                                              hintText: 'Enter Nickname',
                                              hintStyle: TextStyle(
                                                color: Color(0xFFD1D5DB),
                                              ),
                                              border: InputBorder.none,
                                              counterText: '',
                                            ),
                                            maxLength: 20,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              height: 54,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF5E72EB),
                                    Color(0xFF8E54E9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF5E72EB).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _isCreating ? _createRoom : _joinRoom,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _isCreating
                                              ? Icons.login_rounded
                                              : Icons.login_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          _isCreating
                                              ? 'Create Room'
                                              : 'Join Room',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.5),
                            size: 12,
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _roomCodeController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
}

// Chat Screen
class ChatScreen extends StatefulWidget {
  final String roomCode;
  final String nickname;
  const ChatScreen({Key? key, required this.roomCode, required this.nickname})
    : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _database = FirebaseDatabase.instance.ref();
  final _scrollController = ScrollController();
  List<Map<dynamic, dynamic>> _messages = [];
  late StreamSubscription _messagesSubscription;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _listenToMessages();
    _messageController.addListener(() {
      setState(() => _isTyping = _messageController.text.trim().isNotEmpty);
    });
  }

  void _shareRoomCode() {
    final text =
        '🎉 Join my Anonymous Chat room!\n\n🔑 Room Code: ${widget.roomCode}\n\nDownload the app and enter this code to chat with me!\n💬 Anonymous, secure, and fun!';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text('Room code copied! Share it with friends 🎉')),
          ],
        ),
        backgroundColor: Color(0xFF43e97b),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _listenToMessages() {
    _messagesSubscription = _database
        .child('rooms/${widget.roomCode}/messages')
        .onValue
        .listen((event) {
          if (!mounted) return;
          if (event.snapshot.value != null) {
            Map<dynamic, dynamic> messagesMap = event.snapshot.value as Map;
            List<Map<dynamic, dynamic>> messagesList = [];
            messagesMap.forEach((key, value) {
              messagesList.add({
                'id': key,
                'nickname': value['nickname'],
                'message': value['message'],
                'timestamp': value['timestamp'],
              });
            });
            messagesList.sort(
              (a, b) => a['timestamp'].compareTo(b['timestamp']),
            );
            if (mounted) {
              setState(() => _messages = messagesList);
              Future.delayed(Duration(milliseconds: 100), () {
                if (mounted && _scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          }
        });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    String messageId = _database
        .child('rooms/${widget.roomCode}/messages')
        .push()
        .key!;
    _database.child('rooms/${widget.roomCode}/messages/$messageId').set({
      'nickname': widget.nickname,
      'message': _messageController.text.trim(),
      'timestamp': ServerValue.timestamp,
    });
    _messageController.clear();
  }

  Color _getColorFromString(String str) {
    final colors = [
      Color(0xFF5E72EB),
      Color(0xFF8E54E9),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
    ];
    return colors[str.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5E72EB), Color(0xFF8E54E9)],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anonymous Chat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                'Room: ${widget.roomCode}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.share_rounded, color: Colors.white, size: 20),
              onPressed: _shareRoomCode,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: NetworkBackground(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start the conversation! 👋',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        var message = _messages[index];
                        bool isMe = message['nickname'] == widget.nickname;
                        Color avatarColor = _getColorFromString(
                          message['nickname'],
                        );

                        return TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 400),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(
                                isMe ? (1 - value) * 30 : (1 - value) * -30,
                                0,
                              ),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe) ...[
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: avatarColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: avatarColor.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        message['nickname'][0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (!isMe)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 12,
                                            bottom: 4,
                                          ),
                                          child: Text(
                                            message['nickname'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: avatarColor,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isMe
                                              ? LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF7C3AED),
                                                    Color(0xFFA855F7),
                                                  ],
                                                )
                                              : null,
                                          color: isMe
                                              ? null
                                              : Colors.white.withOpacity(0.95),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(
                                              isMe ? 20 : 4,
                                            ),
                                            bottomRight: Radius.circular(
                                              isMe ? 4 : 20,
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isMe
                                                  ? Color(
                                                      0xFF7C3AED,
                                                    ).withOpacity(0.4)
                                                  : Colors.black.withOpacity(
                                                      0.1,
                                                    ),
                                              blurRadius: 12,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          message['message'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isMe
                                                ? Colors.white
                                                : Color(0xFF1F2937),
                                            height: 1.4,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isMe) ...[
                                  SizedBox(width: 10),
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: avatarColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: avatarColor.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        message['nickname'][0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1F2937),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    AnimatedScale(
                      duration: Duration(milliseconds: 150),
                      scale: _isTyping ? 1.0 : 0.85,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF7C3AED).withOpacity(0.4),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(23),
                            child: Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messagesSubscription.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
