
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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