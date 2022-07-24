import 'package:chat/const/colors.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/services/models/chat_args.dart';
import 'package:chat/services/models/userInfo_model.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatterX extends StatelessWidget {
  const ChatterX({Key? key, required this.docs}) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> docs;

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
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            final data = UserInfoModel.fromMap(
                docs[index].data() as Map<String, dynamic>);

            if (docs[index].id != FirebaseRepo.instance.getCurrentUser()!.uid) {
              return GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, ChatScreen.routeName,
                      arguments:
                      ChatArgs(data.email.split('@')[0], docs[index].id)),
              child: Container(
                margin:
                const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 6.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //Profile picture
                        CircleAvatar(
                          radius: 22.0,
                          backgroundColor: AppColor.placeholderBg,
                          child: Text(data.email.substring(0, 1).toUpperCase()),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        //Name and text message
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.email.split('@')[0],
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              const SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                data.email.toString(),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w300,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
