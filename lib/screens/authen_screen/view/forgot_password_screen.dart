import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/authen_screen/widget/StrikethroughPainter.dart';
import 'package:fire_guard/screens/authen_screen/widget/primary_button_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/primary_text_form_field_widget.dart';
import 'package:fire_guard/screens/widger/LoadingWidget.dart';
import 'package:fire_guard/utils/core/extentions/size_extension.dart';
import 'package:fire_guard/screens/authen_screen/provider/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';


import '../../../init.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}


class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailC;
  TextEditingController securityCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    emailC = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthViewModel>(context, listen: false).generateCaptcha();
    });
  }

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final model = authViewModel.model;
    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
        backgroundColor: ColorPalette.kWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        'auth.forgot_password'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ).copyWith(
                            color: ColorPalette.kGrayscaleDark100, fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'auth.dont_worry'.tr(),
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
                            'auth.email'.tr(),
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
                            hintText: 'auth.email_example'.tr(),
                            controller: emailC,
                            width: 327,
                            height: 52,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 20.h, left: width_16),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryTextFormFieldWidget(
                                borderRadius: BorderRadius.circular(24),
                                hintText: 'auth.security_code'.tr(),
                                controller: securityCodeController,
                                width: double.infinity,
                                height: 52,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                onTap: () => authViewModel.generateCaptcha(),
                                child: SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: CustomPaint(
                                    painter: StrikethroughPainter(model.captchaText),
                                    child: Center(
                                      child: Text(
                                        model.captchaText,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.blue),
                              onPressed: () {
                                authViewModel.generateCaptcha();
                              },
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          PrimaryButtonWidget(
                            elevation: 0,
                            onTap: () async {
                              if(model.captchaText.isEmpty) {
                                showToastTop(message: 'auth.please_enter_captcha'.tr());
                                return;
                              }
                              bool isForgot = false;
                              if (securityCodeController.text == model.captchaText) {
                                isForgot = await authViewModel.sendForgotPassword(email: emailC.text.trim());
                              } else {
                                showToast(message: 'auth.error_captcha'.tr());
                              }

                              print("model.captchaText: ${model.captchaText}");

                              authViewModel.generateCaptcha();
                              if(isForgot){
                                Navigator.pop(context);
                              }
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
            authViewModel.isLoading ? const LoadingWidget() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
