import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:qibla/Constants/colors.dart';
import 'package:qibla/Screens/qibla_screen.dart';
// import 'package:qibla/Screens/qiblah_main_screen.dart';
import 'package:lottie/lottie.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool isFirstImage = false; 
  bool isSecondImage = false;

  
@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 550,
         backgroundColor: AppColors.splashScreenBgColor,
       splashTransition: SplashTransition.fadeTransition, 
       pageTransitionType: PageTransitionType.fade ,
       splash: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Lottie.asset('Assets/compass.json',), 
          const SizedBox(
            height: 10, 
          ),  
          AnimatedTextKit(animatedTexts: [ TypewriterAnimatedText(
            'Finding Qibla..',
            textStyle: const TextStyle(color: Colors.black, fontSize: 29, fontFamily: 'Mooli'))])
         ]),
       ) , nextScreen: const QiblaScreen()),
    );
  }
}


