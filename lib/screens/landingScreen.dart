import 'package:chat/const/app_const.dart';
import 'package:chat/const/colors.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:chat/states/landing_cubit/landing_cubit.dart';
import 'package:chat/utils/helper.dart';
import 'package:chat/widgets/customTextInput.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proste_shadow_clip/proste_shadow_clip.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = "/landingScreen";
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password= '';
  bool _isValidEmail = false;
  bool _isValidPassword = false;

  LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: Helper.getScreenWidth(context),
          height: Helper.getScreenHeight(context),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ProsteShadowClip(
                  clipper: CustomClipperAppBar(),
                  shadow: const [
                    BoxShadow(
                      color: AppColor.placeholder,
                      offset: Offset(0, 15),
                      blurRadius: 10,
                    ),
                  ],
                  child: Container(
                    width: double.infinity,
                    height: Helper.getScreenHeight(context) * 0.15,
                    decoration: ShapeDecoration(
                      color: AppColor.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: ProsteShadowClip(
                    clipper: CustomClipperAppBar(),
                    shadow: const [
                      BoxShadow(
                        color: AppColor.placeholder,
                        offset: Offset(0, 10),
                        blurRadius: 10,
                      ),
                    ],
                    child: Container(
                      width: double.infinity,
                      height: Helper.getScreenHeight(context) * 0.1,
                      decoration: ShapeDecoration(
                        color: AppColor.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Helper.getScreenHeight(context) * 0.1,
              ),

              /// ========== FIELDS ============

              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: Helper.getScreenHeight(context) * 0.5,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email:",
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: Helper.getScreenHeight(context) * 0.01,
                        ),
                        CustomTextInput(
                          hintText: 'Email',
                          onChange: (value) {
                            _isValidEmail = EmailValidator.validate(value);
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                          onValidate: (value) =>
                              (value!.trim().isEmpty || !_isValidEmail)
                                  ? AppConst.invalidEmailError
                                  : null,
                        ),
                        SizedBox(
                          height: Helper.getScreenHeight(context) * 0.03,
                        ),
                        const Text(
                          "Password:",
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: Helper.getScreenHeight(context) * 0.01,
                        ),
                        CustomTextInput(
                          hintText: 'Password',
                          onChange: (value) {
                            _isValidPassword = RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
                                .hasMatch(value);
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                          onValidate: (value) =>
                              (value!.trim().isEmpty || !_isValidPassword)
                                  ? AppConst.invalidPassError
                                  : null,
                        ),
                        const Spacer(flex: 2),

                        /// ====== BUTTONS =========

                        BlocConsumer<LandingCubit, LandingState>(
                          listener: (context, state) {
                            if (state is LandingSuccessState) {
                              Navigator.pushNamedAndRemoveUntil<dynamic>(
                                context,
                                HomeScreen.routeName,
                                (route) =>
                                    false, //if you want to disable back feature set to false
                              );
                            } else if (state is LandingUnSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(state.message.toString())));
                            }
                          },
                          builder: (context, state) {
                            if (state is LandingLoadingState) {
                              return getCircularProgress();
                            }
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        BlocProvider.of<LandingCubit>(context)
                                            .logInButtonPressedEvent(
                                                _email, _password);
                                      }
                                    },
                                    child: const Text("Login"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              AppColor.orange),
                                      shape: MaterialStateProperty.all(
                                        const StadiumBorder(
                                          side: BorderSide(
                                              color: AppColor.orange,
                                              width: 1.5),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        BlocProvider.of<LandingCubit>(context)
                                            .signUpButtonPressedEvent(
                                                _email, _password);
                                      }
                                    },
                                    child: const Text("Create an Account"),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomClipperAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlPoint = Offset(size.width * 0.24, size.height);
    Offset endPoint = Offset(size.width * 0.25, size.height * 0.96);
    Offset controlPoint2 = Offset(size.width * 0.3, size.height * 0.78);
    Offset endPoint2 = Offset(size.width * 0.5, size.height * 0.78);
    Offset controlPoint3 = Offset(size.width * 0.7, size.height * 0.78);
    Offset endPoint3 = Offset(size.width * 0.75, size.height * 0.96);
    Offset controlPoint4 = Offset(size.width * 0.76, size.height);
    Offset endPoint4 = Offset(size.width * 0.79, size.height);
    Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width * 0.21, size.height)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      )
      ..quadraticBezierTo(
        controlPoint2.dx,
        controlPoint2.dy,
        endPoint2.dx,
        endPoint2.dy,
      )
      ..quadraticBezierTo(
        controlPoint3.dx,
        controlPoint3.dy,
        endPoint3.dx,
        endPoint3.dy,
      )
      ..quadraticBezierTo(
        controlPoint4.dx,
        controlPoint4.dy,
        endPoint4.dx,
        endPoint4.dy,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
