import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/res/core/constants/dimension_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fire_guard/global/common/toast.dart';
import 'package:fire_guard/models/user_model.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';
import 'package:fire_guard/res/core/helpers/asset_helper.dart';
import 'package:fire_guard/service/auth_services/auth_service.dart';
import 'package:fire_guard/service/auth_services/auth_with_firebase.dart';
import 'package:fire_guard/utils/router_names.dart';

import '../../viewModel/auth_view_model.dart';
import 'widget/custom_rich_text_widget.dart';
import 'widget/dividerR_row_widget.dart';
import 'widget/password_text_field_widget.dart';
import 'widget/primary_button_widget.dart';
import 'widget/primary_text_form_field_widget.dart';
import 'widget/secondary_button_widget.dart';
import 'widget/terms_and_privacyText_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController firstName;
  late TextEditingController lastName; // Sửa lại tên biến từ `listName` thành `lastName`
  late TextEditingController emailC;
  late TextEditingController passwordC;
  final AuthService _auth = AuthWithFirebase();
  @override
  void initState() {
    super.initState();
    firstName = TextEditingController();
    lastName = TextEditingController();
    emailC = TextEditingController();
    passwordC = TextEditingController();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      backgroundColor: ColorPalette.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: height_4, vertical: height_24),

          child: Column(
            children: [
              Text(
                'create_account'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  color: ColorPalette.kGrayscaleDark100,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'welcome_message'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorPalette.kGrayscale40,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'first_name'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.kGrayscaleDark100,
                        ),
                      ),
                       SizedBox(height: height_8),
                      PrimaryTextFormFieldWidget(
                        borderRadius: BorderRadius.circular(24),
                        hintText: 'Nguyen',
                        controller: firstName,
                        width: 155,
                        height: 52,
                      ),
                    ],
                  ),
                  SizedBox(width: height_16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'last_name'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.kGrayscaleDark100,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PrimaryTextFormFieldWidget(
                        borderRadius: BorderRadius.circular(24),
                        hintText: 'Van A',
                        controller: lastName,
                        width: 155,
                        height: 52,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'email'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.kGrayscaleDark100,
                    ),
                  ),
                  const SizedBox(height: 7),
                  PrimaryTextFormFieldWidget(
                    borderRadius: BorderRadius.circular(24),
                    hintText: 'abc@gmail.com',
                    controller: emailC,
                    width: 327,
                    height: 52,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'password'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.kGrayscaleDark100,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PasswordTextFieldWidget(
                    borderRadius: BorderRadius.circular(24),
                    hintText: 'password'.tr(),
                    controller: passwordC,
                    width: 327,
                    height: 52,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Column(
                children: [
                  PrimaryButtonWidget(
                    elevation: 0,
                    onTap: () async {
                      //TODO sign up
                      UserModel? user = await _auth.signUpWithEmailAndPassWord(
                        email: emailC.text.trim(),
                        password: passwordC.text.trim(),
                        userName: '${firstName.text} ${lastName.text}',
                      );
                      if(user != null){
                        showToast(message: 'Sign up success');
                        Navigator.pushNamed(context, RouteNames.loginScreen);
                      }
                      else{
                        showToast(message: 'Sign up failed');
                      }
                    },
                    text: 'create_account'.tr(),
                    bgColor: ColorPalette.kPrimary,
                    borderRadius: 20,
                    height: 46,
                    width: 327,
                    textColor: ColorPalette.kWhite,
                  ),
                  const SizedBox(height: 20),
                  CustomRichTextWidget(
                    title: 'already_have_account'.tr(),
                    subtitle: 'login'.tr(),
                    onTab: () {
                      Navigator.pushNamed(context, RouteNames.loginScreen);
                    },
                    subtitleTextStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DividerRowWidget(title: 'or_sign_up_with'.tr()),
                    ),
                    const SizedBox(height: 24),
                    SecondaryButtonWidget(
                      height: 56,
                      textColor: ColorPalette.kGrayscaleDark100,
                      width: 260,
                      onTap: () {},
                      borderRadius: 24,
                      bgColor: ColorPalette.kBackground.withOpacity(0.3),
                      text: 'continue_with_google'.tr(),
                      icons: AssetHelper.kGoogleIcon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 23),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TermsAndPrivacyTextWidget(
                  title1: 'by_signing_up'.tr(),
                  title2: 'terms'.tr(),
                  title3: 'and'.tr(),
                  title4: 'conditions_of_use'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
