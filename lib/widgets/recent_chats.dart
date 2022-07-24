import 'package:chat/const/colors.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/services/models/chat_args.dart';
import 'package:chat/services/models/chat_model.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key, required this.docs}) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> docs;

  @override
  RecentChatsState createState() => RecentChatsState();
}

class RecentChatsState extends State<RecentChats> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          )),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.docs.length,
          itemBuilder: (BuildContext context, int index) {
            ChatModel data = ChatModel.fromMap(
                widget.docs[index].data() as Map<String, dynamic>);

            var online =
                FirebaseRepo.instance.getUpdateStatus(widget.docs[index].id);

            final isRead;
            if (FirebaseRepo.instance.getCurrentUser()!.uid != data.senderId) {
              if (data.isRead as bool) {
                isRead = true;
              } else {
                isRead = false;
              }
            } else {
              isRead = true;
            }

            // print(
            //     'Current Id: ${FirebaseRepo.instance.getCurrentUser()!.uid} : Sender Id ${data.senderId}');
            // print(
            //     "isRead from firebase ${data.isRead} && Id : ${FirebaseRepo.instance.getCurrentUser()!.uid != data.senderId}");
            // // final isRead = data.isRead as bool &&
            // //     (FirebaseRepo.instance.getCurrentUser()!.uid != data.senderId);
            //
            // print('Condition: $isRead');
            return GestureDetector(
              onTap: () async => FirebaseRepo.instance.getCurrentUser()!.uid !=
                      data.senderId
                  ? FirebaseRepo.instance
                      .updateReadMsg(widget.docs[index].id)
                      .then((value) => Navigator.pushNamed(
                          context, ChatScreen.routeName,
                          arguments: ChatArgs(
                              data.name as String, widget.docs[index].id)))
                  : Navigator.pushNamed(context, ChatScreen.routeName,
                      arguments:
                          ChatArgs(data.name as String, widget.docs[index].id)),
              child: Container(
                margin:
                    const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 6.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: isRead ? Colors.white : const Color(0xFFFFEFEE),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //Profile picture
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 22.0,
                              backgroundColor: AppColor.placeholderBg,
                              child: Text(data.name
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase()),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: online.snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Positioned(
                                      right: 0.0,
                                      child: CircleAvatar(
                                        radius: 5.0,
                                        backgroundColor: data['status']
                                            ? Colors.green
                                            : Colors.blueGrey,
                                      ),
                                    );
                                  }
                                  return const Positioned(
                                    right: 0.0,
                                    child: CircleAvatar(
                                        radius: 5.0,
                                        backgroundColor: Colors.red),
                                  );
                                })
                          ],
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        //Name and text message
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name.toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                data.message.toString(),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blueGrey,
                                  fontWeight:
                                      //FontWeight.bold
                                      FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //Date and New
                    Column(
                      children: [
                        Text(data.time as String,
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w300,
                            )),
                        const SizedBox(
                          height: 6.0,
                        ),
                        isRead
                            ? const Text('')
                            : Container(
                                alignment: Alignment.center,
                                width: 40.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: AppColor.orange,
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text(
                                  "New",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
