import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:chat/const/app_const.dart';
import 'package:chat/const/colors.dart';
import 'package:chat/screens/chatters.dart';
import 'package:chat/screens/landingScreen.dart';
import 'package:chat/services/repository/firebase_repo.dart';
import 'package:chat/states/logout_cubit/logout_cubit.dart';
import 'package:chat/widgets/recent_chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late var fetchUserChatRoom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchUserChatRoom = FirebaseRepo.instance.fetchUserChatRoom().snapshots();
    FirebaseRepo.instance.updateStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseRepo.instance.updateStatus(true);
    } else {
      FirebaseRepo.instance.updateStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          Navigator.pushNamedAndRemoveUntil<dynamic>(
            context,
            LandingScreen.routeName,
            (route) => false, //if you want to disable back feature set to false
          );
        }
        if (state is LogoutUnSuccessState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message.toString())));
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.orange,
        appBar: AppBar(
          backgroundColor: AppColor.orange,
          elevation: 0.0,
          centerTitle: true,
          title: Center(
            child: Column(
              children: [
                const Text(
                  "Chats",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "(${FirebaseRepo.instance.getCurrentUser()!.email!.split('@')[0]})",
                  style: const TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout_sharp),
                onPressed: () => BlocProvider.of<LogoutCubit>(context).logOut())
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Chatters.routeName);
          },
          tooltip: 'Global Users',
          child: const Icon(Icons.add),
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
                stream: fetchUserChatRoom,
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
                    return RecentChats(docs: snapshot.data!.docs);
                  }
                }),
          ),
        ),
      ),
    );
  }
}
