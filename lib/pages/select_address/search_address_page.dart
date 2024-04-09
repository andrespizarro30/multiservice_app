import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';

import '../../utils/dimension.dart';
import '../../widgets/big_text.dart';
import '../../widgets/prediction_tile_widget.dart';
import '../../widgets/text_field_right_icon.dart';


class SearchAddressPage extends StatelessWidget {
  const SearchAddressPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController searchAddressTEC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)
        ),
        title: BigText(
          text: "Establecer dirección",
        ),
      ),
      body:GetBuilder<SelectAddressPageController>(builder: (controller){
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0,top: 0, right: 25.0, bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height10/2,),
                    TextFieldRightIcon(
                      textEditingController: searchAddressTEC,
                      textHint: "Ingrese una dirección",
                      icon: Icons.close,
                      textInputType: TextInputType.text,
                      isEnabled: true,
                    ),
                    SizedBox(height: Dimensions.height10/2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/image/powered-by-google.png",
                          height: Dimensions.height40,
                          width: Dimensions.width40*2.5,
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap:(){
                          controller.findAddressWithName(searchAddressTEC.text);
                        },
                        child: Text("Buscar")
                    )
                  ],
                ),
              ),
              (controller.predictions.length>0)
                  ? Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index){
                    return PredictionTile(prediction: controller.predictions[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                  itemCount: controller.predictions.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
              : Container()
            ],
          ),
        );
      }),
    );
  }
}
