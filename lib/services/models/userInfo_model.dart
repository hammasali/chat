import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  final String email;
  final bool status;
  final Timestamp timestamp;

  UserInfoModel(
      {required this.email, required this.timestamp, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory UserInfoModel.fromMap(Map<String, dynamic> map) {
    return UserInfoModel(
      email: map['email'] as String,
      status: map['status'] as bool,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
