import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/fonts.dart';
import '../../../shared/utils/otp_notification.dart';
import "../../../shared/widgets/submit_button.dart";

import "phone_number_login_widget.dart";

class PhoneNumberLoginView extends StatefulWidget {
  const PhoneNumberLoginView({super.key});

  @override
  State<PhoneNumberLoginView> createState() => _PhoneNumberLoginViewState();
}

class _PhoneNumberLoginViewState extends State<PhoneNumberLoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ecruWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Login\nNomor Telepon",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
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
                        if (!RegExp(r'^08[0-9]{9,11}$').hasMatch(value)) {
                          return 'Nomor telepon tidak valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.175),
                    SubmitButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await NotificationService.showNotification(
                            title: "OTP Verifikasi",
                            body: "Kode OTP untuk verifikasi nomor telepon Anda adalah 123456",
                          );
                          context.push('/login/phone/otp');
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
      ),
    );
  }
}