import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/chatters.dart';
import 'package:chat/screens/landingScreen.dart';
import 'package:chat/states/auth_bloc/auth_bloc.dart';
import 'package:chat/states/landing_cubit/landing_cubit.dart';
import 'package:chat/states/logout_cubit/logout_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'const/colors.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc()..add(AuthAppStartedEvent())),
        BlocProvider(create: (context) => LandingCubit()),
        BlocProvider(create: (context) => LogoutCubit()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Metropolis",
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFFFEF9EB)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
            shape: MaterialStateProperty.all(
              const StadiumBorder(),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        indicatorColor: Colors.red,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              AppColor.orange,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColor.orange,
        ),
        textTheme: const TextTheme(
          headline3: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          headline4: TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          headline5: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          headline6: TextStyle(
            color: AppColor.primary,
            fontSize: 25,
          ),
          bodyText2: TextStyle(
            color: AppColor.secondary,
          ),
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.red),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (context, state) {
          if (state is AuthSuccessful) {
            return const HomeScreen();
          } else if (state is AuthUnSuccessful) {
            return LandingScreen();
          }
          return LandingScreen();
        },
      ),
      routes: {
        LandingScreen.routeName: (context) => LandingScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
        Chatters.routeName: (context) => Chatters()
      },
    );
  }
}
