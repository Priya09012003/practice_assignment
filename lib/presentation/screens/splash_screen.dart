import 'dart:async';
import 'package:flutter/material.dart';
import 'package:practice_assignment/config/routes/routes_name.dart';
import '../../core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pawController;
  late Animation<double> _pawAnimation;

  @override
  void initState() {
    super.initState();

    // Paw bounce animation
    _pawController = AnimationController(duration: const Duration(seconds: 1), vsync: this)..repeat(reverse: true);

    _pawAnimation = Tween<double>(
      begin: 0,
      end: -15,
    ).animate(CurvedAnimation(parent: _pawController, curve: Curves.easeInOut));

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, RoutesName.homeScreen); // Change route if needed
    });
  }

  @override
  void dispose() {
    _pawController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pawAnimation,
              builder: (context, child) {
                return Transform.translate(offset: Offset(0, _pawAnimation.value), child: child);
              },
              child: Icon(Icons.pets, size: 100, color: AppColors.primaryBrown),
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Text(
                "PetCare+",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBrown,
                  fontFamily: 'YourThemeFont', // Replace with your theme font
                ),
              ),
            ),
            const SizedBox(height: 10),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: const Text("Your pet’s happy place 🐶🐱", style: TextStyle(fontSize: 16, color: Colors.brown)),
            ),
          ],
        ),
      ),
    );
  }
}
