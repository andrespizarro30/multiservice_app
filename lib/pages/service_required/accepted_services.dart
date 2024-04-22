import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/base/no_data_page.dart';
import 'package:multiservice_app/pages/service_required/multipurpose_service_form.dart';
import 'package:multiservice_app/utils/colors.dart';

import '../../controllers/multiporpuse_form_page_controller.dart';
import '../../utils/dimension.dart';
import '../../widgets/app_icon.dart';

class AcceptedServices extends StatelessWidget {
  const AcceptedServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Servicios Solicitados"),
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          backgroundColor: Colors.white,
          onRefresh: _loadResources,
          child: SingleChildScrollView(
              child: MediaQuery.removePadding(
                removeTop: false,
                context: context,
                child: GetBuilder<MultiPorpuseFormPageController>(builder: (controller){
                  return controller.sentServicesList.isNotEmpty ?
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.sentServicesList.length,
                      reverse: false,
                      itemBuilder: (context,index){

                        List<String> _imagesPaths = controller!.sentServicesList![index].filesPath!.split("-");

                        List<String> imagesPaths = [];

                        _imagesPaths.forEach((path) {
                          if(path.isNotEmpty){
                            imagesPaths.add(path);
                          }
                        });


                        return GestureDetector(
                          onTap: (){

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
                                            Text(controller!.sentServicesList![index].jobType!),
                                            SizedBox(height: Dimensions.height10,),
                                            Text(controller!.sentServicesList![index].requestedDate.toString()),
                                            SizedBox(height: Dimensions.height10,),
                                            Text(controller!.sentServicesList![index].jobAddress!.replaceAll("-", ""),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: Dimensions.width10,),
                                      Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  Divider(height: Dimensions.height10,thickness: Dimensions.height10/4,)
                                ],
                              )
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
          ),
        )
    );
  }

  Future<void> _loadResources() async{
    Get.find<MultiPorpuseFormPageController>().getMyRegisteredJobsRefresh();
  }

}

