import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../apis/google_maps_api_client.dart';
import '../models/geo_code_model.dart';
import '../utils/app_constants.dart';

class GoogleMapRepo{

  final GoogleMapsApiClient googleMapsApiClient;

  GoogleMapRepo({required this.googleMapsApiClient});


  Position? _currentLocation;
  Position? get currentLocation => _currentLocation;

  Future<Position> getCurrentLocation() async{
    _currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return _currentLocation!;
  }

  Future<Map<String,String>> searchCoordinateAddress(LatLng position) async{

    Map<String,String> placeAddress = {};
    String url = "/geocode/json?latlng=${position.latitude},${position.longitude}&key=${AppConstants.GEOCODINGKEY}";

    var response = await googleMapsApiClient.getData(url);

    if(response.statusCode == 200){

      final geoCode = GeoCodeModel.fromJson(response.body);

      for(var address in geoCode.results![0].addressComponents!){
        if(address.types![0]=="locality" ||
            address.types![0]=="administrative_area_level_1" ||
            address.types![0]=="country"
        ){
          placeAddress[address.types![0]] = "${address.longName}";
        }
      }

      placeAddress["formatted_address"] = geoCode.results![0].formattedAddress!;

    }

    return placeAddress;

  }


}