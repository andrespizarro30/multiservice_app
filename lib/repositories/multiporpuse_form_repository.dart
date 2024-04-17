
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/main_api_client.dart';

class MultiPorpusePageRepo{

  final MainApiClient apiClient;
  final SharedPreferences sharedPreferences;

  MultiPorpusePageRepo({
    required this.apiClient,
    required this.sharedPreferences
  });



}