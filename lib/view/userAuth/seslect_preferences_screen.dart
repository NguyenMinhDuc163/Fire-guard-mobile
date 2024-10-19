import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../init.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum UserType { teacher, student }

class SelectPreferencesScreen extends StatefulWidget {
  const SelectPreferencesScreen({super.key});

  @override
  State<SelectPreferencesScreen> createState() => _SelectPreferencesScreenState();
}

class _SelectPreferencesScreenState extends State<SelectPreferencesScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late AnimationController rippleController;
  late AnimationController scaleController;
  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    rippleController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    scaleController = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });

    rippleAnimation = Tween<double>(begin: 80.0, end: 90.0).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });

    scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(scaleController);

    rippleController.forward();
  }

  @override
  void dispose() {
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.kWhite,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const WaveCard(height: 495),
                PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: [
                    UserTypeView(
                      onUserTypeSelected: (userType) {
                        debugPrint(userType.toString());
                      },
                    ),
                    SetupStoreView(
                      onChanged: (value) {
                        debugPrint(value);
                      },
                    ),
                    FascinateView(
                      onChanged: (categories) {
                        debugPrint(categories.toString());
                      },
                    ),
                    // const SetupCompleteView(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          CustomIndicator(
            controller: _pageController,
            dotsLength: 4,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _currentIndex < 2
                ? PrimaryButton(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Future<void>.delayed(const Duration(milliseconds: 500)).then(
                        (value) => {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                          ),
                        },
                      );
                    },
                    text: 'continue'.tr(),
                  )
                : AnimatedBuilder(
                    animation: scaleAnimation,
                    builder: (context, child) => Transform.scale(
                      scale: scaleAnimation.value,
                      child: PrimaryButton(
                        onTap: () {
                          scaleController.forward();
                          Navigator.pushNamed(context, RouteNames.mainApp);
                        },
                        text: scaleController.isAnimating || scaleController.isCompleted ? '' : 'Continue',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FascinateView extends StatefulWidget {
  final Function(List<Category>?)? onChanged;
  const FascinateView({required this.onChanged, super.key});

  @override
  State<FascinateView> createState() => _FascinateViewState();
}

class _FascinateViewState extends State<FascinateView> {
  List<Category> selectedCategories = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 120),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child:  Center(
              child: Text(
                'what_fascinates_you'.tr(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child:  Center(
              child: Text(
                'customized_quiz_experience'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Center(
            child: Wrap(
              spacing: 15,
              runSpacing: 20,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                categoriesList.length,
                (index) => CustomChips(
                  onTap: () {
                    if (selectedCategories.contains(categoriesList[index])) {
                      selectedCategories.remove(categoriesList[index]);
                    } else {
                      selectedCategories.add(categoriesList[index]);
                      widget.onChanged!(selectedCategories);
                    }
                    setState(() {});
                  },
                  index: index,
                  category: categoriesList[index],
                  isSelected: selectedCategories.contains(categoriesList[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomChips extends StatelessWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;
  final bool isSelected;
  const CustomChips({
    required this.isSelected,
    required this.category,
    required this.index,
    required this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

    return FadeIn(
      delay: const Duration(milliseconds: 200) * index,
      child: AnimatedButton(
        onTap: onTap,
        child: PrimaryContainer(
          color: isSelected
              ? ColorPalette.kPrimary
              : isDarkMode(context)
                  ? Colors.black
                  : ColorPalette.kWhite,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(category.image),
              SizedBox(
                width: index == 0
                    ? 37
                    : index == 2
                        ? 20
                        : 27,
              ),
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? ColorPalette.kWhite
                      : isDarkMode(context)
                          ? Colors.white
                          : ColorPalette.kSecondary,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  String id;
  String name;
  String image;
  Category({
    required this.id,
    required this.name,
    required this.image,
  });
}

List<Category> categoriesList = [
  // Category(id: '1', name: 'Gaming', image: AssetHelper.icoLogo),
  // Category(id: '2', name: 'Music', image: AssetHelper.kMusic),
  // Category(id: '3', name: 'Photography', image: AssetHelper.kPhotography),
  // Category(id: '4', name: 'Art', image: AssetHelper.kArt),
  // Category(id: '5', name: 'Design', image: AssetHelper.kDesign),
  // Category(id: '6', name: 'Business', image: AssetHelper.kBusiness),
  // Category(id: '7', name: 'LifeStyle', image: AssetHelper.kLifeStyle),
  // Category(id: '8', name: 'Coding', image: AssetHelper.kCoding),
];

class SetupStoreView extends StatefulWidget {
  final Function(String?)? onChanged;
  const SetupStoreView({super.key, this.onChanged});

  @override
  State<SetupStoreView> createState() => _SetupStoreViewState();
}

class _SetupStoreViewState extends State<SetupStoreView> {
  final TextEditingController storeName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(AssetHelper.onboarding_1),
          const SizedBox(height: 90),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child:  Text(
              'what_should_we_call_you'.tr(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child:  Text(
              'you_can_change_later'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 30),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child: AuthField(
              controller: storeName,
              hintText: 'Name',
              onChanged: (value) {
                widget.onChanged!(value);
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String hintText;
  const AuthField({
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  const PrimaryContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF329494).withOpacity(0.2),
            blurRadius: 7,
            offset: const Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class UserTypeCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isSelected;
  final String image;
  const UserTypeCard({
    required this.onTap,
    required this.isSelected,
    required this.text,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedButton(
        onTap: onTap,
        child: Container(
          width: 160,
          height: 270,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? ColorPalette.kPrimary : ColorPalette.kWhite,
            boxShadow: [ColorPalette.defaultShadow],
          ),
          child: Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? ColorPalette.kWhite : ColorPalette.kSecondary,
                ),
              ),
              const Spacer(),
              Image.asset(image),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserTypeView extends StatefulWidget {
  final void Function(UserType)? onUserTypeSelected;
  const UserTypeView({super.key, this.onUserTypeSelected});

  @override
  State<UserTypeView> createState() => _UserTypeViewState();
}

class _UserTypeViewState extends State<UserTypeView> {
  UserType userType = UserType.teacher;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child:  Text(
              'join_quizz_pro'.tr(),
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: ColorPalette.kSecondary),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            duration: const Duration(milliseconds: 1000),
            child:  Text(
              'join_as_student_or_teacher'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: ColorPalette.kSecondary),
            ),
          ),
          const SizedBox(height: 40),
          FadeInRight(
            duration: const Duration(milliseconds: 1000),
            child: SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: UserTypeCard(
                      onTap: () {
                        setState(() {
                          userType = UserType.teacher;
                        });
                        widget.onUserTypeSelected?.call(userType);
                      },
                      isSelected: userType == UserType.teacher,
                      image: AssetHelper.kTeacher,
                      // text: UserType.teacher.name.capitalizeFirst.toString(),
                      text: "teacher".tr(),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: UserTypeCard(
                      onTap: () {
                        setState(() {
                          userType = UserType.student;
                        });
                        widget.onUserTypeSelected?.call(userType);
                      },
                      isSelected: userType == UserType.student,
                      image: AssetHelper.kStudent,
                      // text: UserType.student.name.capitalizeFirst.toString(),
                      text: "student".tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class WaveCard extends StatelessWidget {
  final double? height;
  final Color? color;
  const WaveCard({super.key, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 350,
      width: double.infinity,
      color: color ?? const Color(0xFF329494).withOpacity(0.15),
      child: CustomPaint(
        painter: WavePainter(
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(
      size.width,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.625,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.875,
      0,
      size.height * 0.75,
    );
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CustomIndicator extends StatelessWidget {
  final PageController controller;
  final int dotsLength;
  final double? height;
  final double? width;
  const CustomIndicator({
    required this.controller,
    required this.dotsLength,
    this.height,
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: dotsLength,
      onDotClicked: (index) {},
      effect: SlideEffect(
        dotColor: const Color(0xFF1D2445).withOpacity(0.3),
        activeDotColor: const Color(0xFF1D2445),
        dotHeight: height ?? 8,
        dotWidth: width ?? 8,
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? color;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          height: widget.height ?? 60,
          alignment: Alignment.center,
          width: widget.width ?? double.maxFinite,
          decoration: BoxDecoration(
            color: widget.color ?? (isDarkMode(context) ? Colors.black : const Color(0xFF329494)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF329494).withOpacity(0.2),
                blurRadius: 7,
                offset: const Offset(0, 5),
              )
            ],
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? 10,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.color == null ? Colors.white : Colors.black,
              fontSize: widget.fontSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final double? size;
  final Color? color;
  final String icon;
  final Color? iconColor;
  const CustomIconButton({
    required this.onTap,
    required this.icon,
    this.size,
    this.color,
    this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
            height: widget.size ?? 40,
            alignment: Alignment.center,
            width: widget.size ?? 40,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.color ?? (isDarkMode(context) ? Colors.black : const Color(0xFFFFFFFF)),
              shape: BoxShape.circle,
            ),
            child: const Placeholder()),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const AnimatedButton({required this.child, required this.onTap, super.key});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
