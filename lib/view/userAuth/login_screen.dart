import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/service/common/status_api.dart';
/// import 'package:fire_guard/service/auth_services/auth_with_firebase.dart'; // Firebase Authentication
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

import '../../../init.dart';
import '../../viewModel/auth_view_model.dart';
import 'widget/custom_rich_text_widget.dart';
import 'widget/dividerR_row_widget.dart';
import 'widget/icon_language_widget.dart';
import 'widget/password_text_field_widget.dart';
import 'widget/primary_button_widget.dart';
import 'widget/primary_text_button_widget.dart';
import 'widget/primary_text_form_field_widget.dart';
import 'widget/secondary_button_widget.dart';
import 'widget/terms_and_privacyText_widget.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailC;
  late TextEditingController passwordC;
  late TextEditingController apiUrlController;
  late TextEditingController apiPortController;
  /// final authService = AuthWithFirebase(); // Firebase Authentication Service
  bool isVietnamese = true;

  @override
  void initState() {
    super.initState();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    apiUrlController = TextEditingController(text: StatusApi.BASE_API_URL);
    apiPortController = TextEditingController(text: "3000");
    // Kiểm tra ngôn ngữ đã lưu trong Hive
    String? savedLocale = LocalStorageHelper.getValue('languageCode');
    if (savedLocale != null) {
      isVietnamese = savedLocale == 'vi';
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    apiUrlController.dispose();
    apiPortController.dispose();

    super.dispose();
  }

  void redirectSelectPreferencesScreen() async {
    // màn hình này chỉ xuất hiện trong lần khởi động đầu tiên
    final ignoreSelectPreferencesScreen = LocalStorageHelper.getValue('ignoreSelectPreferencesScreen') as bool?;
    await Future.delayed(const Duration(milliseconds: 1000));
    if (ignoreSelectPreferencesScreen != null && ignoreSelectPreferencesScreen) {
      Navigator.of(context).pushNamed(RouteNames.mainApp);
      // Navigator.of(context).pushNamed(IntroScreen.routeName);
    } else {
      LocalStorageHelper.setValue('ignoreSelectPreferencesScreen', true);
      Navigator.of(context).pushNamed(RouteNames.selectPreferencesScreen);
    }
    // Navigator.of(context).pushNamed(RouteNames.introScreen);
  }

  @override
  Widget build(BuildContext context) {


    final authViewModel = Provider.of<AuthViewModel>(context);
    final model = authViewModel.model;

    void _showApiConfigSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Cho phép `BottomSheet` mở toàn màn hình nếu cần.
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5, // Chiều cao ban đầu (50% màn hình).
            minChildSize: 0.3, // Chiều cao tối thiểu (30% màn hình).
            maxChildSize: 0.8, // Chiều cao tối đa (80% màn hình).
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController, // Để cuộn nếu nội dung nhiều.
                  children: [
                    const Text(
                      "API Configuration",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: apiUrlController,
                      decoration: const InputDecoration(labelText: "API URL"),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: apiPortController,
                      decoration: const InputDecoration(labelText: "Port"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          StatusApi.BASE_API_URL =
                          "${apiUrlController.text}:${apiPortController.text}/api/v1/";
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return KeyboardDismisser(
      gestures: const [GestureType.onTap],
      child: Scaffold(
        backgroundColor: ColorPalette.kWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy 2 nút ra 2 bên
            children: [
              // Nút Config ở bên trái
              GestureDetector(
                onTap: _showApiConfigSheet,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: const Icon(Icons.settings, color: Colors.white),
                ),
              ),
      
              // Nút Chuyển Ngôn Ngữ ở bên phải
              GestureDetector(
                onTap: () {
                  isVietnamese = !isVietnamese;
                  if (isVietnamese) {
                    context.setLocale(const Locale('vi', 'VN'));
                    LocalStorageHelper.setValue('languageCode', 'vi');
                  } else {
                    context.setLocale(const Locale('en', 'US'));
                    LocalStorageHelper.setValue('languageCode', 'en');
                  }
                },
                child: Container(
                  width: 65,
                  height: 42,
                  padding: const EdgeInsets.all(8),
                  child: isVietnamese
                      ? const IconLanguageWidget(
                      name: "VN", path: AssetHelper.icoVN)
                      : const IconLanguageWidget(
                      name: "EN", path: AssetHelper.icoAmerica),
                ),
              ),
            ],
          ),
        )
        ,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height_4, vertical: height_24),
            child: Column(
              children: [
                Text(
                  'welcome_back'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(color: ColorPalette.kGrayscaleDark100, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  'happy_to_see_you'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.kGrayscale40,
                  ),
                ),
                SizedBox(height: height_24),
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
                    const SizedBox(height: 8),
                    PrimaryTextFormFieldWidget(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'abc@gmail.com',
                      controller: emailC,
                      width: width_300,
                      height: height_40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                      width: width_300,
                      height: height_40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: width_230),
                  child: Row(
                    children: [
                      PrimaryTextButtonWidget(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.forgotPasswordScreen);
                        },
                        title: 'forgot_password'.tr(),
                        textStyle: const TextStyle(color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    PrimaryButtonWidget(
                      elevation: 0,
                      onTap: () async {
                        // TODO login
                        print('----------------- ${StatusApi.BASE_API_URL}');
            
                          if(emailC.text.trim().isEmpty || passwordC.text.trim().isEmpty || !Utils.isValidEmail(emailC.text.trim())){
                            showToast(message: 'invalid_email_password'.tr());
                            return;
                          }
                        Navigator.pushNamed(context, RouteNames.mainApp);

                      },
                      text: 'login'.tr(),
                      bgColor: ColorPalette.kPrimary,
                      borderRadius: 20,
                      height: 46,
                      width: 327,
                      textColor: ColorPalette.kWhite,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CustomRichTextWidget(
                        title: 'dont_have_account'.tr(),
                        subtitle: 'create_here'.tr(),
                        onTab: () {
                          Navigator.pushNamed(context, RouteNames.signUpScreen);
                        },
                        subtitleTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.kPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      DividerRowWidget(title: "or_sign_in_with".tr()),
                      const SizedBox(height: 24),
                      SecondaryButtonWidget(
                        height: 56,
                        textColor: ColorPalette.kGrayscaleDark100,
                        width: 300,
                        onTap: () {},
                        borderRadius: 24,
                        bgColor: ColorPalette.kBackground.withOpacity(0.3),
                        text: 'continue_with_google'.tr(),
                        icons: AssetHelper.kGoogleIcon,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TermsAndPrivacyTextWidget(
                    title1: 'by_signing_up'.tr(),
                    title2: 'terms'.tr(),
                    title3: 'and'.tr(),
                    title4: 'conditions_of_use'.tr(),
                  ),
                ),
                const SizedBox(height: 24),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
