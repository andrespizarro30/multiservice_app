import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/controllers/chat_controller.dart';
import 'package:multiservice_app/routes/routes_helper.dart';

import '../../utils/app_constants.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ChatPageController>(builder: (chatController){
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(AppConstants.FIRESTORE_USERS_COLLECTION).snapshots(),
          builder: (context,snapshot){

            return Scaffold(
              body: snapshot.hasError ?
                Center(child: const Text("Error...")) :
              snapshot.connectionState == ConnectionState.waiting ?
                Center(child: const Text("Cargando usuarios...")) :
              ListView(
                children: snapshot.data!.docs!
                    .map<Widget>((doc) => buildUserListItem(doc))
                    .toList(),
              ),
            );

          }
      );
    });

  }

  Widget buildUserListItem(DocumentSnapshot doc){

    Map<String,dynamic> data = doc.data()! as Map<String,dynamic>;

    if(FirebaseAuth.instance.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data["email"]),
        onTap: (){
          Get.toNamed(RouteHelper.getChatConversation(data['email'],data["uid"],data['token']));
        },
      );
    }else{
      return Container(

      );
    }

  }

}
