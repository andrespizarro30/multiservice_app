import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/pages/service_required/multipurpose_service_form.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/widgets/app_icon.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';

import '../../base/no_data_page.dart';
import '../../controllers/multiporpuse_form_page_controller.dart';
import '../../models/multiporpuse_job_detail_model.dart';
import '../../utils/dimension.dart';
import '../../widgets/small_text.dart';

class PendingServices extends StatelessWidget {
  const PendingServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios Pendientes"),
      ),
      body: SingleChildScrollView(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: GetBuilder<MultiPorpuseFormPageController>(builder: (controller){
              return controller.pendingServicesList.isNotEmpty ?
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.pendingServicesList.length,
                  reverse: true,
                  itemBuilder: (context,index){

                    List<String> _imagesPaths = controller!.pendingServicesList![index].FilesPath!.split("-");

                    List<String> imagesPaths = [];

                    _imagesPaths.forEach((path) {
                      if(path.isNotEmpty){
                        imagesPaths.add(path);
                      }
                    });


                    return GestureDetector(
                      onTap: (){
                        Get.to(() => MultiporpuseServiceForm(serviceType: controller!.pendingServicesList![index].JobType!,multiporpuseJobDetail: controller!.pendingServicesList![index],),transition: Transition.rightToLeft,duration: Duration(milliseconds: 500));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: Dimensions.width10,right: Dimensions.width10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ApplIcon(icon: CupertinoIcons.person),
                                SizedBox(width: Dimensions.width10,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller!.pendingServicesList![index].JobType!),
                                      SizedBox(height: Dimensions.height10,),
                                      Text(controller!.pendingServicesList![index].RequestedDate.toString()),
                                      SizedBox(height: Dimensions.height10,),
                                      Text(controller!.pendingServicesList![index].JobAddress!.replaceAll("-", ""),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Dimensions.width10,),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                            Divider(height: Dimensions.height10,thickness: Dimensions.height10/4,)
                          ],
                        ),
                      ),
                    );
                  }
              ) :
              NoDataPage(
                text: "Solicita ya tu primer servicio !!!",
                imgPath: "assets/image/empty_cart.png",
              );
            }),
          )
      )
    );
  }
}
