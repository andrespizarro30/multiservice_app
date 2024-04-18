import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiservice_app/controllers/main_page_controller.dart';
import 'package:multiservice_app/controllers/multiporpuse_form_page_controller.dart';
import 'package:multiservice_app/models/multiporpuse_job_detail_model.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/utils/colors.dart';
import 'package:multiservice_app/widgets/app_icon.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/icon_text_widget.dart';
import 'package:multiservice_app/widgets/small_text.dart';
import 'package:multiservice_app/widgets/text_field_right_icon.dart';
import 'package:multiservice_app/widgets/text_field_right_icon_with_events.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

import '../../base/image_viewer.dart';
import '../../base/request_camera_gallery.dart';
import '../../base/show_custom_message.dart';
import '../../databases/multiporpuse_service_form_db.dart';
import '../../permissions/permissions.dart';
import '../../utils/dimension.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MultiporpuseServiceForm extends StatelessWidget {

  String serviceType;
  MultiporpuseJobDetail multiporpuseJobDetail;
  String serviceOrderNumber = "";

  MultiporpuseServiceForm({
    super.key,
    required this.serviceType,
    required this.multiporpuseJobDetail
  });

  @override
  Widget build(BuildContext context) {

    TextEditingController jobDescriptionTEC = TextEditingController();

    Get.find<MainPageController>().getCurrentAddress();

    if(multiporpuseJobDetail.OrderNumber == ""){
      serviceOrderNumber = Timestamp.now().seconds.toString()+Timestamp.now().nanoseconds.toString();
      multiporpuseJobDetail.OrderNumber = serviceOrderNumber;
      multiporpuseJobDetail.JobType = serviceType;
      multiporpuseJobDetail.JobAddress = "${Get.find<MainPageController>().currentAddressDetailModel!.formattedAddress!} - ${Get.find<MainPageController>().currentAddressDetailModel!.detailAddress!} - ${Get.find<MainPageController>().currentAddressDetailModel!.referenceAddress!}";
      multiporpuseJobDetail.JobLocation = Get.find<MainPageController>().currentAddressDetailModel!.position!;
      multiporpuseJobDetail.FormType = "MultiporpuseServiceForm";
      multiporpuseJobDetail.LoadedJob = "NO";
    }

    late Directory? appCurrentDirectory;

    SchedulerBinding.instance.addPostFrameCallback((_) async{
      serviceOrderNumber = multiporpuseJobDetail.OrderNumber!;
      jobDescriptionTEC.text = multiporpuseJobDetail.JobDescription!;
      Get.find<MultiPorpuseFormPageController>().assignToCurrentModel(multiporpuseJobDetail);
      appCurrentDirectory = Platform.isAndroid ? await getDownloadsDirectory() : await getApplicationDocumentsDirectory();
    });

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GetBuilder<MultiPorpuseFormPageController>(builder: (controller){

        if(controller.isFinishUpload){
          controller.setFinishedUpload = false;
          if(controller.multiporpuseJobDetail.LoadedJob == "NO"){
            Fluttertoast.showToast(
                msg: "Problema de carga, intente nuevamente",
                backgroundColor: Colors.black,
                textColor: Colors.red,
                toastLength: Toast.LENGTH_LONG);
          }
        }

        return !controller.isNewJobDataLoading && controller.multiporpuseJobDetail.LoadedJob == "NO" ?
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Dimensions.height10/3,right: Dimensions.height10/3),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: Dimensions.height40 * 3.5,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.4,
                                    0.7
                                  ],
                                  colors: [Colors.white,AppColors.mainColor]
                              )
                          ),
                        )
                    ),
                    pinned: true,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: AppColors.mainColor,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(Dimensions.height40 * 2),
                        child: BigText(text: serviceType,color: Colors.white,size: Dimensions.font20 * 1.5,)
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Dimensions.radius30),
                            bottomRight: Radius.circular(Dimensions.radius30)
                        )
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [
                            SizedBox(height: Dimensions.height10,),
                            BigText(text: "Dirección donde se realizará el servicio"),
                            IconTextWidget(
                                applIcon: ApplIcon(
                                  icon: Icons.location_on,
                                ),
                                bigText: BigText(text: controller.multiporpuseJobDetail.JobAddress!)
                            ),
                            SizedBox(height: Dimensions.height10,),
                            IconTextWidget(
                                applIcon: ApplIcon(
                                  icon: Icons.gps_fixed,
                                ),
                                bigText: BigText(text: controller.multiporpuseJobDetail.JobLocation!.isNotEmpty ?
                                controller.multiporpuseJobDetail.JobLocation!.split(",")[0].substring(0,5) +","+ controller.multiporpuseJobDetail.JobLocation!.split(",")[1].substring(0,5) :
                                "")
                            ),
                            SizedBox(height: Dimensions.height10,),
                            BigText(text: "Descripción del trabajo"),
                            SizedBox(height: Dimensions.height10,),
                            TextFieldRightIconWithEvents(
                              textEditingController: jobDescriptionTEC,
                              textHint: "Registre claramente el servicio que solicita",
                              icon: Icons.close,
                              textInputType: TextInputType.text,
                              maxLines: 5,
                              multiporpuseJobDetail: multiporpuseJobDetail,
                            ),
                            SizedBox(height: Dimensions.height10,),
                            BigText(text: "Agregue registro fotográfico del trabajo a realizar",linesNumber: 2,),
                            controller.jobPhotosList.containsKey(serviceOrderNumber) ?
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
                                  itemCount: controller.jobPhotosList[serviceOrderNumber]!.length,
                                  itemBuilder: (context, index){
                                    return GestureDetector(
                                      onTap: (){
                                        Get.toNamed(RouteHelper.getImageViewer("${appCurrentDirectory!.path}${controller.jobPhotosList[serviceOrderNumber]![index]}"));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: Dimensions.width10/2,right: Dimensions.width10/2),
                                        width: Dimensions.screenWidth/3.5,
                                        height: Dimensions.screenHeight/3,
                                        child: Image.file(File("${appCurrentDirectory!.path}${controller.jobPhotosList[serviceOrderNumber]![index]}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            ) :
                            Container(
                              height: Dimensions.height10,
                              width: Dimensions.screenWidth,
                            ),
                            Container(
                              child: IconButton(
                                onPressed: () async{
                                  var permissionStatus = Platform.isAndroid ? await requestStoragePermissionIOS() : await requestStoragePermissionIOS();
                                  if(permissionStatus.isGranted){
                                    pickImageFromCamera(Get.find<MultiPorpuseFormPageController>());
                                  }else
                                  if(Platform.isIOS){
                                    pickImageFromCamera(Get.find<MultiPorpuseFormPageController>());
                                  }
                                  else{
                                    showCustomSnackBar("Acepte los permisos de cámara requeridos");
                                  }
                                },
                                icon: Icon(Icons.add_a_photo),
                              ),
                            ),
                            SizedBox(height: Dimensions.height20,),
                            ElevatedButton(
                                onPressed: () async{
                                  await controller.uploadJobImages(appCurrentDirectory!.path, multiporpuseJobDetail);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Solicitar profesional"),
                                    SizedBox(width: Dimensions.width40,),
                                    Icon(Icons.cloud_upload_sharp)
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.mainColor,
                                    backgroundColor: Colors.white
                                )
                            )
                          ]
                      )
                  )
                ],
              ),
            ),
            Positioned(
              top: Dimensions.height40 * 1.5,
              left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap:(){
                        Navigator.pop(context) ;
                      },
                      child: ApplIcon(icon: Icons.arrow_back_ios)
                  ),
                  SizedBox(width: Dimensions.width20,),
                  GestureDetector(
                      onTap:() async{
                        await controller.uploadJobImages(appCurrentDirectory!.path, multiporpuseJobDetail);
                      },
                      child: ApplIcon(icon: Icons.cloud_upload_sharp)
                  )
                ],
              ),
            ),
          ],
        ):
        !controller.isNewJobDataLoading && controller.multiporpuseJobDetail.LoadedJob == "OK" ?
        Container(
          color: Colors.white,
          child: Center(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/image/correct_upload.png",height: Dimensions.screenHeight / 2,width: Dimensions.screenWidth,),
                  SizedBox(height: Dimensions.height20,),
                  Text("Solicitud de personal enviada correctamente"),
                  SizedBox(height: Dimensions.height20,),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 35.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
                ],
              ),
            ),
          ),
        ):
        Container(
          color: Colors.white,
          child: Center(
            child: Image.asset("assets/image/uploading_files.gif",height: Dimensions.screenHeight / 2,width: Dimensions.screenWidth,)
          ),
        );
      })
    );
  }

  Future pickImageFromCamera(MultiPorpuseFormPageController controller) async{

    var response = await showDialog(
        context: Get.context!,
        builder: (BuildContext c) => RequestCameraOrGallery(

        ));

    DateTime dateTime = DateTime.now();

    String selectedDate = "${DateFormat('yyyyMMdd').format(dateTime)}";

    XFile? returnedImage;

    if(response == "Camara"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 30);
    }else
    if(response == "Galeria"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 30);
    }

    if(returnedImage == null) return;

    String timeStamp = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString()+DateTime.now().minute.toString()+DateTime.now().second.toString();

    String dir = path.dirname(returnedImage.path);
    String newFilename = "${serviceType}_${selectedDate}_${serviceOrderNumber}_${timeStamp}.jpg";
    String newPathName = path.join(dir,"${newFilename}");
    File imageFile = File(returnedImage.path).renameSync(newPathName);

    var appDirectory = Platform.isAndroid ? await getDownloadsDirectory() : await getApplicationDocumentsDirectory();

    Directory folderDir = Directory("${appDirectory!.path}/${serviceType}/${selectedDate}/${serviceOrderNumber.toString()}");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    File newImageFile = await imageFile.copy("${folderDir.path}/${newFilename}");

    controller.setJobPhotos(serviceOrderNumber, newImageFile);

    if(controller.jobPhotosList.isNotEmpty){
      if(controller.jobPhotosList.containsKey(serviceOrderNumber)){
        controller.partialSaving(multiporpuseJobDetail);
      }
    }

  }

}
