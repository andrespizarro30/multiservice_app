
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel{
  String? senderId;
  String? senderEmail;
  String? receiverId;
  String? message;
  Timestamp? timestamp;
  String? token;

  ChatMessageModel({
    this.senderId,
    this.senderEmail,
    this.receiverId,
    this.message,
    this.timestamp,
    this.token
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    senderEmail = json['senderEmail'];
    receiverId = json['receiverId'];
    message = json['message'];

    //Example of timestamp received from push message ex. Timestamp(seconds=1712789257, nanoseconds=248843000)
    //conversion done to the right format
    String timeStampStr = json['timestamp'].toString()
        .replaceAll("Timestamp(seconds=", "")
        .replaceAll(" nanoseconds=", "")
        .replaceAll(")", "");

    List<String> timeStampList = timeStampStr.split(",");
    timestamp = Timestamp(int.parse(timeStampList[0]), int.parse(timeStampList[1]));

    token = json['token'];
  }

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