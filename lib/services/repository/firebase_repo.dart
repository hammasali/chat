import 'package:chat/services/providers/firebase_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepo {
  static final FirebaseRepo instance = FirebaseRepo._instance();

  FirebaseRepo._instance();

  final FirebaseMethod _firebaseMethod = FirebaseMethod();

  /// =========== AUTH ================

  Future<bool> authSignIn() async => await _firebaseMethod.isSignedIn();

  Future<void> signOutUser() async => await _firebaseMethod.signOutUser();

  User? getCurrentUser() => _firebaseMethod.getCurrentUser();

  Future<User?> createUser(String email, String password) async =>
      await _firebaseMethod.createUser(email, password);

  Future<User?> signInUser(String email, String password) async =>
      await _firebaseMethod.signInUser(email, password);

  /// =============== DATABASE ==============

  Future<void> addNewUserData(var model) async =>
      await _firebaseMethod.addNewUserData(model);

  Future<void> updateStatus(bool val) async =>
      await _firebaseMethod.updateStatus(val);

  DocumentReference getUpdateStatus(String id) =>
      _firebaseMethod.getUpdateStatus(id);

  Future<void> addMessageToDB(
          {String? message,
          String? receiverId,
          String? senderName,
          String? receiverName}) async =>
      _firebaseMethod.addMessageToDB(
          message, receiverId, senderName, receiverName);

  Query fetchUserChatRoom() => _firebaseMethod.fetchUserChatRoom();

  Query fetchUserChat(String? uid) => _firebaseMethod.fetchUserChat(uid);

  Query fetchUsers() => _firebaseMethod.fetchUsers();

  Future<void> updateReadMsg(String receiverId) async =>
      await _firebaseMethod.updateReadMsg(receiverId);

  DocumentReference getSeenMsgStatus(String receiverId) =>
      _firebaseMethod.getSeenMsgStatus(receiverId);
}
