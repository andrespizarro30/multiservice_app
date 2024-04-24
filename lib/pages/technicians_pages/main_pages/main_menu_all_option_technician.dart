import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiservice_app/controllers/main_menu_all_options_technicians_controller.dart';
import 'package:multiservice_app/controllers/multiporpuse_form_page_controller.dart';

import '../../../routes/routes_helper.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/icon_text_widget.dart';
import '../../../widgets/small_text.dart';

class MainMenuAllOptionsTechnicians extends StatelessWidget {
  const MainMenuAllOptionsTechnicians({super.key});

  @override
  Widget build(BuildContext context) {

    Completer<GoogleMapController> _controllerGoogleMap = Completer();
    GoogleMapController? newGoogleMapController;

    Get.find<MainMenuAllOptionsTechniciansController>().getAllRegisteredJobs();

    return GetBuilder<MainMenuAllOptionsTechniciansController>(builder: (mainMenuController){

      if(mainMenuController.currentPosition.latitude != 0 && mainMenuController.currentPosition.longitude != 0){
        CameraPosition cameraPosition = new CameraPosition(target: mainMenuController.currentPosition, zoom: 11);
        newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      }

      return Scaffold(
          appBar: AppBar(
              title: Text("Mapa de servicios (${mainMenuController.sentServicesList.length} - Disponibles)",style: TextStyle(fontSize: Dimensions.font20),textAlign: TextAlign.center,)
          ),
          body: Stack(
            children: [
              GoogleMap(
                  padding: EdgeInsets.only(bottom: 0),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  polygons: mainMenuController.polygonsList,
                  circles: mainMenuController.circlesList,
                  markers: mainMenuController.markersList,
                  initialCameraPosition: CameraPosition(target: LatLng(0,0),zoom: 15),
                  onMapCreated: (GoogleMapController googleMapController){
                    _controllerGoogleMap.complete(googleMapController);
                    newGoogleMapController = googleMapController;
                    mainMenuController.getCurrentLocation();
                    mainMenuController.markersList.forEach((marker) {
                      newGoogleMapController!.showMarkerInfoWindow(marker.markerId);
                    });
                  }
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      height: Dimensions.screenHeight * 0.2,
                      width: Dimensions.screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: Dimensions.height40,
                                spreadRadius: Dimensions.height40,
                                offset: Offset(0,10),
                                color: Colors.white.withOpacity(1)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          BigText(text: "Selecciona los marcadores de zona para ver los trabajos disponibles",linesNumber: 2,),
                          SizedBox(height: Dimensions.height20,),
                          ElevatedButton(
                              onPressed: () async{
                                mainMenuController.getAllRegisteredJobs();
                              },
                              child: BigText(text: "Actualizar",color: Colors.white,),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  minimumSize: Size(Dimensions.screenWidth * 0.9, Dimensions.height40 * 1.5)
                              )
                          )
                        ],
                      )
                  )
              )
            ],
          )
      );
    });

  }
}
