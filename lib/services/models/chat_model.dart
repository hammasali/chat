import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? senderId, receiverId, message, name, time;
  bool? isRead;
  Timestamp? timestamp;

  ChatModel(
      {this.senderId,
      this.receiverId,
      this.message,
      this.name,
      this.time,
      this.isRead,
      this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'name': name,
      'time': time,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      name: map['name'] as String,
      time: map['time'] as String,
      isRead: map['isRead'] as bool,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
