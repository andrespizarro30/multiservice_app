import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/authentication_controller.dart';
import '../../../controllers/main_page_controller.dart';
import '../../../controllers/select_address_page_controller.dart';
import '../../../routes/routes_helper.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';
import '../../../widgets/app_icon.dart';
import '../../../widgets/big_text.dart';
import '../../../widgets/icon_text_widget.dart';
import '../../../widgets/small_text.dart';
import 'main_menu_page.dart';

class MainMenuAllOptions extends StatelessWidget {

  MainMenuAllOptions({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationPageController>(builder: (authenticationPageController){
      return GetBuilder<MainPageController>(builder: (mainPageController){
        return Stack(
          children: [
            mainPageController.isOpenAddressRequestContainer ?
            Container(
              height: Dimensions.screenHeight,
              width: double.infinity,
              color: Colors.black45,
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
                              mainPageController.getSavedAddress();
                              mainPageController.openAdressRequestContainer();
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      BigText(
                                          text: mainPageController.currentAddressDetailModel.cityCountryAddress!.length>=15 ?
                                          "${mainPageController.currentAddressDetailModel.cityCountryAddress!.substring(0,15)}..." :
                                          mainPageController.currentAddressDetailModel.cityCountryAddress!,
                                          color: AppColors.mainColor
                                      ),
                                      Icon(Icons.arrow_drop_down)
                                    ],
                                  ),
                                  SmallText(
                                    text: mainPageController.currentAddressDetailModel.formattedAddress!.length>=20 ?
                                    "${mainPageController.currentAddressDetailModel.formattedAddress!.substring(0,20)}..." :
                                    mainPageController.currentAddressDetailModel.formattedAddress!,
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
                              authenticationPageController.signOut();
                              authenticationPageController.verifyCurrentUser();
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
                child:  GestureDetector(
                  onVerticalDragUpdate: (details){
                    mainPageController.closeDraggingUpdateAddressRequestContainer(details.delta.dy);
                  },
                  onVerticalDragEnd: (details){
                    mainPageController.closeDraggingEndAddressRequestContainer();
                  },
                  child: AnimatedContainer(
                    height: mainPageController.addressRequestContainerHeight,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius30),
                            topRight: Radius.circular(Dimensions.radius30)
                        )
                    ),
                    duration: Duration(milliseconds: 300),
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
                                  mainPageController.getSavedAddress();
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
                                Get.find<SelectAddressPageController>().deleteSelectedLocation();
                                var response = await Get.toNamed(RouteHelper.getSelectAddress());
                                if(response == "load_address"){
                                  mainPageController.getSavedAddress();
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
                            mainPageController.addressSaved.isNotEmpty ?
                            Column(
                                children: List.generate(mainPageController.addressSaved.length, (index){

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
                                                  mainPageController.selectCurrentAddress(index);
                                                  mainPageController.openAdressRequestContainer();
                                                  mainPageController.getCurrentAddress();
                                                },
                                                child: BigText(text: mainPageController.addressSaved[index].formattedAddress!,linesNumber: 2,)
                                            ),
                                          ),
                                          SizedBox(width: Dimensions.width10,),
                                          index == 0 ?
                                          Icon(Icons.check_circle_rounded, color: AppColors.mainColor,) :
                                          !mainPageController.isReadyToDelete[index]! ?
                                          GestureDetector(
                                              onTap:(){
                                                mainPageController.updateIfReadyToDelete(index, true);
                                              },
                                              child: Icon(Icons.more_vert)
                                          ) :
                                          GestureDetector(
                                              onTap:(){
                                                mainPageController.openDeleteAdressRequestContainer();
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
                  )
                )
            ),
            mainPageController.isOpenDeleteAddressRequestContainer ?
            GestureDetector(
              onTap: (){
                mainPageController.openDeleteAdressRequestContainer();
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
                    height: mainPageController.deleteAddressRequestContainerHeight,
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
                                mainPageController.deleteSpecificAddress();
                                mainPageController.openDeleteAdressRequestContainer();
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
                                mainPageController.openDeleteAdressRequestContainer();
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
      });
    });
  }
}
