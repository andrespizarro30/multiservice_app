import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:multiservice_app/controllers/chat_controller.dart';
import 'package:multiservice_app/utils/colors.dart';
import 'package:multiservice_app/widgets/big_text.dart';
import 'package:multiservice_app/widgets/small_text.dart';

import '../../widgets/chat_bubble.dart';

class ChatConversationPage extends StatelessWidget {

  String receiverUserEmail;
  String receiverUserID;

  ChatConversationPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID
  });

  @override
  Widget build(BuildContext context) {

    TextEditingController messageController = TextEditingController();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return GetBuilder<ChatPageController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: BigText(text: receiverUserEmail,),
          backgroundColor: AppColors.mainColor,
        ),
        body: Column(
          children: [
            Expanded(
                child: buildMessageList(controller,firebaseAuth,receiverUserID)
            ),
            buildMessageInput(controller,messageController)
          ],
        ),
      );
    });
  }

  Widget buildMessageList(ChatPageController controller,FirebaseAuth firebaseAuth,String receiverUserID){
    return StreamBuilder(
        stream: controller.getMessage(firebaseAuth.currentUser!.uid, receiverUserID),
        builder: (context,snapshot){
          return snapshot.hasError ?
          Center(child: const Text("Error...")) :
          snapshot.connectionState == ConnectionState.waiting ?
          Center(child: const Text("Cargando mensajes...")) :
          ListView(
            children: snapshot.data!.docs!
                .map<Widget>((doc) => buildMessageItem(firebaseAuth,doc))
                .toList(),
          );
        }
    );
  }

  Widget buildMessageItem(FirebaseAuth firebaseAuth,DocumentSnapshot document){
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
    return Row(
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
    );
  }

  void sendMessage(ChatPageController controller,TextEditingController messageController) async{
    if(messageController.text.isNotEmpty){
      await controller.sendMessage(receiverUserID, messageController.text);
      messageController.clear();
    }
  }

}
