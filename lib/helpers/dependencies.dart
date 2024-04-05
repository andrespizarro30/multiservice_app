

import 'package:get/get.dart';
import 'package:multiservice_app/controllers/select_address_page_controller.dart';
import 'package:multiservice_app/repositories/google_map_repository.dart';

import '../apis/google_maps_api_client.dart';
import '../controllers/main_page_controller.dart';
import '../utils/app_constants.dart';

Future<void> init() async{

  //api client
  Get.lazyPut(()=>GoogleMapsApiClient(appBaseUrl: AppConstants.GOOGLE_MAPS_API_BASE_URL));

  //repos
  Get.lazyPut(()=>GoogleMapRepo(googleMapsApiClient: Get.find()));

  //controllers
  Get.lazyPut(()=>MainPageController());
  Get.lazyPut(()=>SelectAddressPageController(googleMapRepo: Get.find()));

}