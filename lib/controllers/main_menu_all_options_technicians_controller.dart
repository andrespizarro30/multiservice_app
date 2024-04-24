
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapsToolKit;

import 'package:multiservice_app/controllers/multiporpuse_form_page_controller.dart';

import '../models/cities_poligons_model.dart';
import '../models/requested_jobs_detail_model.dart';
import '../repositories/google_map_repository.dart';
import '../routes/routes_helper.dart';

class MainMenuAllOptionsTechniciansController extends GetxController implements GetxService{

  final GoogleMapRepo googleMapRepo;

  MainMenuAllOptionsTechniciansController({
    required this.googleMapRepo
  });

  LatLng _currentPosition = LatLng(0, 0);
  LatLng get currentPosition => _currentPosition;

  LatLng _selectedPosition = LatLng(0, 0);
  LatLng get selectedPosition => _selectedPosition;

  Map<String,String> _placeAddress = {};
  Map<String,String> get placeAddress => _placeAddress;

  List<CityPoligonsData> _citiesPolygonsList = [];
  List<CityPoligonsData> get citiesPolygonsList => _citiesPolygonsList;

  Set<Polygon> _polygonsList = {};
  Set<Polygon> get polygonsList => _polygonsList;

  Set<Circle> _circlesList = {};
  Set<Circle> get circlesList => _circlesList;

  Set<Marker> _markersList = {};
  Set<Marker> get markersList => _markersList;

  Map<String, RequestedJob> _requestedJobMap = {};
  Map<String, RequestedJob> get requestedJobMap => _requestedJobMap;

  List<RequestedJob> _sentServicesList = [];
  List<RequestedJob> get sentServicesList => _sentServicesList;

  void getCurrentLocation() async{

    Position position = await googleMapRepo.getCurrentLocation();
    _currentPosition = LatLng(position.latitude, position.longitude);

  }

  void searchCoordinateAddress(LatLng position) async{

    _placeAddress = await googleMapRepo.searchCoordinateAddress(position);

    update();

  }

  Future<void> getCitiesPolygons() async {

    _citiesPolygonsList=[];

    Response response = await googleMapRepo.getCitiesPolygons();
    if(response.statusCode == 200){
      _citiesPolygonsList.addAll(CitiesPoligonsList.fromJson(response.body).citiespoligonsList);

      _polygonsList.clear();
      _circlesList.clear();

      _citiesPolygonsList.forEach((polyData) {

        List<String> polygonLocation = polyData.poligonMarks!.split(";");

        List<LatLng> polygonPoints = [];

        polygonLocation.forEach((point) {
          List<String> latLang = point.replaceAll("[", "").replaceAll("]", "").split(",");
          polygonPoints.add(LatLng(double.parse(latLang![0]), double.parse(latLang![1])));
        });

        Polygon polygon = Polygon(
            polygonId: PolygonId(polyData.cityName!),
            points: polygonPoints,
            fillColor: Colors.lightBlueAccent.withOpacity(0.3),
            strokeWidth: 2
        );

        _polygonsList.add(polygon);

        List<String> circlesLocation = polyData.circlesCenter!.split(";");

        int circleCount = 0;

        circlesLocation.forEach((point) {
          List<String> latLang = point.replaceAll("[", "").replaceAll("]", "").split(",");
          Circle circle = Circle(
            circleId: CircleId("${polyData.cityName!}${circleCount}"),
            center: LatLng(double.parse(latLang![0]), double.parse(latLang![1])),
            fillColor: Colors.redAccent.withOpacity(0.3),
            strokeWidth: 2,
            radius: 1500
          );
          _circlesList.add(circle);

          String zone = "Zona ${circleCount+1}";

          Marker marker = Marker(
            markerId: MarkerId("${polyData.cityName!}${circleCount}"),
            position: LatLng(double.parse(latLang![0]), double.parse(latLang![1])),
            infoWindow: InfoWindow(
              title: zone,
              snippet: "0"
            )
          );
          _markersList.add(marker);

          circleCount += 1;
        });

      });

      addDataToMarkers();

      update();
    }else{

    }

  }

  Map<String,int> markersJobCount = {};
  Map<String,List<RequestedJob>> markersRequestedJob = {};

  void addDataToMarkers(){

    markersJobCount = {};
    markersRequestedJob = {};

    _sentServicesList.forEach((requestedJob) {

      List<String> jobLocation = requestedJob.jobLocation!.split(",");

      var jobLocationLatLng = mapsToolKit.LatLng(double.parse(jobLocation[0]), double.parse(jobLocation[1]));

      double nearestDistance = 10000000;

      MarkerId markerId = MarkerId("");
      int jobsCount = 0;
      String title = "";
      LatLng position = LatLng(0, 0);
      _markersList.forEach((marker) {
        var markerLatLng = mapsToolKit.LatLng(marker.position.latitude, marker.position.longitude);
        var currentDistance = mapsToolKit.SphericalUtil.computeDistanceBetween(jobLocationLatLng, markerLatLng);
        if(double.parse(currentDistance.toString())<nearestDistance){
          jobsCount = markersJobCount[marker.markerId.toString()] ?? 0;
          position = LatLng(markerLatLng.latitude, markerLatLng.longitude);
          title = marker.infoWindow.title!;
          markerId = marker.markerId;
          nearestDistance = double.parse(currentDistance.toString());
        }
      });

      jobsCount += 1;
      Marker currMark = Marker(markerId: markerId);

      if(!markersJobCount.containsKey(currMark.markerId.toString())){
        markersJobCount.putIfAbsent(currMark.markerId.toString(), (){
          return jobsCount;
        });
      }else{
        markersJobCount.update(currMark.markerId.toString(), (value){
          return jobsCount;
        });
      }

      if(!markersRequestedJob.containsKey(currMark.markerId.toString())){
        markersRequestedJob.putIfAbsent(currMark.markerId.toString(), (){
          List<RequestedJob> requestedJobList = [];
          requestedJobList.add(requestedJob);
          return requestedJobList;
        });
      }else{
        markersRequestedJob.update(currMark.markerId.toString(), (requestedJobList){
          requestedJobList.add(requestedJob);
          return requestedJobList;
        });
      }

      _markersList.remove(currMark);

      currMark = Marker(
          markerId: markerId,
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
              title: title,
              snippet: markersJobCount[currMark.markerId.toString()].toString(),
              onTap: (){
                markersRequestedJob[markerId.toString()]!.forEach((element) {
                  print(element.jobDescription);
                });
              }
          )
      );

      _markersList.add(currMark);

    });

  }

  Future<void> getAllRegisteredJobs()async{

    _sentServicesList=[];

    Response response = await googleMapRepo.getAllRegisteredJobs();
    if(response.statusCode == 200){
      _sentServicesList.addAll(RequestedJobList.fromJson(response.body).requestedJobList);
      getCitiesPolygons();
    }else{

    }

  }

  void updatePage(){
    update();
  }

}