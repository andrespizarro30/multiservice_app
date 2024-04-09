import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/utils/colors.dart';
import 'package:multiservice_app/utils/dimension.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';

import '../../models/address_details_model.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class SelectAddressPage extends StatelessWidget {

  const SelectAddressPage({super.key});

  @override
  Widget build(BuildContext context) {

    Completer<GoogleMapController> _controllerGoogleMap = Completer();
    GoogleMapController? newGoogleMapController;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context,"");
          },
          child: Icon(Icons.close)
        ),
        title: Text("Verifica la ubicación",style: TextStyle(fontSize: Dimensions.font20),textAlign: TextAlign.center,)
      ),
      body: GetBuilder<SelectAddressPageController>(builder: (controller){

        if(newGoogleMapController != null){
          CameraPosition cameraPosition = new CameraPosition(target: controller.currentPosition, zoom: 14);
          newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        }

        return Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: 0),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: controller.currentPositionMarkerSet,
              initialCameraPosition: CameraPosition(target: LatLng(0,0),zoom: 15),
              onMapCreated: (GoogleMapController googleMapController){
                _controllerGoogleMap.complete(googleMapController);
                newGoogleMapController = googleMapController;
                if(controller.placesInfoModel.result == null){
                  controller.getCurrentLocation();
                }else{
                  controller.updatePage();
                }
              }
            ),
            Positioned(
              top: MediaQuery.of(context).size.height/2.8,
              left: Dimensions.screenWidth/2.5,
              child: Icon(
                CupertinoIcons.location_solid,
                size: Dimensions.height40*2,
                color: Colors.orange,
              )
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              BigText(
                                  text: controller.placeAddress.isNotEmpty ? "${controller.placeAddress["locality"] != null ? controller.placeAddress["locality"]! : ""}, ${controller.placeAddress["administrative_area_level_1"] != null ? controller.placeAddress["administrative_area_level_1"]! : "" }" : "-",
                                  color: AppColors.mainBlackColor
                              ),
                              SmallText(
                                text: controller.placeAddress.isNotEmpty ? controller.placeAddress["country"] != null ? controller.placeAddress["country"]! : "" : "-",
                                color: AppColors.mainBlackColor,
                                size: 14,
                              )
                            ],
                          ),
                          SizedBox(width: Dimensions.width10,),
                          GestureDetector(
                            onTap: ()async{
                              if(controller.placesInfoModel.result == null){
                                controller.getCurrentLocation();
                              }
                            },
                            child: Container(
                              width: Dimensions.screenWidth/2,
                              child: IconTextWidget(
                                  applIcon: ApplIcon(
                                      icon: Icons.gps_fixed,
                                      backgroundColor: Colors.white,
                                      iconColor: Colors.black,
                                      iconSize: Dimensions.iconSize16,
                                      size: Dimensions.height30
                                  ),
                                  bigText: BigText(
                                    text: "Encuéntrame",
                                    size: Dimensions.font16,
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async{
                        var close_address_page = await Get.toNamed(RouteHelper.getConfirmAddress());
                        if(close_address_page == "close_address_page"){
                          Navigator.pop(context,"load_address");
                        }
                      },
                      child: BigText(text: "Confirma dirección",color: Colors.white,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        minimumSize: Size(Dimensions.screenWidth * 0.9, Dimensions.height40 * 1.5)
                      )
                    )
                  ],
                ),
              )
            )
          ],
        );
      }),
    );
  }

}
