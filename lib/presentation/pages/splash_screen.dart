import 'package:flutter/material.dart';
import 'package:campusconnect/presentation/pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    try {
      // Login screen ki background image preload karo
      precacheImage(const AssetImage('assets/images/loginbck.png'), context);

      // Aur important images bhi preload kar sakte ho
      precacheImage(const AssetImage('assets/icons/google.png'), context);
    } catch (e) {
      // Error handling - agar images nahi milti to bhi app crash nahi hogi
      print('Error preloading images: $e');
    }
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1500),
          pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            var curve = Curves.easeOut;
            var fadeTween =
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(fadeTween),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF11A6F3),
      body: Stack(
        children: [
          // GIF at top center
          Align(
            alignment: const Alignment(0, -0.4),
            child: Image.asset(
              'assets/images/splash.gif',
              width: 300,
              height: 230,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Agar GIF nahi milti to placeholder dikhao
                return Container(
                  width: 300,
                  height: 230,
                  color: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.school, size: 100, color: Colors.white),
                );
              },
            ),
          ),

          // App name at center
          const Align(
            alignment: Alignment.center,
            child: Text(
              'CAMPUS CONNECT',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                letterSpacing: 1.0,
                fontFamily: 'Sourgammy',
              ),
            ),
          ),

          // Signature at bottom right
          Positioned(
            bottom: 30,
            right: 30,
            child: Text(
              '@codewHmZii',
              style: TextStyle(
                color: Colors.white.withOpacity(0.2),
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Sourgammy',
              ),
            ),
          ),
        ],
      ),
    );
  }
}