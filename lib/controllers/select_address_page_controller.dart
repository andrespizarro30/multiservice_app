
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiservice_app/repositories/google_map_repository.dart';

class SelectAddressPageController extends GetxController implements GetxService{

  final GoogleMapRepo googleMapRepo;

  SelectAddressPageController({
    required this.googleMapRepo
  });

  LatLng _currentPosition = LatLng(0, 0);
  LatLng get currentPosition => _currentPosition;

  Set<Marker> _currentPositionMarkerSet = {};
  Set<Marker> get currentPositionMarkerSet => _currentPositionMarkerSet;
  set setCurrentPositionMarker(Set<Marker> markerSet){
    _currentPositionMarkerSet = markerSet;
    update();
  }

  Map<String,String> _placeAddress = {};
  Map<String,String> get placeAddress => _placeAddress;

  void getCurrentLocation() async{

    Position position = await googleMapRepo.getCurrentLocation();

    _currentPosition = LatLng(position.latitude, position.longitude);

    searchCoordinateAddress(currentPosition);

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

}