import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/constants.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/google_auth_service.dart';

import 'login_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 56,
                  fontFamily: AppFonts.fontBold,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
              Image.asset(
                AppConstants.transparentAppLogo,
                width: 250,
                height: 250,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.075),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    LoginButton(
                      icon: FaIcon(FontAwesomeIcons.phone),
                      text: "Login Nomor Telepon",
                      onPressed: () {
                        context.push('/login/phone');
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    LoginButton.withImage(
                      imagePath: AppConstants.googleLogo,
                      text: "Login Akun Google",
                      onPressed: () async {
                        try {
                          final GoogleSignInAccount? googleUser =
                              await GoogleAuthService.googleSignIn.signIn();
                          if (googleUser == null) {
                            Fluttertoast.showToast(
                              msg: "Login tidak berhasil. \nSilakan ulangi.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                            return;
                          }

                          // Retrieve user info
                          final String? userName = googleUser.displayName;
                          final String userEmail = googleUser.email;

                          // Save to SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('userName', userName ?? '');
                          await prefs.setString('userEmail', userEmail);

                          // Navigate to home
                          context.go('/homepage');
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: "Login tidak berhasil. \nSilahkan ulangi..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}