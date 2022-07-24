import 'package:chat/const/app_const.dart';
import 'package:chat/services/models/chat_model.dart';
import 'package:chat/services/models/userInfo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirebaseMethod {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  =========  Authentication State   ========== ///

  Future<bool> isSignedIn() async => _firebaseAuth.currentUser != null;

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> authenticateNewUser(String? email) async {
    final result = await Future.value(_firestore
        .collection(AppConst.users)
        .where(AppConst.email, isEqualTo: email)
        .get());

    return result.docs.isEmpty ? true : false;
  }

  ///  =========  Registration   ========== ///

  Future<User?> createUser(String email, String password) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return result.user;
  }

  Future<User?> signInUser(String email, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  ///  =========  Database  ========== ///
  Future<void> addNewUserData(UserInfoModel model) async {
    await _firestore
        .collection(AppConst.users)
        .doc(getCurrentUser()!.uid)
        .set(model.toMap());
  }

  Future<void> updateStatus(bool val) async => await _firestore
      .collection(AppConst.users)
      .doc(getCurrentUser()!.uid)
      .update({AppConst.status: val});

  DocumentReference getUpdateStatus(String id) =>
      _firestore.collection(AppConst.users).doc(id);

  DocumentReference getSeenMsgStatus(String receiverId) => _firestore
      .collection(AppConst.chats)
      .doc(getCurrentUser()!.uid)
      .collection(AppConst.chatUsers)
      .doc(receiverId);

  Future<void> addMessageToDB(String? message, String? receiverId,
      String? senderName, String? receiverName) async {
    String _currentUser = getCurrentUser()!.uid;
    Timestamp _timestamp = Timestamp.now();
    String _time = DateFormat('h:mm a').format(DateTime.now());

    ChatModel receiverModel = ChatModel(
        name: receiverName,
        time: _time,
        timestamp: _timestamp,
        message: message,
        receiverId: receiverId,
        isRead: false,
        senderId: _currentUser);

    ChatModel senderModel = ChatModel(
        name: senderName,
        time: _time,
        timestamp: _timestamp,
        message: message,
        receiverId: receiverId,
        isRead: false,
        senderId: _currentUser);

    // ================= ADDING TO CHAT ROOM =================
    await _firestore
        .collection(AppConst.chats)
        .doc(_currentUser)
        .collection(AppConst.chatUsers)
        .doc(receiverId)
        .set(receiverModel.toMap())
        .then((value) => _firestore
            .collection(AppConst.chats)
            .doc(receiverId)
            .collection(AppConst.chatUsers)
            .doc(_currentUser)
            .set(senderModel.toMap()));

    //  ================  ADDING MESSAGE TO DB  ================

    await _firestore
        .collection(AppConst.chats)
        .doc(_currentUser)
        .collection(receiverId!)
        .add(receiverModel.toMap())
        .then((value) => _firestore
            .collection(AppConst.chats)
            .doc(receiverId)
            .collection(_currentUser)
            .add(senderModel.toMap()));
  }

  Query fetchUserChatRoom() => _firestore
      .collection(AppConst.chats)
      .doc(getCurrentUser()!.uid)
      .collection(AppConst.chatUsers)
      .orderBy(AppConst.timestamp, descending: true);

  Query fetchUserChat(String? uid) => _firestore
      .collection(AppConst.chats)
      .doc(getCurrentUser()!.uid)
      .collection(uid!)
      .orderBy(AppConst.timestamp, descending: false);

  Query fetchUsers() => _firestore
      .collection(AppConst.users)
      .orderBy(AppConst.timestamp, descending: true);

  Future<void> updateReadMsg(String? receiverId) async {
    String _currentUser = getCurrentUser()!.uid;

    await _firestore
        .collection(AppConst.chats)
        .doc(_currentUser)
        .collection(AppConst.chatUsers)
        .doc(receiverId)
        .update({AppConst.isRead: true}).then((value) => _firestore
            .collection(AppConst.chats)
            .doc(receiverId)
            .collection(AppConst.chatUsers)
            .doc(_currentUser)
            .update({AppConst.isRead: true}));
  }
}
