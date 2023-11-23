import 'package:permission_handler/permission_handler.dart';

class PermissionHandler{
  // ignore: unused_element
  Future<bool> _backgroundLocation()async{
    const permission = Permission.locationWhenInUse;  
    if(await permission.isGranted){
      return true;
    } 
    return false;
  }


  


}