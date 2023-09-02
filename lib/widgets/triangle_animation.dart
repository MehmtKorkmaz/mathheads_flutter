import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TriangleAnimation extends StatefulWidget {
  const TriangleAnimation({super.key});

  @override
  State<TriangleAnimation> createState() => _TriangleAnimationState();
}

class _TriangleAnimationState extends State<TriangleAnimation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return //TRİANGLE ANİMATİON
        LottieBuilder.asset(
      'assets/lottie/triangle_icon_lottie.json',
      height: MediaQuery.sizeOf(context).width * 0.5,
      width: MediaQuery.sizeOf(context).width * 0.5,
    );
  }
}
