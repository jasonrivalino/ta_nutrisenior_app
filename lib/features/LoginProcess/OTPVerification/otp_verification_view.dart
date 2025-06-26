import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/texts.dart';
import '../../../shared/widgets/elevated_button.dart';

import 'otp_verifivation_widget.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({super.key});

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  final GlobalKey<OTPVerificationInputState> _otpWidgetKey = GlobalKey<OTPVerificationInputState>();

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verifikasi OTP\nNomor Telepon",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textBold(
                        size: 40,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Masukkan Kode Verifikasi",
                        textAlign: TextAlign.left,
                        style: AppTextStyles.textBold(
                          size: 20,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    OTPVerificationInput(key: _otpWidgetKey),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.175),
                    ElevatedButtonWidget.submitFormButton(
                      onPressed: () async {
                        // Check internet connection
                        final connectivityResult = await Connectivity().checkConnectivity();
                        if (connectivityResult.contains(ConnectivityResult.none)) {
                          Fluttertoast.showToast(
                            msg: "Login tidak berhasil. \nSilahkan ulangi...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          return;
                        }

                        // Proceed with OTP validation ONLY if internet is available
                        _otpWidgetKey.currentState?.validateAndSetState();
                        if (_otpWidgetKey.currentState?.errorText == null) {
                          context.go('/homepage');
                          print("OTP valid!");
                        } else {
                          print("OTP not valid!");
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