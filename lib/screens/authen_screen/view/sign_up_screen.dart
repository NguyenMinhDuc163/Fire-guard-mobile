import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/authen_screen/provider/auth_view_model.dart';
import 'package:fire_guard/screens/authen_screen/view/login_screen.dart';
import 'package:fire_guard/screens/authen_screen/widget/custom_rich_text_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/dividerR_row_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/password_text_field_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/primary_button_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/primary_text_form_field_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/secondary_button_widget.dart';
import 'package:fire_guard/screens/authen_screen/widget/terms_and_privacyText_widget.dart';
import 'package:fire_guard/utils/utils.dart';
import 'package:fire_guard/screens/widger/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'package:provider/provider.dart';
import '../../../init.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/sign_up_screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController firstName;
  late TextEditingController lastName; // Sửa lại tên biến từ `listName` thành `lastName`
  late TextEditingController emailC;
  late TextEditingController passwordC;
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
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: height_4, vertical: height_24),

                child: Column(
                  children: [
                    Text(
                      'auth.create_account'.tr(),
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
                      'auth.welcome_message'.tr(),
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
                              'auth.first_name'.tr(),
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
                              'auth.last_name'.tr(),
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
                          'auth.email'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorPalette.kGrayscaleDark100,
                          ),
                        ),
                        const SizedBox(height: 7),
                        PrimaryTextFormFieldWidget(
                          borderRadius: BorderRadius.circular(24),
                          hintText: 'auth.email_example'.tr(),
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
                          'auth.password'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorPalette.kGrayscaleDark100,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PasswordTextFieldWidget(
                          borderRadius: BorderRadius.circular(24),
                          hintText: 'auth.password'.tr(),
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
                            if(emailC.text.trim().isEmpty || passwordC.text.trim().isEmpty || !Utils.isValidEmail(emailC.text.trim())){
                              showToast(message: 'auth.invalid_email_password'.tr());
                              return;
                            }

                            bool isRegister = await authViewModel.signUp(
                              firstName: firstName.text.trim(),
                              lastName: lastName.text.trim(),
                              email: emailC.text.trim(),
                              password: passwordC.text.trim(),
                            );
                            if(isRegister){
                              Navigator.pushNamed(context, LoginScreen.routeName);
                            }
                          },
                          text: 'auth.create_account'.tr(),
                          bgColor: ColorPalette.kPrimary,
                          borderRadius: 20,
                          height: 46,
                          width: 327,
                          textColor: ColorPalette.kWhite,
                        ),
                        const SizedBox(height: 20),
                        CustomRichTextWidget(
                          title: 'auth.already_have_account'.tr(),
                          subtitle: 'auth.login'.tr(),
                          onTab: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 40),
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 15),
                    //         child: DividerRowWidget(title: 'auth.or_sign_up_with'.tr()),
                    //       ),
                    //       const SizedBox(height: 24),
                    //       SecondaryButtonWidget(
                    //         height: 56,
                    //         textColor: ColorPalette.kGrayscaleDark100,
                    //         width: 300,
                    //         onTap: () {},
                    //         borderRadius: 24,
                    //         bgColor: ColorPalette.kBackground.withOpacity(0.3),
                    //         text: 'auth.continue_with_google'.tr(),
                    //         icons: AssetHelper.kGoogleIcon,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 23),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TermsAndPrivacyTextWidget(
                        title1: 'auth.by_signing_up'.tr(),
                        title2: 'auth.terms'.tr(),
                        title3: 'auth.and'.tr(),
                        title4: 'auth.conditions_of_use'.tr(),
                      ),
                    ),
                  ],
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
