import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/main_menu_page_controller.dart';
import 'package:multiservice_app/models/services_type_model.dart';
import 'package:multiservice_app/push_notifications/push_notification_system.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/small_text.dart';

import '../../models/advertising_info_model.dart';
import '../../permissions/permissions.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';


class MainMenuPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    PageController pageController = PageController(viewportFraction: 0.85);
    var _currPageValue = 0.0;

    Timer? timer;

    pageController.addListener(() {
      if(pageController.hasClients){
        _currPageValue = pageController.page!;
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(Duration(seconds: 10), (Timer t){
        if(pageController.hasClients){
          int totalAdsPages = Get.find<MainMenuPageController>().advertisingList.length;
          if(_currPageValue.round() == totalAdsPages - 1){
            pageController.animateToPage(0, duration: Duration(milliseconds: 2), curve: Curves.easeInBack);
          }else{
            pageController.nextPage(duration: Duration(milliseconds: 1000), curve: Curves.linear);
          }
        }
      });
    });

    requestLocationPermissions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Dimensions.height30 ,right: Dimensions.width30),
          child: Divider(
            height: Dimensions.height20,
            color: Colors.grey[300],
            thickness: Dimensions.height10/6,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width10*1.5),
          child: BigText(text: "Servicios")
        ),
        mainServicesScrollView(),
        Padding(
          padding: EdgeInsets.only(left: Dimensions.height30 ,right: Dimensions.width30),
          child: Divider(
            height: Dimensions.height20,
            color: Colors.grey[300],
            thickness: Dimensions.height10/6,
          ),
        ),
        MainPublicityPageView(pageController,_currPageValue)
      ],
    );

  }

  Widget mainServicesScrollView(){
    return GetBuilder<MainMenuPageController>(builder: (controller){
      if(!controller.isServicesLoad){
        return FutureBuilder(
            future: controller.getServicesList(),
            initialData: [],
            builder: (context,list){
              return list.data!.isNotEmpty ?
              Container(
                height: Dimensions.screenHeight/3,
                child: GridView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: list.data!.length,
                    itemBuilder: (context, index){
                      return Container(
                        margin: EdgeInsets.only(left: Dimensions.width10/2,right: Dimensions.width10/2),
                        width: Dimensions.screenWidth/3.5,
                        height: Dimensions.screenHeight/3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                width:Dimensions.screenWidth/3.5,
                                height: Dimensions.screenHeight/8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                                    color: Colors.white38,
                                    image: DecorationImage(
                                        fit: BoxFit.scaleDown,
                                        image: NetworkImage(
                                            list.data![index].descriptingIcon!,
                                            scale: 1
                                        )
                                    )
                                ),
                              ),
                            ),
                            Center(child: SmallText(text: list.data![index].serviceType!)),
                          ],
                        ),
                      );

                    }
                ),
              ) :
              Container(
                height: Dimensions.screenHeight/3,
                child: GridView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index){
                      return Container(
                        margin: EdgeInsets.only(left: Dimensions.width10/2,right: Dimensions.width10/2),
                        width: Dimensions.screenWidth/3.5,
                        height: Dimensions.screenHeight/3,
                        child: Container(
                            width:Dimensions.screenWidth/3.5,
                            height: Dimensions.screenHeight/8,
                            child: Center(
                              child: CircularProgressIndicator(color: AppColors.mainColor,),
                            )
                        ),
                      );

                    }
                ),
              );
            }
        );
      }else{
        return controller.servicesTypeList.isNotEmpty ?
        Container(
          height: Dimensions.screenHeight/3,
          child: GridView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0
              ),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.servicesTypeList.length,
              itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.only(left: Dimensions.width10/2,right: Dimensions.width10/2),
                  width: Dimensions.screenWidth/3.5,
                  height: Dimensions.screenHeight/3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          width:Dimensions.screenWidth/3.5,
                          height: Dimensions.screenHeight/8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image: NetworkImage(
                                      controller.servicesTypeList![index].descriptingIcon!,
                                      scale: 1
                                  )
                              )
                          ),
                        ),
                      ),
                      Center(child: SmallText(text: controller.servicesTypeList![index].serviceType!)),
                    ],
                  ),
                );

              }
          ),
        ) :
        Container();
      }
    });
  }

  Widget MainPublicityPageView(PageController pageController,double _currPageValue){

    return GetBuilder<MainMenuPageController>(builder: (controller){
      if(!controller.isAdsLoad){
        return FutureBuilder(
            future: controller.getAdvertisingList(),
            initialData: [],
            builder: (context,list) {
              return list.data!.isNotEmpty ?
              Container(
                color: Colors.white,
                height: Dimensions.pageView * 1.5,
                child: PageView.builder(
                    controller: pageController,
                    itemCount: list.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {

                          },
                          child: _buildPageItem(
                              index, list.data![index] as Advertising,
                              _currPageValue)
                      );
                    }
                ),
              ) :
              Container(
                  height: Dimensions.height20 * 10,
                  width: Dimensions.screenWidth,
                  child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,)
                  )
              );
            }
        );
      }else{
        return Container(
          color: Colors.white,
          height: Dimensions.pageView * 1.5,
          child: PageView.builder(
              controller: pageController,
              itemCount: controller.advertisingList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {

                    },
                    child: _buildPageItem(
                        index, controller.advertisingList[index] as Advertising,
                        _currPageValue)
                );
              }
          ),
        );
      }

    });
  }

  Widget _buildPageItem(int index, Advertising advertising, double _currPageValue) {

    double _scaleFactor = 0.8;
    double _height = Dimensions.pageViewContainer;

    Matrix4 matrix = new Matrix4.identity();

    if(index==_currPageValue.floor()){
      var currScale = 1 - (_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if (index == _currPageValue.floor()+1){
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if (index == _currPageValue.floor()-1){
      var currScale = 1 - (_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height * (1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 1);
    }

    return Transform(
      transform: matrix,
      child: Column(
        children: [
          Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  //color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                  image: DecorationImage(
                      image: NetworkImage(
                          advertising.adImage!
                      ),
                      fit: BoxFit.cover
                  )
              )
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BigText(text: advertising.adName!,),
          )
        ],
      ),
    );
  }

  Future<void> requestLocationPermissions()async{
    requestGeolocationPermissions();
  }

}
