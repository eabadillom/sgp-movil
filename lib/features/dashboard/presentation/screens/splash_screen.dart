import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget 
{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin 
{
  late final AnimationController _topCircleController;
  late final AnimationController _bottomCircleController;
  late final AnimationController _iconController;
  late final AnimationController _spinnerController;
  late final Animation<double> _topCircleScale;
  late final Animation<double> _bottomCircleScale;
  late final Animation<double> _iconOffset;

  @override
  void initState() 
  {
    super.initState();

    _topCircleController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _bottomCircleController = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat(reverse: true);
    _iconController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _spinnerController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

    _topCircleScale = Tween<double>(begin: 0.9, end: 1.1).animate(_topCircleController);
    _bottomCircleScale = Tween<double>(begin: 1, end: 1.2).animate(_bottomCircleController);
    _iconOffset = Tween<double>(begin: -10, end: 10).animate(_iconController);
  }

  @override
  void dispose() 
  {
    _topCircleController.dispose();
    _bottomCircleController.dispose();
    _iconController.dispose();
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: 
        [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: 
                [
                  Color(0xFF07111F),
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -50,
            child: AnimatedBuilder(
              animation: _topCircleScale,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent.withValues(alpha: 0.25),
                ),
              ),
              builder: (context, child) => Transform.scale(scale: _topCircleScale.value, child: child),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -50,
            child: AnimatedBuilder(
              animation: _bottomCircleScale,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withValues(alpha: 0.18),
                ),
              ),
              builder: (context, child) => Transform.scale(scale: _bottomCircleScale.value, child: child),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(color: Colors.black.withValues(alpha: 0.05)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
              [
                AnimatedBuilder(
                  animation: _iconOffset,
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      boxShadow: 
                      [
                        BoxShadow(
                          color: Colors.lightBlueAccent.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.supervisor_account_sharp,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  builder: (context, child) => Transform.translate(offset: Offset(0, _iconOffset.value), child: child),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: 
                    [
                      const Text('Cargando...', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RotationTransition(
                  turns: _spinnerController,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.9)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
