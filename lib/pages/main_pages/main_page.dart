import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/authentication_controller.dart';
import 'package:multiservice_app/controllers/main_page_controller.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';
import 'package:multiservice_app/pages/authentication/sign_in_page.dart';
import 'package:multiservice_app/pages/main_pages/main_menu_page.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/widgets/icon_field_widget.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';

import '../../models/address_details_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';
import '../authentication/sign_up_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController insertNewAddresTextController = TextEditingController();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    Get.find<AuthenticationPageController>().verifyCurrentUser();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            return GetBuilder<AuthenticationPageController>(builder: (authController){
              return authController.uid != "" || authController.currentFBUserExists ?
                GetBuilder<MainPageController>(builder: (controller){

                controller.getCurrentAddress();

                return Stack(
                  children: [
                    controller.isOpenAddressRequestContainer ?
                    GestureDetector(
                      onTap: (){
                        controller.openAdressRequestContainer();
                      },
                      child: Container(
                        height: Dimensions.screenHeight,
                        width: double.infinity,
                        color: Colors.black45,
                      ),
                    ):Container(),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Container(
                              margin: EdgeInsets.only(top: Dimensions.height45,bottom: Dimensions.height15),
                              padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Container(
                                        width: Dimensions.width45,
                                        height: Dimensions.height45,
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.mainColor,
                                          child: Icon(Icons.person,color: Colors.white,size: Dimensions.iconSize24,),
                                        )
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10,),
                                  GestureDetector(
                                    onTap: (){
                                      controller.getSavedAddress();
                                      controller.openAdressRequestContainer();
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              BigText(
                                                  text: controller.currentAddressDetailModel.cityCountryAddress!.length>=15 ?
                                                  "${controller.currentAddressDetailModel.cityCountryAddress!.substring(0,15)}..." :
                                                  controller.currentAddressDetailModel.cityCountryAddress!,
                                                  color: AppColors.mainColor
                                              ),
                                              Icon(Icons.arrow_drop_down)
                                            ],
                                          ),
                                          SmallText(
                                            text: controller.currentAddressDetailModel.formattedAddress!.length>=20 ?
                                            "${controller.currentAddressDetailModel.formattedAddress!.substring(0,20)}..." :
                                            controller.currentAddressDetailModel.formattedAddress!,
                                            color: Colors.black54,
                                            size: 14,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width10,),
                                  GestureDetector(
                                    onTap: (){
                                      authController.signOut();
                                      authController.verifyCurrentUser();
                                    },
                                    child: Center(
                                      child: Container(
                                        width: Dimensions.width45,
                                        height: Dimensions.height45,
                                        child: Icon(Icons.logout,color: Colors.white,size: Dimensions.iconSize24,),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radius15),
                                            color: AppColors.mainColor
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: MainMenuPage(),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child:  AnimatedSize(
                          curve: Curves.linear,
                          duration: new Duration(milliseconds: 300),
                          child: Container(
                            height: controller.addressRequestContainerHeight,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dimensions.radius30),
                                    topRight: Radius.circular(Dimensions.radius30)
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    BigText(text: "Agrega o escoge una dirección", size: Dimensions.font20 * 1.5,linesNumber: 2,),
                                    SizedBox(
                                      height: Dimensions.height20,
                                    ),
                                    Divider(
                                      height: Dimensions.height10/2,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(
                                      height: Dimensions.height20,
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        var response = await Get.toNamed(RouteHelper.getSearchAddress());
                                        if(response == "load_address"){
                                          controller.getSavedAddress();
                                        }
                                        Get.find<SelectAddressPageController>().cleanAddress();
                                      },
                                      child: IconTextWidget(
                                        applIcon: ApplIcon(
                                          icon: Icons.gps_fixed,
                                          backgroundColor: Colors.white,
                                          iconColor: Colors.black,
                                          iconSize: Dimensions.iconSize24,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(text: "Ingresa una nueva dirección",size: Dimensions.font16 * 1.1,),
                                        borderColor: AppColors.mainColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.height20,
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        var response = await Get.toNamed(RouteHelper.getSelectAddress());
                                        if(response == "load_address"){
                                          controller.getSavedAddress();
                                        }
                                      },
                                      child: IconTextWidget(
                                        applIcon: ApplIcon(
                                          icon: Icons.near_me,
                                          backgroundColor: Colors.white,
                                          iconColor: Colors.black,
                                          iconSize: Dimensions.iconSize24,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        bigText: BigText(text: "Ubicación actual",size: Dimensions.font16 * 1.1,),
                                        borderColor: AppColors.mainColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimensions.height20,
                                    ),
                                    Divider(
                                      height: Dimensions.height10/2,
                                      color: Colors.grey[400],
                                    ),
                                    controller.addressSaved.isNotEmpty ?
                                    Column(
                                        children: List.generate(controller.addressSaved.length, (index){

                                          return Column(
                                            children: [
                                              SizedBox(height: Dimensions.height10,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: GestureDetector(
                                                        onTap: (){
                                                          controller.selectCurrentAddress(index);
                                                          controller.openAdressRequestContainer();
                                                        },
                                                        child: BigText(text: controller.addressSaved[index].formattedAddress!,linesNumber: 2,)
                                                    ),
                                                  ),
                                                  SizedBox(width: Dimensions.width10,),
                                                  index == 0 ?
                                                  Icon(Icons.check_circle_rounded, color: AppColors.mainColor,) :
                                                  !controller.isReadyToDelete[index]! ?
                                                  GestureDetector(
                                                      onTap:(){
                                                        controller.updateIfReadyToDelete(index, true);
                                                      },
                                                      child: Icon(Icons.more_vert)
                                                  ) :
                                                  GestureDetector(
                                                      onTap:(){
                                                        controller.openDeleteAdressRequestContainer();
                                                      },
                                                      child: Icon(Icons.delete_forever)
                                                  )
                                                ],
                                              ),
                                              Divider(height: Dimensions.height20,)
                                            ],
                                          );
                                        })
                                    ):Container()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ),
                    controller.isOpenDeleteAddressRequestContainer ?
                    GestureDetector(
                      onTap: (){
                        controller.openDeleteAdressRequestContainer();
                      },
                      child: Container(
                        height: Dimensions.screenHeight,
                        width: double.infinity,
                        color: Colors.black45,
                      ),
                    ):Container(),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedSize(
                          curve: Curves.linear,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            height: controller.deleteAddressRequestContainerHeight,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dimensions.radius30),
                                    topRight: Radius.circular(Dimensions.radius30)
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SmallText(text: "ELIMINAR DIRECCIÓN",color: Colors.black,),
                                  SizedBox(height: Dimensions.height10,),
                                  BigText(text: "Seguro desea eliminar la dirección?",size: Dimensions.font26,linesNumber: 2,),
                                  Divider(height: Dimensions.height20,),
                                  ElevatedButton(
                                      onPressed: (){
                                        controller.deleteSpecificAddress();
                                        controller.openDeleteAdressRequestContainer();
                                      },
                                      child: BigText(text: "Eliminar",color: Colors.white,),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.mainColor,
                                          minimumSize: Size(Dimensions.screenWidth * 0.9, Dimensions.height40 * 1.5)
                                      )
                                  ),
                                  SizedBox(height: Dimensions.height10,),
                                  ElevatedButton(
                                      onPressed: (){
                                        controller.openDeleteAdressRequestContainer();
                                      },
                                      child: BigText(text: "Cancelar",color: Colors.black,),
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          minimumSize: Size(Dimensions.screenWidth * 0.9, Dimensions.height40 * 1.5)
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                );
              }) :
                  SignInPage();
            });
          }else{
            return SignInPage();
          }
        },
      )
    );

  }
}
