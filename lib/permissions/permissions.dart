
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/main_page_controller.dart';

void requestGeolocationPermissions() async{

  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  await Geolocator.requestPermission();
  permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
    var status = await Permission.locationAlways.request();
    if(status.isGranted){
      Get.find<MainPageController>().setLocationUpdates();
    }else{

    }
  }
  else
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
        var status = await Permission.locationAlways.request();
        if(status.isGranted){

        }else{

        }
      }
    }
  }

  if (permission == LocationPermission.deniedForever) {
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.whileInUse || permission == LocationPermission.always){
      var status = await Permission.locationAlways.request();
      if(status.isGranted){

      }else{

      }
    }
  }

}

Future<PermissionStatus> requestStoragePermission() async{

  var permissionStatus =await Permission.storage.status;
  var permissionStatusCamera;

  if(permissionStatus.isGranted){
    permissionStatusCamera = await requestCameraPermission();
  }else
  if(permissionStatus.isDenied){
    await Permission.storage.request();

    if(permissionStatus.isGranted){
      permissionStatusCamera = await requestCameraPermission();
    }
  }else if(permissionStatus.isPermanentlyDenied){
    await Permission.storage.request();

    if(permissionStatus.isGranted){
      permissionStatusCamera = await requestCameraPermission();
    }
  }

  permissionStatus = await Permission.storage.status;

  return permissionStatus;

}

Future<PermissionStatus> requestStoragePermissionIOS() async{

  var permissionStatus =await Permission.photos.status;
  var permissionStatusCamera;

  if(permissionStatus.isGranted){
    permissionStatusCamera = await requestCameraPermission();
  }else
  if(permissionStatus.isDenied){
    await Permission.photos.request();

    if(permissionStatus.isGranted){
      permissionStatusCamera = await requestCameraPermission();
    }
  }else if(permissionStatus.isPermanentlyDenied){
    await Permission.photos.request();

    if(permissionStatus.isGranted){
      permissionStatusCamera = await requestCameraPermission();
    }
  }

  permissionStatus = await Permission.photos.status;

  return permissionStatus;

}

Future<PermissionStatus> requestCameraPermission() async{

  var permissionStatus =await Permission.camera.status;

  if(permissionStatus.isDenied){
    await Permission.camera.request();

    if(permissionStatus.isGranted){

    }
  }else if(permissionStatus.isPermanentlyDenied){
    await Permission.camera.request();

    if(permissionStatus.isGranted){

    }
  }

  return permissionStatus;
}