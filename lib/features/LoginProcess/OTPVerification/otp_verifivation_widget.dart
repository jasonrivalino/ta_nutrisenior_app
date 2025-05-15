import 'package:flutter/material.dart';
import '../../../shared/styles/colors.dart';
import '../../../config/constants.dart';
import '../../../shared/utils/validate_otp.dart';

class OTPVerificationInput extends StatefulWidget {
  final GlobalKey<FormState>? formKey;

  const OTPVerificationInput({super.key, this.formKey});

  @override
  State<OTPVerificationInput> createState() => OTPVerificationInputState();
}

class OTPVerificationInputState extends State<OTPVerificationInput> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  String? _errorText;
  String? get errorText => _errorText;

  void validateAndSetState() {
    final result = validateOTP(_controllers, AppConstants.otpVerificationCode);
    setState(() {
      _errorText = result;
    });
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = _errorText != null;

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                width: 50,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: TextFormField(
                  focusNode: _focusNodes[index],
                  controller: _controllers[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  showCursor: false,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.soapstone,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isError ? AppColors.persianRed : AppColors.dark, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isError ? AppColors.persianRed : AppColors.dark, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isError ? AppColors.persianRed : AppColors.dark, width: 2.0),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorText!,
                  style: const TextStyle(color: AppColors.persianRed, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}