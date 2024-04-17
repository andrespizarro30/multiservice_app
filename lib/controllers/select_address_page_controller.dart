
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiservice_app/models/address_details_model.dart';
import 'package:multiservice_app/models/place_info_model.dart';
import 'package:multiservice_app/repositories/google_map_repository.dart';

import '../models/places_code_model.dart';

class SelectAddressPageController extends GetxController implements GetxService{

  final GoogleMapRepo googleMapRepo;

  SelectAddressPageController({
    required this.googleMapRepo
  });

  LatLng _currentPosition = LatLng(0, 0);
  LatLng get currentPosition => _currentPosition;

  LatLng _selectedPosition = LatLng(0, 0);
  LatLng get selectedPosition => _selectedPosition;

  Set<Marker> _currentPositionMarkerSet = {};
  Set<Marker> get currentPositionMarkerSet => _currentPositionMarkerSet;
  set setCurrentPositionMarker(Set<Marker> markerSet){
    _currentPositionMarkerSet = markerSet;
    update();
  }

  Map<String,String> _placeAddress = {};
  Map<String,String> get placeAddress => _placeAddress;

  List<Predictions> _predictions = [];
  List<Predictions> get predictions => _predictions;

  PlacesInfoModel _placesInfoModel = PlacesInfoModel();
  PlacesInfoModel get placesInfoModel => _placesInfoModel;

  bool _addressWithOutDetail = false;
  bool get addressWithOutDetail => _addressWithOutDetail;

  void getCurrentLocation() async{

    Position position = await googleMapRepo.getCurrentLocation();

    if(_selectedPosition.latitude == 0 && _selectedPosition.longitude == 0){
      _currentPosition = LatLng(position.latitude, position.longitude);
      searchCoordinateAddress(currentPosition);
    }
  }

  void deleteSelectedLocation() async{
    _selectedPosition = LatLng(0, 0);
  }

  void assignCurrentPositionMarker(){
    Marker currentPositionMarker = Marker(
      markerId: MarkerId("currentPositionMarker"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: currentPosition
    );

    _currentPositionMarkerSet.add(currentPositionMarker);

    getCurrentLocation();

  }

  void searchCoordinateAddress(LatLng position) async{

    _placeAddress = await googleMapRepo.searchCoordinateAddress(position);

    update();

  }

  void findAddressWithName(String place) async{

    _predictions = await googleMapRepo.findAddressWithName(place);

    update();
  }

  void getPlaceDetails(String placeId) async{

    _placesInfoModel = await googleMapRepo.getPlaceDetails(placeId);

    for(var address in _placesInfoModel.result!.addressComponents!){
      if(address.types![0]=="locality" ||
          address.types![0]=="administrative_area_level_1" ||
          address.types![0]=="country"
      ){
        _placeAddress[address.types![0]] = "${address.longName}";
      }
    }

    _placeAddress["formatted_address"] = _placesInfoModel.result!.formattedAddress!;
    _placeAddress["position"] = "${_placesInfoModel.result!.geometry!.location!.lat!.toString()},${_placesInfoModel.result!.geometry!.location!.lng!.toString()}";

    _selectedPosition = LatLng(_placesInfoModel.result!.geometry!.location!.lat!, _placesInfoModel.result!.geometry!.location!.lng!);

    _currentPosition = _selectedPosition;

    update();
  }

  void cleanAddress(){
    _placesInfoModel = PlacesInfoModel();
  }

  void checkAddressWithoutDetail(){
    _addressWithOutDetail = !_addressWithOutDetail;
    update();
  }

  Future<bool> saveNewAddress(AddressDetailModel addressDetailModel) async{

    return await googleMapRepo.saveNewAddress(addressDetailModel);

  }

  void updatePage(){
    update();
  }

}