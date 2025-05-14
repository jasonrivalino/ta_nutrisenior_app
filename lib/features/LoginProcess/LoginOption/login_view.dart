import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login_widget.dart';

import '../../../config/routes.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
              // Add Image Logo
              Image.asset(
                'assets/images/transparentAppLogo.png',
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
                      text: "Login dengan Nomor Telepon",
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.phoneNumberLogin);
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    LoginButton.withImage(
                      imagePath: 'assets/images/media/google.png',
                      text: "Login dengan Akun Google",
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.homePage),
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