import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qibla/Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

double screenHeight =0; 
double screenWidth = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Permissionss(),
    );
  }
}


class Permissionss extends StatefulWidget {
  const Permissionss({super.key});

  @override
  State<Permissionss> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissionss> with WidgetsBindingObserver {
  bool hasPermission = false;
  
  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
        // ignore: use_build_context_synchronously
      var snack =   SnackBar(
        margin: EdgeInsets.only(
        // ignore: use_build_context_synchronously
        bottom: MediaQuery.of(context).size.height - 120,
        right: 90,
        left: 90),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        behavior: SnackBarBehavior.floating,
        content: const Center(child: Text('Location Access Granted',style: TextStyle(fontFamily: 'Mooli'),)));
         // ignore: use_build_context_synchronously
         ScaffoldMessenger.of(context).showSnackBar(snack);
      } else {
      Permission.location.request().isGranted;
        var snack =   SnackBar(
        margin: EdgeInsets.only(
        // ignore: use_build_context_synchronously
        bottom: MediaQuery.of(context).size.height - 120,
        right: 300,
        left: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'Settings', onPressed: (){
        }),
        content: const Center(child: Text('Location Access Denied. Open Settings ?')));
         // ignore: use_build_context_synchronously
         ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      }
    }
  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: FutureBuilder(
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Lottie.asset('Assets/compass.json'),);
            }
             if (hasPermission) {
              return const SplashScreen();
            }
            else{
              return Scaffold(backgroundColor: Colors.blueGrey.shade800, 
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Please Allow Location in settings.Close and run app after Giving permission', style: TextStyle(color: Colors.white, fontSize: 17),)), 
                    TextButton(onPressed: ()async{
                       await openAppSettings();
                        getPermission();
                        setState(() {
                          hasPermission ;
                        });
                    },style: TextButton.styleFrom(
                      backgroundColor: Colors.grey, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), 
                        side: const BorderSide(color: Colors.white)
                      )
                    ),
                     child: const Text('Retry', style: TextStyle(color: Colors.black),))
                  ],
                ),
              ),);
             }
          },
          future: getPermission(),
        ),
    );
  }
}