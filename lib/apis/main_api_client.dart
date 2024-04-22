import 'package:get/get.dart';

import '../utils/app_constants.dart';

class MainApiClient extends GetConnect implements GetxService{

  late String token;
  final String appBaseUrl;
  late Map<String,String> mainHeaders;

  MainApiClient({required this.appBaseUrl}){
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = AppConstants.TOKEN;
    mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization':'Bearer $token'
    };
  }

  void updateHeader(String token){

    this.token = token;

    this.mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization':'Bearer $token'
    };
  }

  Future<Response> getData(String uri) async{

    try{
      Response response = await get(uri);
      return response;
    }catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }

  }

  Future<Response> getDataWithQuery(String uri, dynamic query) async{

    try{
      Response response = await get(uri,query: query);
      return response;
    }catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }

  }

  Future<Response> postData(String uri, dynamic body) async{
    try{
      Response response = await post(uri, body, headers: mainHeaders);
      return response;
    }catch(e){
      print(e.toString());
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}