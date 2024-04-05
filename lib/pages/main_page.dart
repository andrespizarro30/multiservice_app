import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/main_page_controller.dart';
import 'package:multiservice_app/pages/main_menu_page.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/widgets/icon_field_widget.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';
import '../widgets/app_icon.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController insertNewAddresTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<MainPageController>(builder: (controller){
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
                        GestureDetector(
                          onTap: (){
                            controller.openAdressRequestContainer();
                          },
                          child: Column(
                            children: [
                              BigText(
                                  text: "Colombia",
                                  color: AppColors.mainColor
                              ),
                              Row(
                                children: [
                                  SmallText(
                                    text: "Pereira",
                                    color: Colors.black54,
                                    size: 14,
                                  ),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            width: Dimensions.width45,
                            height: Dimensions.height45,
                            child: Icon(Icons.search,color: Colors.white,size: Dimensions.iconSize24,),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius15),
                                color: AppColors.mainColor
                            ),
                          ),
                        )
                      ],
                    ),
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
                            IconFieldWidget(
                                textEditingController: insertNewAddresTextController,
                                textHint: "Ingresa una nueva dirección",
                                icon: Icons.gps_fixed,
                                textInputType: TextInputType.text
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            GestureDetector(
                              onTap: (){
                                Get.toNamed(RouteHelper.selectAddressPage);
                              },
                              child: IconTextWidget(
                                  applIcon: ApplIcon(
                                    icon: Icons.near_me,
                                    backgroundColor: Colors.white,
                                    iconColor: Colors.black,
                                    iconSize: Dimensions.iconSize24,
                                    size: Dimensions.height10 * 5,
                                  ),
                                  bigText: BigText(text: "Ubicación actual",size: Dimensions.font16 * 1.1,)
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            ),
                            Divider(
                              height: Dimensions.height10/2,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            )
          ],
        );
      }),
    );

  }
}
