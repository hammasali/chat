import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:chat/services/models/chat_model.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:chat/utils/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BuildMessages extends StatefulWidget {
  final List<QueryDocumentSnapshot<Object?>> docs;
  final String receiverID;

  const BuildMessages(this.docs, this.receiverID, {Key? key}) : super(key: key);

  @override
  BuildMessagesState createState() => BuildMessagesState();
}

class BuildMessagesState extends State<BuildMessages> {
  late bool isMe;
  ScrollController? _listController;
  var _currentUser;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _currentUser = FirebaseRepo.instance.getCurrentUser()!.uid;
  }

  @override
  void dispose() {
    _listController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.docs.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: Center(
            child: Text(
          'Send Your Greetings :)',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(letterSpacing: 1.1, fontStyle: FontStyle.normal),
        )),
      );
    } else {
      ///This is to get the bottom of list when new message arrives. It will call
      ///every time whenever the setState calls / UI change
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _listController!.animateTo(_listController!.position.maxScrollExtent,
            duration: const Duration(microseconds: 250),
            curve: Curves.easeInOut);
      });

      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: FadedSlideAnimation(
            beginOffset: const Offset(0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: ListView.builder(
              controller: _listController,
              itemCount: widget.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var data = ChatModel.fromMap(
                    widget.docs[index].data() as Map<String, dynamic>);

                final isSeen = FirebaseRepo.instance
                    .getSeenMsgStatus(data.receiverId.toString());
                isMe = data.senderId == _currentUser;

                if (data.senderId != _currentUser &&
                    (index == widget.docs.length - 1)) {
                  FirebaseRepo.instance.updateReadMsg(widget.receiverID);
                }

                return FadedScaleAnimation(
                  child: Row(
                    children: [
                      isMe
                          ? StreamBuilder<DocumentSnapshot>(
                              stream: isSeen.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  Map<String, dynamic> _data = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  return Container(
                                      margin: EdgeInsets.only(
                                        left: (index == widget.docs.length - 1)
                                            ? 40.0
                                            : 60.0,
                                      ),
                                      child: (index == widget.docs.length - 1)
                                          ? Text(_data['isRead'] as bool
                                              ? 'seen'
                                              : 'sent')
                                          : const Text(''));
                                } else {
                                  return Container();
                                }
                              })
                          : Container(),
                      Expanded(
                        child: Container(
                          width: Helper.getScreenWidth(context) * 0.75,
                          margin: isMe
                              ? const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 10.0)
                              : const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, right: 80.0),
                          decoration: BoxDecoration(
                              color: isMe
                                  ? Theme.of(context).colorScheme.secondary
                                  : const Color(0xFFFFEFEE),
                              borderRadius: isMe
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0))
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.time as String,
                                style: const TextStyle(color: Colors.black38),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                data.message as String,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
  }
}
