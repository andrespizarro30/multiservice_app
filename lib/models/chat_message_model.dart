
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel{
  String senderId;
  String senderEmail;
  String receiverId;
  String message;
  Timestamp timestamp;

  ChatMessageModel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['senderEmail'] = this.senderEmail;
    data['receiverId'] = this.receiverId;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    return data;
  }


}