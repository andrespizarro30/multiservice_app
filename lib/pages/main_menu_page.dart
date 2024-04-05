import 'package:flutter/material.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/small_text.dart';

import '../utils/dimension.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BigText(text: "Servicios"),
          ],
        ),
        ),
        mainServicesScrollView(),
      ],
    );

  }

  Widget mainServicesScrollView(){
    return Container(
      height: Dimensions.screenHeight/3,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index){
            return Container(
              margin: EdgeInsets.only(left: Dimensions.width10/2,right: Dimensions.width10/2),
              width: Dimensions.screenWidth/3.5,
              height: Dimensions.screenHeight/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width:Dimensions.screenWidth/3.5,
                    height: Dimensions.screenHeight/8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: ExactAssetImage(
                              "assets/image/test_image.png",
                              scale: 1,
                            )
                        )
                    ),
                  ),
                  SmallText(text: "Servicio ${index}"),
                  Container(
                    width:Dimensions.screenWidth/3.5,
                    height: Dimensions.screenHeight/8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white38,
                        image: DecorationImage(
                            fit: BoxFit.scaleDown,
                            image: ExactAssetImage(
                              "assets/image/test_image.png",
                              scale: 1,
                            )
                        )
                    ),
                  ),
                  SmallText(text: "Servicio ${index}"),
                ],
              ),
            );

          }
      ),
    );
  }

}
