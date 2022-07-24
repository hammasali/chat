import 'package:flutter/material.dart';

import 'colors.dart';

class AppConst {
  static const String invalidEmailError = 'Invalid email';
  static const String invalidPassError = ' 1 Upper case, 1 Lowercase, 1 Digit';

  static const String users = 'users';
  static const String email = 'email';
  static const String status = 'status';
  static const String chats = 'chats';
  static const String chatUsers = 'chatUsers';
  static const String isRead = 'isRead';
  static const String timestamp = 'timestamp';

  static const String sendAMessageHint = 'Send a message...';
  static const String chatRoomWillBeHere = 'Chat room will be here.';


}

getCircularProgress() {
  return const Center(
    child: CircularProgressIndicator(
      color: AppColor.orange,
    ),
  );
}
