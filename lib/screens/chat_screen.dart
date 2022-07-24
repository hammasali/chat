import 'package:chat/const/app_const.dart';
import 'package:chat/const/colors.dart';
import 'package:chat/services/models/chat_args.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:chat/widgets/build_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController? _controller;
  Query? _fetchChat;
  bool? _isWriting;
  late String senderName;

  @override
  void initState() {
    _controller = TextEditingController();
    _isWriting = false;
    senderName = FirebaseRepo.instance.getCurrentUser()!.email!.split('@')[0];
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ChatArgs;
    _fetchChat = FirebaseRepo.instance.fetchUserChat(args.uid);



    return Scaffold(
      backgroundColor: AppColor.orange,
      appBar: AppBar(
        backgroundColor: AppColor.orange,
        title: Center(
          child: Text(
            args.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.transparent,
              ),
              iconSize: 25.0,
              onPressed: () => {})
        ],
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _fetchChat!.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: getCircularProgress(),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error_outline);
                } else {
                  return Expanded(child: BuildMessages(snapshot.data!.docs,args.uid));
                }
              },
            ),
            _buildMessageComposer(args),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer(ChatArgs args) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            border:
                Border.all(width: 1.5, color: Theme.of(context).primaryColor)),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              onChanged: (val) {
                (val.isNotEmpty && val.trim() != '')
                    ? setState(() {
                        _isWriting = true;
                      })
                    : setState(() {
                        _isWriting = false;
                      });
              },
              keyboardType: TextInputType.multiline,
              cursorColor: Theme.of(context).primaryColor,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration.collapsed(
                hintText: AppConst.sendAMessageHint,
              ),
            )),
            _isWriting == true
                ? IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                    onPressed: () {
                      FirebaseRepo.instance.addMessageToDB(
                          message: _controller!.text,
                          receiverId: args.uid,
                          receiverName: args.name,
                          senderName: senderName);
                      _controller!.text = '';
                      setState(() {
                        _isWriting = false;
                      });
                    },
                  )
                : IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
          ],
        ),
      ),
    );
  }
}
