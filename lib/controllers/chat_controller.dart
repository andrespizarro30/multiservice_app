import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/repositories/chat_repository.dart';
import 'package:multiservice_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPageController extends GetxController implements GetxService{

  final ChatRepo chatRepo;
  SharedPreferences sharedPreferences;

  ChatPageController({
    required this.chatRepo,
    required this.sharedPreferences
  });

  Stream<QuerySnapshot<Object?>> _chatListStream = Stream.empty();
  Stream<QuerySnapshot<Object?>> get chatListStream => _chatListStream;

  List<DocumentSnapshot> _documents = [];
  List<DocumentSnapshot> get documents => _documents;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isFirstLoadDone = false;

  late StreamSubscription<QuerySnapshot> streamSub;

  Future<void> sendMessage(String receiverId,String message, String receiverToken) async{

    await chatRepo.sendMessage(receiverId, message, receiverToken);

  }

  Stream<QuerySnapshot<Object?>> getMessage(String currentUserId,String receiverId){

    _chatListStream = chatRepo.getMessage(currentUserId, receiverId);

    return _chatListStream;

  }

  void getAllMessages(String currentUserId,String receiverId) async{

    _isLoading = true;

    update();

    _documents = await chatRepo.getAllMessages(currentUserId, receiverId);

    _isLoading = false;

    getNewMessages(currentUserId, receiverId);

    isFirstLoadDone = true;

    update();

  }

  void getNewMessages(String currentUserId,String receiverId){

    _isLoading = true;

    update();

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    Stream<QuerySnapshot> snapShots = FirebaseFirestore.instance
        .collection(AppConstants.FIRESTORE_CHAT_COLLECTION)
        .doc(chatRoomId)
        .collection(AppConstants.FIRESTORE_CHAT_MESSAGES_COLLECTION)
        .orderBy("timestamp",descending: false)
        .snapshots();

    _documents = [];

    streamSub = snapShots.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if(change.type == DocumentChangeType.added){
          _documents.add(change.doc);
        }
      });
      _isLoading = false;
      update();
    });

    /*
    snapShots.forEach((element) {
      element.docChanges.forEach((change) {
        if(change.type == DocumentChangeType.added){
          _documents.add(change.doc);
        }
      });
      _isLoading = false;
      update();
    });
    */
  }

  void stopListening(String currentUserId,String receiverId){
    streamSub.cancel();
  }

  void setPendingMessageNumber(String currentUserId,String receiverId){

    List<String> ids = [currentUserId,receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    if(sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId")){
      int pendingMessageNumber = sharedPreferences.getInt("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId")! + 1;
      sharedPreferences.remove("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId");
      sharedPreferences.setInt("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId",pendingMessageNumber);
    }else{
      sharedPreferences.setInt("${AppConstants.PENDINGMESSAGESCOUNT}_${chatRoomId}", 1);
    }

    if(sharedPreferences.containsKey(AppConstants.CURRENTPAGE)){
      if(sharedPreferences.getString(AppConstants.CURRENTPAGE)!="chat_conversation"){
        update();
      }
    }

  }

  int getPendingMessages(String chatRoomId){
    return sharedPreferences.getInt("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId")!;
  }

  void setToZeroPendingMessageNumber(String chatRoomId){

    if(sharedPreferences.containsKey("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId")){
      sharedPreferences.remove("${AppConstants.PENDINGMESSAGESCOUNT}_$chatRoomId");
    }

  }


}