import 'package:flutter/material.dart';

import '../../../shared/utils/otp_notification.dart';
import "phone_number_login_widget.dart";
import "../../../shared/widgets/submit_button.dart";

import '../../../config/routes.dart';
import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';

class PhoneNumberLoginView extends StatelessWidget {
  const PhoneNumberLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login\nNomor Telepon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: AppFonts.fontBold,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Masukkan Nomor Telepon",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppFonts.fontBold,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  PhoneNumberInput(
                    hintText: "Telp: 08XXXXXXXXXX",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon tidak boleh kosong';
                      }
                      if (!RegExp(r'^(08)[0-9]{8,}$').hasMatch(value)) {
                        return 'Nomor telepon tidak valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.175),
                  SubmitButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await NotificationService.showNotification(
                          title: "OTP Verifikasi",
                          body: "Kode OTP untuk verifikasi nomor telepon Anda adalah 123456",
                        );
                        Navigator.pushNamed(context, Routes.otpVerification);
                      } else {
                        print("Validation failed");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}