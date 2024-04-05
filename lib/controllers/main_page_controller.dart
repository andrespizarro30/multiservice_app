
import 'package:get/get.dart';
import 'package:multiservice_app/utils/dimension.dart';

class MainPageController extends GetxController implements GetxService{


  double _addressRequestContainerHeight = 0;
  double get addressRequestContainerHeight => _addressRequestContainerHeight;

  bool _isOpenAddressRequestContainer = false;
  bool get isOpenAddressRequestContainer => _isOpenAddressRequestContainer;

  void openAdressRequestContainer(){

    _isOpenAddressRequestContainer = !isOpenAddressRequestContainer;

    _addressRequestContainerHeight = isOpenAddressRequestContainer ? Dimensions.screenHeight * 0.9 : 0;

    update();

  }

}