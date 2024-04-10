
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiservice_app/models/chat_message_model.dart';

import '../utils/app_constants.dart';

class ChatRepo{

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  ChatRepo({
    required this.firebaseAuth,
    required this.firebaseFirestore
  });

  Future<void> sendMessage(String receiverId,String message) async{

    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    ChatMessageModel chatMessageModel = ChatMessageModel(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await firebaseFirestore
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION)
        .add(chatMessageModel.toJson());

  }

  Stream<QuerySnapshot> getMessage(String currentUserId,String receiverId){

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return firebaseFirestore
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION)
        .orderBy("timestamp",descending: false)
        .snapshots();

  }


}