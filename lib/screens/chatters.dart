import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:chat/const/app_const.dart';
import 'package:chat/const/colors.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:chat/widgets/chatter_widget.dart';
import 'package:chat/widgets/recent_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatters extends StatelessWidget {
  static const routeName = "/chatters";


  Chatters({Key? key}) : super(key: key);
  final fetchGlobalUsers =
      FirebaseRepo.instance.fetchUsers().snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.orange,
      appBar: AppBar(
        backgroundColor: AppColor.orange,
        elevation: 0.0,
        centerTitle: true,
        title: const Center(
          child: Text(
            "Global",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout_sharp),
              color: Colors.transparent,
              onPressed: () {})
        ],
      ),
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              )),
          child: StreamBuilder<QuerySnapshot>(
              stream: fetchGlobalUsers,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: getCircularProgress()),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error_outline);
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    AppConst.chatRoomWillBeHere,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        letterSpacing: 1.1, fontStyle: FontStyle.normal),
                  ));
                } else {
                  return ChatterX(docs: snapshot.data!.docs);
                }
              }),
        ),
      ),
    );
  }
}
