import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/main_api_client.dart';
import '../models/multiporpuse_job_detail_model.dart';
import '../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class MultiPorpusePageRepo extends GetxController implements GetxService{

  final MainApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final FirebaseStorage firebaseStorage;
  final FirebaseMessaging firebaseMessaging;
  final FirebaseAuth firebaseAuth;

  MultiPorpusePageRepo({
    required this.apiClient,
    required this.sharedPreferences,
    required this.firebaseStorage,
    required this.firebaseMessaging,
    required this.firebaseAuth
  });

  Future<Response> registerNewJob(MultiporpuseJobDetail multiporpuseJobDetail)async{

    String currentToken = sharedPreferences.getString(AppConstants.FIRESTORE_TOKENS) ?? "";
    multiporpuseJobDetail.JobToken = currentToken;
    multiporpuseJobDetail.JobUID = firebaseAuth.currentUser!.uid!;

    return await apiClient.postData(AppConstants.REGISTER_NEW_JOB_URI, multiporpuseJobDetail.toJson());
  }

  Future<Response> getMyRegisteredJobs()async{

    String jobUID = firebaseAuth.currentUser!.uid!;

    Map<String,String> data = {};

    data['JobUID'] = jobUID;

    return await apiClient.getDataWithQuery(AppConstants.MY_REGISTERED_JOBS_URI, data);

  }



  Future<bool> sendNotificationToTech(MultiporpuseJobDetail multiporpuseJobDetail) async{

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${AppConstants.FIREBASE_MESSAGING_AUTH_TOKEN}'
    };

    Map<String,dynamic> body = {
      "notification":{
        "body": "Requiriendo ${multiporpuseJobDetail.JobType}",
        "title": "Solicitud de servicio"
      },
      "priority": "high",
      "data": {
        "OrderNumber": multiporpuseJobDetail.OrderNumber,
        "JobType": multiporpuseJobDetail.JobType,
        "JobAddress": multiporpuseJobDetail.JobAddress,
        "JobLocation": multiporpuseJobDetail.JobLocation,
        "JobDescription": multiporpuseJobDetail.JobDescription,
        "FormType": multiporpuseJobDetail.FormType,
        "RequestedDate": multiporpuseJobDetail.RequestedDate,
        "JobUID": multiporpuseJobDetail.JobUID,
        "JobToken": multiporpuseJobDetail.JobToken
      },
      "to": "/topics/${multiporpuseJobDetail.TokenTopic}"
    };

    var bodyEncoded = json.encode(body);

    String url="https://fcm.googleapis.com/fcm/send";

    final response = await http.post(Uri.parse(url),headers: headers,body: bodyEncoded,encoding: Encoding.getByName('utf-8'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }

  }

}