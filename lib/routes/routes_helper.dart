
import 'package:get/get.dart';
import 'package:multiservice_app/pages/main_menu_page.dart';
import 'package:multiservice_app/pages/main_page.dart';
import 'package:multiservice_app/pages/select_address_page.dart';

class RouteHelper{

  static const String mainMenu = "/mainMenu";
  static const String selectAddressPage = "/addressSelect";

  static List<GetPage> routes =[
    GetPage(name: mainMenu, page: ()=>MainPage()),
    GetPage(name: selectAddressPage, page: ()=>SelectAddressPage())
  ];
}