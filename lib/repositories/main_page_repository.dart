
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/address_details_model.dart';
import '../utils/app_constants.dart';

class MainPageRepo{

  final SharedPreferences sharedPreferences;

  MainPageRepo({
    required this.sharedPreferences
  });

  Future<List<AddressDetailModel>> getSavedAddress() async{

    List<String> addressSaved = [];
    List<AddressDetailModel> listAddressDetail = [];

    if(sharedPreferences.containsKey(AppConstants.ADDRESSSAVED)){
      addressSaved = sharedPreferences.getStringList(AppConstants.ADDRESSSAVED)!;
      for (var element in addressSaved) {
        listAddressDetail.add(AddressDetailModel.fromJson(json.decode(element)));
      }
    }

    return listAddressDetail;

  }

  void selectCurrentAddress(int index){

    List<String> addressSaved = [];
    List<AddressDetailModel> listAddressDetail = [];

    if(sharedPreferences.containsKey(AppConstants.ADDRESSSAVED)){
      addressSaved = sharedPreferences.getStringList(AppConstants.ADDRESSSAVED)!;
      for (var element in addressSaved) {
        listAddressDetail.add(AddressDetailModel.fromJson(json.decode(element)));
      }

      AddressDetailModel addressDetailModel_0 = listAddressDetail[index];

      listAddressDetail.removeAt(index);

      listAddressDetail.insert(0, addressDetailModel_0);

      addressSaved = [];

      listAddressDetail.forEach((element) {
        addressSaved.add(json.encode(element.toJson()));
      });


      sharedPreferences.setStringList(AppConstants.ADDRESSSAVED, addressSaved);

    }
  }

  Future<AddressDetailModel> getCurrentAddress() async{

    List<String> addressSaved = [];
    AddressDetailModel addressDetailModel = AddressDetailModel();
    if(sharedPreferences.containsKey(AppConstants.ADDRESSSAVED)){
      addressSaved = sharedPreferences.getStringList(AppConstants.ADDRESSSAVED)!;
      addressDetailModel = AddressDetailModel.fromJson(json.decode(addressSaved[0]));
    }

    return addressDetailModel;

  }

  void deleteSpecificAddress(int index){

    List<String> addressSaved = [];

    if(sharedPreferences.containsKey(AppConstants.ADDRESSSAVED)){

      addressSaved = sharedPreferences.getStringList(AppConstants.ADDRESSSAVED)!;

      addressSaved.removeAt(index);

      sharedPreferences.remove(AppConstants.ADDRESSSAVED);

      sharedPreferences.setStringList(AppConstants.ADDRESSSAVED, addressSaved);
    }

  }

}