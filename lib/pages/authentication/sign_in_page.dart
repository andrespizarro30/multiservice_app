
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/authentication_controller.dart';
import 'package:multiservice_app/pages/authentication/sign_up_page.dart';

import '../../base/show_custom_message.dart';
import '../../models/sign_up_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class SignInPage extends StatelessWidget {

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController emailTextEditController = TextEditingController();
    TextEditingController passwordTextEditController = TextEditingController();

    void _login(AuthenticationPageController authController){

      var email = emailTextEditController.text.trim();
      var pwd = passwordTextEditController.text.trim();

      if(email.isEmpty){
        showCustomSnackBar("Type in your e-mail",title: "E-mail address");
      }else if(!GetUtils.isEmail(email)){
        showCustomSnackBar("Type in a correct e-mail",title: "E-mail address");
      }else if(pwd.isEmpty){
        showCustomSnackBar("Type in your password",title: "Password");
      }else if(pwd.length<6){
        showCustomSnackBar("Password must have at least 6 characters",title: "Password");
      }else{

        SignUpBody signUpBody = SignUpBody(name: "", phone: "", email: email, password: pwd);

        authController.login(signUpBody);

      }

    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<AuthenticationPageController>(builder: (controller){
          return !controller.isLoading ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: Dimensions.screenHeight * 0.05,),
                  Container(
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: Dimensions.radius20 * 4,
                        backgroundImage: AssetImage("assets/image/logo.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.screenHeight * 0.05,),
                  Container(
                    margin: EdgeInsets.only(left: Dimensions.width20),
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello",
                          style: TextStyle(
                              fontSize: Dimensions.font20*3.5,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SmallText(text: "Sign into your account",size: Dimensions.font20,)
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.screenHeight * 0.05,),
                  AppTextField(
                    textHint: "E-mail",
                    icon: Icons.email,
                    textEditingController: emailTextEditController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: Dimensions.height20,),
                  AppTextField(
                    textHint: "Password",
                    icon: Icons.password_sharp,
                    textEditingController: passwordTextEditController,
                    textInputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  SizedBox(height: Dimensions.height20,),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Sign into your account",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: Dimensions.font20
                                )
                            )
                        ),
                        SizedBox(width: Dimensions.width20,)
                      ]
                  ),

                  SizedBox(height: Dimensions.height20,),

                  GestureDetector(
                    onTap: (){
                      _login(controller);
                    },
                    child: Container(
                      width: Dimensions.screenWidth/2,
                      height: Dimensions.screenHeight/13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor
                      ),
                      child: Center(
                        child: BigText(
                          text: "Sign In",
                          size: Dimensions.font20*1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.screenHeight*0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: Dimensions.font20
                              ),
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>SignUpPage(),transition: Transition.fade),
                                    text: "Create",
                                    style: TextStyle(
                                      color: AppColors.mainBlackColor,
                                      fontSize: Dimensions.font20,
                                      fontWeight: FontWeight.bold,

                                    )
                                )
                              ]
                          )
                      )
                    ],
                  )
                ],
              )
          ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.mainColor,backgroundColor: Colors.white,),
              SizedBox(height: Dimensions.height20,),
              SmallText(text: "Autenticando usuario, por favor espere...")
            ],
          ));
        })
    );
  }
}
