import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../base/request_camera_gallery.dart';
import '../../controllers/authentication_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import 'package:path/path.dart' as path;

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AuthenticationPageController>(builder: (controller){

      return controller.currentFBUserExists ? Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: Center(
            child: BigText(
              text: "Usuario",
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(top: Dimensions.height20),
          child: Column(
            children: [
              //PROFILE ICON
              Stack(
                children: [
                  controller.profileImageURL.isNotEmpty ?
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: NetworkImage(
                      controller.profileImageURL,
                    ),
                  ):
                  ApplIcon(
                    icon: Icons.person,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    iconSize: Dimensions.iconSize20 * 3.5,
                    size: Dimensions.height30 * 5,
                  ),
                  Positioned(
                      right: Dimensions.width10,
                      bottom: Dimensions.height10,
                      child: GestureDetector(
                        onTap: (){
                          pickImageFromCamera(controller);
                        },
                        child: ApplIcon(
                          icon: Icons.edit,
                          size: Dimensions.iconSize24 * 1.8,
                          backgroundColor: Colors.white,
                        ),
                      )
                  )
                ],
              ),
              SizedBox(height: Dimensions.height20,),
              //NAME
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AccountWidget(
                            applIcon: ApplIcon(
                              icon: Icons.person,
                              backgroundColor: AppColors.mainColor,
                              iconColor: Colors.white,
                              iconSize: Dimensions.iconSize24,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: controller.signUpBody.name!,)
                        ),
                        SizedBox(height: Dimensions.height20,),
                        //PHONE
                        AccountWidget(
                            applIcon: ApplIcon(
                              icon: Icons.phone,
                              backgroundColor: AppColors.iconColor1,
                              iconColor: Colors.white,
                              iconSize: Dimensions.iconSize24,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: controller.signUpBody.phone!,)
                        ),
                        SizedBox(height: Dimensions.height20,),
                        //E-MAIL
                        AccountWidget(
                            applIcon: ApplIcon(
                              icon: Icons.mail,
                              backgroundColor: AppColors.iconColor2,
                              iconColor: Colors.white,
                              iconSize: Dimensions.iconSize24,
                              size: Dimensions.height10 * 5,
                            ),
                            bigText: BigText(text: controller.signUpBody.email!,)
                        ),
                        SizedBox(height: Dimensions.height40 * 3,),
                        GestureDetector(
                          onTap: (){
                            controller.signOut();
                            controller.verifyCurrentUser();
                          },
                          child: AccountWidget(
                              applIcon: ApplIcon(
                                icon: Icons.logout,
                                backgroundColor: Colors.redAccent,
                                iconColor: Colors.white,
                                iconSize: Dimensions.iconSize24,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(text: "Logout",)
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ) : Container(child: Center(child: Text("Please do log in first"),),);
    });
  }

  Future pickImageFromCamera(AuthenticationPageController controller) async{

    var response = await showDialog(
        context: Get.context!,
        builder: (BuildContext c) => RequestCameraOrGallery(

        ));

    XFile? returnedImage;

    if(response == "Camara"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 30);
    }else
    if(response == "Galeria"){
      returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 30);
    }

    if(returnedImage == null) return;

    String dir = path.dirname(returnedImage.path);
    String newFilename = "My_Profile_Image.jpg";
    String newPathName = path.join(dir,"${newFilename}");
    File imageFile = File(returnedImage.path).renameSync(newPathName);


    var appDirectory = Platform.isAndroid ? await getDownloadsDirectory() : await getApplicationDocumentsDirectory();

    Directory folderDir = Directory("${appDirectory!.path}/MyPhotoProfile");

    if(await folderDir.exists() == false){
      await folderDir.create(recursive: true);
    }

    File newImageFile = await imageFile.copy("${folderDir.path}/${newFilename}");

    controller.updatePhotoProfile(appDirectory.path,newImageFile);

  }

}
