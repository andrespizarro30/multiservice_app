
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/main_api_client.dart';
import '../models/multiporpuse_job_detail_model.dart';
import '../utils/app_constants.dart';

class MultiPorpusePageRepo extends GetxController implements GetxService{

  final MainApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final FirebaseStorage firebaseStorage;

  MultiPorpusePageRepo({
    required this.apiClient,
    required this.sharedPreferences,
    required this.firebaseStorage
  });

  Future<Response> registerNewJob(MultiporpuseJobDetail multiporpuseJobDetail)async{
    return await apiClient.postData(AppConstants.REGISTER_NEW_JOB_URI, multiporpuseJobDetail.toJson());
  }

}