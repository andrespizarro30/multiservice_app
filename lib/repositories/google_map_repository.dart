import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/google_maps_api_client.dart';
import '../models/address_details_model.dart';
import '../models/geo_code_model.dart';
import '../models/place_info_model.dart';
import '../models/places_code_model.dart';
import '../utils/app_constants.dart';

class GoogleMapRepo{

  final GoogleMapsApiClient googleMapsApiClient;
  final SharedPreferences sharedPreferences;

  GoogleMapRepo({
    required this.googleMapsApiClient,
    required this.sharedPreferences
  });

  Position? _currentLocation;
  Position? get currentLocation => _currentLocation;

  List<String> addressSaved = [];

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
      placeAddress["position"] = "${geoCode.results![0].geometry!.location!.lat!.toString()},${geoCode.results![0].geometry!.location!.lng!.toString()}";

    }

    return placeAddress;

  }

  Future<bool> saveNewAddress(AddressDetailModel addressDetailModel) async{

    if(sharedPreferences.containsKey(AppConstants.ADDRESSSAVED)){
      addressSaved = sharedPreferences.getStringList(AppConstants.ADDRESSSAVED)!;
    }

    addressSaved.add(json.encode(addressDetailModel.toJson()));

    sharedPreferences.setStringList(AppConstants.ADDRESSSAVED, addressSaved);

    return true;

  }

  Future<List<Predictions>> findAddressWithName(String place) async{

    List<Predictions> predictions = [];

    String url="/place/autocomplete/json?"
        "input=${place}&"
        "key=${AppConstants.PLACESCODINGKEY}&"
        "components=country:co";

    var response = await googleMapsApiClient.getData(url);

    if(response.statusText == "OK"){

      predictions.addAll(PlacesCodeModel.fromJson(response.body).predictions!);

    }

    return predictions;

  }

  Future<PlacesInfoModel> getPlaceDetails(String placeId) async{

    PlacesInfoModel placeDetails = PlacesInfoModel();

    if(placeId.length>1){
      String url = "/place/details/json?"
          "place_id=${placeId}&"
          "key=${AppConstants.PLACESCODINGKEY}";

      var response = await googleMapsApiClient.getData(url);

      if(response.statusText == "OK"){

        placeDetails = PlacesInfoModel.fromJson(response.body);

      }

    }
    return placeDetails;
  }


}