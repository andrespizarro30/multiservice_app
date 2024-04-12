

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/apis/main_api_client.dart';
import 'package:multiservice_app/controllers/authentication_controller.dart';
import 'package:multiservice_app/controllers/chat_controller.dart';
import 'package:multiservice_app/controllers/main_menu_page_controller.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';
import 'package:multiservice_app/repositories/authentication_repository.dart';
import 'package:multiservice_app/repositories/chat_repository.dart';
import 'package:multiservice_app/repositories/google_map_repository.dart';
import 'package:multiservice_app/repositories/main_menu_repository.dart';
import 'package:multiservice_app/repositories/main_page_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/google_maps_api_client.dart';
import '../controllers/main_page_controller.dart';
import '../utils/app_constants.dart';

Future<void> init() async{

  final sharedPreferences = await SharedPreferences.getInstance();

  //Shared preferences
  Get.lazyPut(()=> sharedPreferences);

  //Firebase instances
  final firebaseAuth = FirebaseAuth.instance;
  Get.lazyPut(()=> firebaseAuth);

  final firebaseStore = FirebaseFirestore.instance;
  Get.lazyPut(()=> firebaseStore);

  final firebaseMessaging = FirebaseMessaging.instance;
  Get.lazyPut(()=> firebaseMessaging);

  //api client
  Get.lazyPut(()=>MainApiClient(appBaseUrl: AppConstants.BASE_URL));
  Get.lazyPut(()=>GoogleMapsApiClient(appBaseUrl: AppConstants.GOOGLE_MAPS_API_BASE_URL));

  //repos
  Get.lazyPut(()=>MainPageRepo(sharedPreferences: Get.find()));
  Get.lazyPut(()=>GoogleMapRepo(googleMapsApiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(()=>AuthenticationRepo(firebaseAuth: Get.find(), firebaseFirestore: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(()=>ChatRepo(firebaseAuth: Get.find(),firebaseFirestore: Get.find(), firebaseMessaging: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(()=>MainMenuPageRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //controllers
  Get.lazyPut(()=>MainPageController(mainPageRepo: Get.find()));
  Get.lazyPut(()=>SelectAddressPageController(googleMapRepo: Get.find()));
  Get.lazyPut(()=>AuthenticationPageController(authRepo: Get.find()));
  Get.lazyPut(()=>ChatPageController(chatRepo: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(()=>MainMenuPageController(mainPageRepo: Get.find()));

}