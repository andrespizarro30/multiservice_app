import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/chat_controller.dart';
import 'package:multiservice_app/routes/routes_helper.dart';
import 'package:multiservice_app/utils/dimension.dart';

import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/small_text.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(AppConstants.FIRESTORE_USERS_COLLECTION).snapshots(),
        builder: (context,snapshot){
          return GetBuilder<ChatPageController>(builder: (chatController){
            return Scaffold(
              body: snapshot.hasError ?
              Center(child: const Text("Error...")) :
              snapshot.connectionState == ConnectionState.waiting ?
              Center(child: const Text("Cargando usuarios...")) :
              Padding(
                padding: EdgeInsets.only(top: Dimensions.height20),
                child: ListView(
                  children: snapshot.data!.docs!
                      .map<Widget>((doc) => buildUserListItem(doc,chatController))
                      .toList(),
                ),
              ),
            );
          });
        }
    );

  }

  Widget buildUserListItem(DocumentSnapshot doc, ChatPageController chatController){

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    Map<String,dynamic> data = doc.data()! as Map<String,dynamic>;

    List<String> ids = [firebaseAuth.currentUser!.uid,data["uid"]];
    ids.sort();
    String chatRoomId = ids.join("_");

    if(FirebaseAuth.instance.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data["email"]),
        onTap: (){
          chatController.setToZeroPendingMessageNumber(chatRoomId);
          Get.toNamed(RouteHelper.getChatConversation(data['email'],data["uid"],data['token']));
        },
        trailing: SizedBox(
          height: Dimensions.height30,
          width: Dimensions.width40,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                chatController.sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId") ?
                Positioned(
                    right: 0,
                    bottom: 1,
                    child: ApplIcon(
                      icon: Icons.circle,
                      size: 20,
                      iconColor: Colors.transparent,
                      backgroundColor: AppColors.mainColor,
                    )
                ) :
                Container(),
                chatController.sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId") ?
                Positioned(
                  right: 3,
                  bottom: 4,
                  child: SmallText(
                    text: chatController.sharedPreferences.getInt("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId").toString(),
                    color: Colors.white,
                    size: 12,
                  ),
                ) :
                Container()
              ],
            ),
          ),
        )
      );
    }else{
      return Container(

      );
    }

  }

}
