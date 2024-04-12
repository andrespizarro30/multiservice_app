
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:multiservice_app/models/chat_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

import 'package:http/http.dart' as http;

class ChatRepo{

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  FirebaseMessaging firebaseMessaging;
  SharedPreferences sharedPreferences;

  ChatRepo({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseMessaging,
    required this.sharedPreferences,
  });

  List<DocumentSnapshot> _documents = [];
  List<DocumentSnapshot> get documents => _documents ;

  Future<void> sendMessage(String receiverId,String message,String receiverToken) async{

    final String currentUserId = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    final String myToken = sharedPreferences.getString(AppConstants.FIRESTORE_TOKENS)!;

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

    firebaseFirestore.collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION)
        .add(chatMessageModel.toJson()).then((value) async{

          if(value != null){

            final headers = {
              'content-type': 'application/json',
              'Authorization': 'key=${AppConstants.FIREBASE_MESSAGING_AUTH_TOKEN}'
            };

            Map<String,dynamic> body = {
              "notification":{
                "body": message,
                "title": currentUserEmail
              },
              "priority": "high",
              "data": {
                "senderId": chatMessageModel.senderId,
                "senderEmail": chatMessageModel.senderEmail,
                "receiverId": chatMessageModel.receiverId,
                "message": chatMessageModel.message,
                "timestamp": chatMessageModel.timestamp.toString(),
                "token": myToken
              },
              "to": receiverToken
            };

            var bodyEncoded = json.encode(body);

            String url="https://fcm.googleapis.com/fcm/send";

            final response = await http.post(Uri.parse(url),headers: headers,body: bodyEncoded,encoding: Encoding.getByName('utf-8'));

            if (response.statusCode == 200) {
              return true;
            } else {
              return false;
            }

          }

    });


  }

  Stream<QuerySnapshot> getMessage(String currentUserId,String receiverId){

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    Stream<QuerySnapshot> snapShots = firebaseFirestore
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION)
        .orderBy("timestamp",descending: false)
        .snapshots();

    snapShots.forEach((element) {
      element.docChanges.forEach((element) {
        if(element.type == DocumentChangeType.added){
          element.doc;
        }
      });
    });

    return snapShots;

  }

  Future<List<DocumentSnapshot<Object?>>> getAllMessages(String currentUserId,String receiverId) async{

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return await firebaseFirestore
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION).orderBy("timestamp",descending: false).get().then((value){

      _documents = [];

      value.docs.forEach((element) {
        _documents.add(element);
      });

      return _documents;

    });

  }

  Future<List<DocumentSnapshot<Object?>>> getNewMessages(String currentUserId,String receiverId) async{

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return await firebaseFirestore
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION).orderBy("timestamp",descending: false).get().then((value){

      _documents = [];

      value.docChanges.forEach((change) {

        if (change.type == DocumentChangeType.added) {
          _documents.add(change.doc);
        }
        if (change.type == DocumentChangeType.modified) {

        }
        if (change.type == DocumentChangeType.removed) {

        }

      });

      return _documents;

    });

  }



}