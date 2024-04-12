
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/main_api_client.dart';
import '../utils/app_constants.dart';

class MainMenuPageRepo{

  final MainApiClient apiClient;
  final SharedPreferences sharedPreferences;

  MainMenuPageRepo({
    required this.apiClient,
    required this.sharedPreferences
  });

  Future<Response> getServicesList() async {

    return await apiClient.getData(AppConstants.SERVICES_LIST_URI);

  }

  Future<Response> getAdvertisingList() async {

    return await apiClient.getData(AppConstants.ADVERTISING_LIST_URI);

  }

}