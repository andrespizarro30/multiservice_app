
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:multiservice_app/repositories/chat_repository.dart';

class ChatPageController extends GetxController implements GetxService{

  final ChatRepo chatRepo;

  ChatPageController({
    required this.chatRepo
  });

  Future<void> sendMessage(String receiverId,String message, String receiverToken) async{

    await chatRepo.sendMessage(receiverId, message, receiverToken);

  }

  Stream<QuerySnapshot> getMessage(String currentUserId,String receiverId){

    return chatRepo.getMessage(currentUserId, receiverId);

  }


}