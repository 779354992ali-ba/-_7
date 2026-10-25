import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3D Futuristic Login',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090B10),
      ),
      home: const Login3DScreen(),
    );
  }
}

class Login3DScreen extends StatefulWidget {
  const Login3DScreen({super.key});

  @override
  State<Login3DScreen> createState() => _Login3DScreenState();
}

class _Login3DScreenState extends State<Login3DScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _pulseController;
  bool isLogin = true;

  // متغيرات التفاعل الحركي ثلاثي الأبعاد (3D Tilt) عبر اللمس
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        // تأثير تفاعلي ثلاثي الأبعاد عند تحريك الإصبع على الشاشة
        onPanUpdate: (details) {
          setState(() {
            _tiltX += details.delta.dy * 0.005;
            _tiltY -= details.delta.dx * 0.005;
            // تحديد حدود الميلان
            _tiltX = _tiltX.clamp(-0.3, 0.3);
            _tiltY = _tiltY.clamp(-0.3, 0.3);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _tiltX = 0;
            _tiltY = 0;
          });
        },
        child: Stack(
          children: [
            // خلفية متحركة 3D
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  size: size,
                  painter: Background3DPainter(_bgController.value),
                );
              },
            ),

            // البطاقة الزجاجية بتأثير 3D Transform الحقيقي
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // تأثير العمق ثلاثي الأبعاد
                    ..rotateX(_tiltX)
                    ..rotateY(_tiltY),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        width: size.width > 450 ? 400 : size.width * 0.9,
                        padding: const EdgeInsets.all(28.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // أيقونة متوهجة مع أنيميشن نبض
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_pulseController.value * 0.1),
                                  child: child,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6366F1).withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 36,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              isLogin ? 'مرحباً بك مجدداً' : 'حساب جديد',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              isLogin ? 'قم بتسجيل الدخول للمتابعة' : 'أنشئ حسابك للبدء معنا',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),

                            const SizedBox(height: 30),

                            _buildTextField(
                              hint: 'البريد الإلكتروني',
                              icon: Icons.email_outlined,
                            ),

                            const SizedBox(height: 16),

                            _buildTextField(
                              hint: 'كلمة المرور',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 8,
                                  shadowColor: const Color(0xFF6366F1).withOpacity(0.5),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      isLogin ? 'تسجيل الدخول' : 'إنشاء الحساب',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: isLogin ? 'ليس لديك حساب؟ ' : 'لديك حساب بالفعل؟ ',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  children: [
                                    TextSpan(
                                      text: isLogin ? 'إنشاء حساب' : 'تسجيل الدخول',
                                      style: const TextStyle(
                                        color: Color(0xFFA855F7),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextField(
        obscureText: isPassword,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: const Color(0xFFA855F7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class Background3DPainter extends CustomPainter {
  final double animationValue;

  Background3DPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final offset1 = Offset(
      size.width * 0.2 + math.sin(animationValue * 2 * math.pi) * 40,
      size.height * 0.2 + math.cos(animationValue * 2 * math.pi) * 40,
    );
    paint.shader = RadialGradient(
      colors: [const Color(0xFF6366F1).withOpacity(0.5), Colors.transparent],
    ).createShader(Rect.fromCircle(center: offset1, radius: 200));
    canvas.drawCircle(offset1, 200, paint);

    final offset2 = Offset(
      size.width * 0.8 + math.cos(animationValue * 2 * math.pi) * 50,
      size.height * 0.8 + math.sin(animationValue * 2 * math.pi) * 50,
    );
    paint.shader = RadialGradient(
      colors: [const Color(0xFFA855F7).withOpacity(0.4), Colors.transparent],
    ).createShader(Rect.fromCircle(center: offset2, radius: 250));
    canvas.drawCircle(offset2, 250, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
