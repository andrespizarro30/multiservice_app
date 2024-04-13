import 'package:get/get.dart';
import 'package:multiservice_app/apis/main_api_client.dart';
import 'package:multiservice_app/models/services_type_model.dart';
import 'package:multiservice_app/repositories/main_menu_repository.dart';
import 'package:multiservice_app/repositories/main_page_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/advertising_info_model.dart';

class MainMenuPageController extends GetxController implements GetxService{

  final MainMenuPageRepo mainPageRepo;

  MainMenuPageController({
    required this.mainPageRepo
  });

  bool _isLoaded = false;
  bool get isLoaded =>_isLoaded;

  List<ServicesList> _servicesTypeList = [];
  List<ServicesList> get servicesTypeList => _servicesTypeList;

  List<Advertising> _advertisingList = [];
  List<Advertising> get advertisingList => _advertisingList;

  bool _isServicesLoad = false;
  bool get isServicesLoad => _isServicesLoad;

  bool _isAdsLoad = false;
  bool get isAdsLoad => _isAdsLoad;

  Future<List<ServicesList>> getServicesList()async{

    _servicesTypeList=[];

    Response response = await mainPageRepo.getServicesList();
    if(response.statusCode == 200){
      _servicesTypeList.addAll(ServicesType.fromJson(response.body).servicesList);
      _isServicesLoad = true;
    }else{

    }

    return _servicesTypeList;

  }

  Future<List<Advertising>> getAdvertisingList()async{

    _advertisingList=[];

    Response response = await mainPageRepo.getAdvertisingList();
    if(response.statusCode == 200){
      _advertisingList.addAll(AdvertisingList.fromJson(response.body).advertisingList);
      _isAdsLoad = true;
    }else{

    }

    return _advertisingList;

  }

}