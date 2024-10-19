import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import 'widget/primary_button_widget.dart';
import 'widget/primary_text_form_field_widget.dart';
import '../../../init.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailC;

  @override
  void initState() {
    super.initState();
    emailC = TextEditingController();
  }

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: 327,
            child: Column(
              children: [
                Text(
                  'forgot_password'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(
                      color: ColorPalette.kGrayscaleDark100, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'dont_worry'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.kGrayscale40,
                  ),
                ),
                const SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorPalette.kGrayscaleDark100,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    PrimaryTextFormFieldWidget(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'abc@gmail.com',
                      controller: emailC,
                      width: 327,
                      height: 52,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    PrimaryButtonWidget(
                      elevation: 0,
                      onTap: () async {
                      },
                      text: 'send_code'.tr(),
                      bgColor: ColorPalette.kPrimary,
                      borderRadius: 20,
                      height: 46,
                      width: 327,
                      textColor: ColorPalette.kWhite,
                      fontSize: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
