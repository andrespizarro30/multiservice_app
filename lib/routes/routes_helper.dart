
import 'package:get/get.dart';
import 'package:multiservice_app/pages/authentication/sign_up_page.dart';
import 'package:multiservice_app/pages/chat/chat_conversation_page.dart';
import 'package:multiservice_app/pages/chat/chat_list_page.dart';
import 'package:multiservice_app/pages/main_pages/main_menu_page.dart';
import 'package:multiservice_app/pages/main_pages/main_page.dart';
import 'package:multiservice_app/pages/select_address/confirm_address_page.dart';
import 'package:multiservice_app/pages/select_address/search_address_page.dart';
import 'package:multiservice_app/pages/select_address/select_address_page.dart';

class RouteHelper{

  static const String mainMenu = "/mainMenu";
  static const String selectAddressPage = "/addressSelect";
  static const String confirmAddressPage = "/addressSelectConfirm";
  static const String searchAddressPage = "/searchSelectConfirm";
  static const String signUpPage = "/signUp";
  static const String chatListPage = "/chatList";
  static const String chatConversationPage = "/chatConversation";

  static String getMain()=>'$mainMenu';
  static String getSelectAddress()=>'$selectAddressPage';
  static String getConfirmAddress()=>'$confirmAddressPage';
  static String getSearchAddress()=>'$searchAddressPage';
  static String getSignUp()=>'$signUpPage';
  static String getChatList()=>'$chatListPage';
  static String getChatConversation(String receiverUserEmail, String receiverUserID, String token)=>'$chatConversationPage?receiverUserEmail=$receiverUserEmail&receiverUserID=$receiverUserID&token=$token';
  //static String getPopularFood(int pageId,String page)=>'$popularFood?pageId=$pageId&page=$page';
  //static String getRecommendedFood(int pageId,String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  //static String getDrinks(int pageId,String page)=>'$drinks?pageId=$pageId&page=$page';

  static List<GetPage> routes =[
    GetPage(name: mainMenu, page: ()=>MainPage()),
    GetPage(name: selectAddressPage, page: ()=>SelectAddressPage()),
    GetPage(name: confirmAddressPage, page: ()=>ConfirmAddressPage()),
    GetPage(name: searchAddressPage, page: ()=>SearchAddressPage()),
    GetPage(name: signUpPage, page: ()=>SignUpPage()),
    GetPage(name: chatListPage, page: ()=>ChatListPage()),
    GetPage(
        name: chatConversationPage,
        page: (){
          var receiverUserEmail = Get.parameters['receiverUserEmail'];
          var receiverUserID = Get.parameters['receiverUserID'];
          var token = Get.parameters['token'];
          return ChatConversationPage(receiverUserEmail: receiverUserEmail!,receiverUserID: receiverUserID!, receiverToken: token!,);
        }
    ),
  ];
}