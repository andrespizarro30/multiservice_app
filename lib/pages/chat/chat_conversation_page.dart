import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:multiservice_app/controllers/chat_controller.dart';
import 'package:multiservice_app/utils/colors.dart';
import 'package:multiservice_app/utils/dimension.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/chat_bubble.dart';

class ChatConversationPage extends StatelessWidget {

  String receiverUserEmail;
  String receiverUserID;
  String receiverToken;

  ChatConversationPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
    required this.receiverToken
  });

  TextEditingController messageController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ScrollController listScrollController = ScrollController();

  SharedPreferences sharedPreferences = Get.find();

  void loadMessages(){
    Get.find<ChatPageController>().getNewMessages(FirebaseAuth.instance.currentUser!.uid, receiverUserID);
  }

  Future<bool> _onWillPop() async {
    Get.find<ChatPageController>().stopListening(FirebaseAuth.instance.currentUser!.uid, receiverUserID);
    sharedPreferences.setString(AppConstants.CURRENTPAGE, "");
    return true;
  }

  @override
  Widget build(BuildContext context){

    List<String> ids = [firebaseAuth.currentUser!.uid,receiverUserID];
    ids.sort();
    String chatRoomId = ids.join("_");

    sharedPreferences.setString(AppConstants.CURRENTPAGE, "chat_conversation");

    SchedulerBinding.instance.addPostFrameCallback((_) {
      loadMessages();
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GetBuilder<ChatPageController>(builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: BigText(text: receiverUserEmail,),
            backgroundColor: AppColors.mainColor,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: buildMessageList(controller,firebaseAuth,receiverUserID,listScrollController)
                  ),
                  buildMessageInput(controller,messageController)
                ],
              ),
              Positioned(
                  bottom: Dimensions.height40 * 3,
                  right: Dimensions.width20,
                  child: Stack(
                    children: [
                      FloatingActionButton.small(
                        onPressed: (){
                          if (listScrollController.hasClients) {
                            final position = listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                            controller.setToZeroPendingMessageNumber(chatRoomId);
                          }
                        },
                        child: Icon(Icons.arrow_downward,color: Colors.white,),
                        backgroundColor: Colors.lightBlue,
                      ),
                      controller.sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId") ?
                      Positioned(
                          right: 0,
                          top: 0,
                          child: ApplIcon(
                            icon: Icons.circle,
                            size: 20,
                            iconColor: Colors.transparent,
                            backgroundColor: AppColors.mainColor,
                          )
                      ) :
                      Container(),
                      controller.sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId") ?
                      Positioned(
                        right: 3,
                        top: 3,
                        child: SmallText(
                          text: controller.sharedPreferences.getInt("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId").toString(),
                          color: Colors.white,
                          size: 12,
                        ),
                      ) :
                      Container()
                    ],
                  )
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildMessageList(ChatPageController controller,FirebaseAuth firebaseAuth,String receiverUserID,ScrollController listScrollController){


    return controller.isLoading ?
    Center(child: Container(
      child: Column(
        children: [
          CircularProgressIndicator(
            color: AppColors.mainColor,
          ),
          const Text("Cargando mensajes...")
        ],
      ),
    )) :
    controller.documents.isEmpty ?
    Center(child: const Text("No tiene mensajes aún")) :
    ListView(
      controller: listScrollController,
      children: controller.documents.isNotEmpty ?
      List.generate(controller.documents.length, (index){
        return buildMessageItem(firebaseAuth,controller.documents[index],listScrollController);
      })
          :
      List.generate(1, (index) => Container()),
    );

    /*
    return FutureBuilder(
        future: controller.getAllMessages(firebaseAuth.currentUser!.uid, receiverUserID),
        initialData: [],
        builder: (context,documents){
          return documents.hasError ?
          Center(child: const Text("Error...")) :
          documents.connectionState == ConnectionState.waiting ?
          Center(child: const Text("Cargando mensajes...")) :
          ListView(
            controller: listScrollController,
            children: documents.data != null ?
            List.generate(documents.data!.length, (index){
              return buildMessageItem(firebaseAuth,documents.data![index],listScrollController);
            })
                :
            List.generate(1, (index) => Container()),
          );
        }
    );
    */

    /*
    return StreamBuilder(
        stream: controller.getMessage(firebaseAuth.currentUser!.uid, receiverUserID),
        builder: (context,snapshot){
          return snapshot.hasError ?
          Center(child: const Text("Error...")) :
          snapshot.connectionState == ConnectionState.waiting ?
          Center(child: const Text("Cargando mensajes...")) :
          ListView(
            controller: listScrollController,
            children: snapshot.data != null ?
              snapshot.data!.docs!.map<Widget>((doc){
                return buildMessageItem(firebaseAuth,doc,listScrollController);
              }).toList() :
              List.generate(1, (index) => Container()),
          );
        }
    );
    */
  }

  Widget buildMessageItem(FirebaseAuth firebaseAuth,DocumentSnapshot document,ScrollController listScrollController){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;

    var alignment = (data["senderId"] == firebaseAuth.currentUser!.uid) ?
      Alignment.centerRight :
      Alignment.centerLeft;

    var bubbleColor = (data["senderId"] == firebaseAuth.currentUser!.uid) ?
      AppColors.mainColor :
      AppColors.paraColor;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          ChatBubble(message: data['message'],bubbleColor: bubbleColor,),
        ],
      ),
    );

  }

  Widget buildMessageInput(ChatPageController controller, TextEditingController messageController){
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10,left: Dimensions.width20),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Ingrese su mensaje"
                ),
              )
          ),
          IconButton(
            onPressed: (){
              sendMessage(controller, messageController);
            },
            icon: const Icon(Icons.near_me, size: 40,)
          )
        ],
      ),
    );
  }

  void sendMessage(ChatPageController controller,TextEditingController messageController) async{
    if(messageController.text.isNotEmpty){
      await controller.sendMessage(receiverUserID, messageController.text, receiverToken);
      messageController.clear();
    }
  }
}
