
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/utils/dimension.dart';

import '../models/address_details_model.dart';
import '../repositories/main_page_repository.dart';

class MainPageController extends GetxController implements GetxService{

  MainPageRepo mainPageRepo;

  MainPageController({
    required this.mainPageRepo
  });


  double _addressRequestContainerHeight = 0;
  double get addressRequestContainerHeight => _addressRequestContainerHeight;

  bool _isOpenAddressRequestContainer = false;
  bool get isOpenAddressRequestContainer => _isOpenAddressRequestContainer;

  double _deleteAddressRequestContainerHeight = 0;
  double get deleteAddressRequestContainerHeight => _deleteAddressRequestContainerHeight;

  bool _isOpenDeleteAddressRequestContainer = false;
  bool get isOpenDeleteAddressRequestContainer => _isOpenDeleteAddressRequestContainer;

  List<AddressDetailModel> _addressSaved = [];
  List<AddressDetailModel> get addressSaved => _addressSaved;

  AddressDetailModel _currentAddressDetailModel = AddressDetailModel();
  AddressDetailModel get currentAddressDetailModel => _currentAddressDetailModel;

  List<bool> _isReadyToDelete = [];
  List<bool> get isReadyToDelete => _isReadyToDelete;

  void openAdressRequestContainer(){

    _isOpenAddressRequestContainer = !isOpenAddressRequestContainer;

    _addressRequestContainerHeight = isOpenAddressRequestContainer ? Dimensions.screenHeight * 0.7 : 0;

    update();

  }

  void openDeleteAdressRequestContainer(){

    _isOpenDeleteAddressRequestContainer = !_isOpenDeleteAddressRequestContainer;

    _deleteAddressRequestContainerHeight = _isOpenDeleteAddressRequestContainer ? Dimensions.screenHeight * 0.35 : 0;

    update();

  }

  Future<void> getSavedAddress() async{

    _addressSaved = await mainPageRepo.getSavedAddress();

    _isReadyToDelete = [];

    _addressSaved.forEach((element) {
      _isReadyToDelete.add(false);
    });

    update();

  }

  void selectCurrentAddress(int index) async{

    mainPageRepo.selectCurrentAddress(index);

    await getSavedAddress();

  }

  void getCurrentAddress() async{

    _currentAddressDetailModel = await mainPageRepo.getCurrentAddress();

    update();

  }

  void getCurrentAddressInfo() async{

    _currentAddressDetailModel = await mainPageRepo.getCurrentAddress();

  }

  void updateIfReadyToDelete(int index,bool isReady){

    _isReadyToDelete = [];

    _addressSaved.forEach((element) {
      _isReadyToDelete.add(false);
    });

    _isReadyToDelete[index] = isReady;
    update();
  }

  void deleteSpecificAddress() async{

    int index = 0;
    _isReadyToDelete.forEach((element) {
      if(element){
        mainPageRepo.deleteSpecificAddress(index);
      }
      index += 1;
    });

    await getSavedAddress();

  }

  void setLocationUpdates(){

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
      timeLimit: Duration(milliseconds: 600000)
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((position) {
      print(position == null ? 'Unknown' : '${position.latitude},${position.longitude}');
    });

  }


}