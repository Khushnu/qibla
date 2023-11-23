// ignore_for_file: avoid_print

import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:qibla/Constants/colors.dart';
import 'package:qibla/main.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? _animationController;
  double begin = 0.0;
  int directionIndegrees = 0;
  String locationName = '';
  String country = '';
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    begin;
    directionIndegrees;
    super.initState();
  }

  Future<String> getLocationName() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks[0];
        setState(() {
          country = placemark.administrativeArea ?? '';
        });
        return placemark.country ?? 'Getting location';
      } else {
        return 'Unknown Location';
      }
    } catch (e) {
      return 'Error Getting Location';
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.sizeOf(context).height;
    screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
          child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: StreamBuilder(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: screenHeight * 0.2,
                              width: screenWidth * 0.2,
                              child: Lottie.asset('Assets/compass.json')),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Finding Qibla .....',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ));
                    }
                    final directionOfQibla = snapshot.data;
                    animation = Tween(
                            begin: begin,
                            end: directionOfQibla!.qiblah * ((pi / 180) * -1))
                        .animate(_animationController!);
                    begin = directionOfQibla.qiblah * ((pi / 180) * -1);
                    _animationController?.forward(from: 0);
                    directionIndegrees = directionOfQibla.direction.toInt();
                    print(directionIndegrees);

                    if (locationName.isEmpty) {
                      getLocationName().then((name) {
                        setState(() {
                          locationName = name;
                        });
                      });
                    }

                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white60,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '$locationName ,$country',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20, 
                                    fontFamily: 'Mooli'
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              '  $directionIndegrees°',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 59, 
                                  fontFamily: 'Mooli'),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset('Assets/Compass1.png')),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 105),
                          child: Align(
                            alignment: Alignment.center,
                            child: AnimatedBuilder(
                                animation: animation!,
                                builder: (_, child) {
                                  return Transform.rotate(
                                    angle: animation!.value,
                                    child: Image.asset(
                                      'Assets/compass.png',
                                      // color: Colors.white,
                                      height: screenHeight * 0.3,
                                    ),
                                  );
                                }),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Qibla Finder Developed by XconTech',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Mooli'),
                          ),
                        )
                      ],
                    );
                  }))),
    );
  }
}
